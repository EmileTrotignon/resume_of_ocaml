open Brr
open Fut.Syntax
open Printf

module Option_syntax = struct
  let ( let* ) = Option.bind

  (* wlet ( let+ ) x f = Option.map f x *)
end

let don't_wait_for f = Fut.await f (fun () -> ())

let ( .%{} ) obj prop = Jv.get obj prop

let result_get_msg ~msg r =
  match r with Ok v -> v | Error e -> Console.error [e] ; failwith msg

let option_get_msg ~msg r = match r with Some v -> v | None -> failwith msg

let ( !% ) = Jstr.of_string

let html_of_jstr ?(d = G.document) html =
  (*
  function htmlToElement(html) {
    var template = document.createElement('template');
    html = html.trim(); // Never return a text node of whitespace as the result
    template.innerHTML = html;
    return template.content.firstChild;
}   
  *)
  let template = El.(to_jv @@ v ~d !%"template" []) in
  Jv.set template "innerHTML" (Jv.of_jstr html) ;
  Console.log [template] ;
  Jv.to_list El.of_jv template.%{"content"}.%{"childNodes"}

module Showdown = struct
  (*
  var converter = new showdown.Converter(),
  text      = '# hello, markdown!',
  html      = converter.makeHtml(text);
  *)
  let converter = Jv.(new' global.%{"showdown"}.%{"Converter"} [||])

  let _ = Jv.(apply converter.%{"setFlavor"} [|Jv.of_string "github"|])

  let to_html jstr =
    let jstr = Jv.of_jstr jstr in
    Jv.(apply converter.%{"makeHtml"} [|jstr|] |> to_jstr)
end

let github_base64_decode jstr =
  assert (not Jv.(is_undefined (of_jstr jstr))) ;
  jstr |> Jstr.cuts ~sep:!%{|\n|} |> Jstr.concat |> Base64.decode

type blog_content =
  | Article of {html: Jstr.t}
  | File of {url: Jstr.t}
  | Dir of {index_html: Jstr.t; sub: blog list}

and blog = {name: string; content: blog_content}

let name_no_suffix name =
  if String.ends_with ~suffix:".md" name then
    String.sub name 0 (String.length name - 3)
  else name

let name_pretty name =
  let name =
    name |> name_no_suffix |> String.split_on_char '_' |> String.concat " "
  in
  let first_char = Char.uppercase_ascii name.[0] in
  String.mapi (function 0 -> fun _ -> first_char | _ -> Fun.id) name

let rec html_of_blog blog : El.t =
  let open El in
  let name = blog.name in
  match blog.content with
  | Article {html} ->
      article ([h2 [txt' name]] @ html_of_jstr html)
  | File {url} ->
      a ~at:At.[href url] [txt' name]
  | Dir {index_html; sub} ->
      article
        ([h2 [txt' name]] @ html_of_jstr index_html @ List.map html_of_blog sub)

let html_of_blog_page blog =
  let open El in
  match blog with
  | {name= _; content= Article {html}} ->
      article (html_of_jstr html)
  | {name; content= Dir {index_html; sub}} ->
      let index = html_of_jstr index_html in
      article
        ( [h2 [txt' name]]
        @ index
        @ [ ul
              (List.map
                 (fun {name= sub_name; _} ->
                   li [a ~at:At.[href !%sub_name] [txt' (name_pretty sub_name)]]
                   )
                 sub ) ] )
  | {name; content= File {url}} ->
      a ~at:At.[href url] [txt' name]

let _blog_nav_section articles =
  let document = G.document in
  let navbar =
    Document.(
      find_el_by_id document !%"navmenu"
      |> option_get_msg ~msg:"Did not find navmenu by id" )
  in
  let blog_section =
    El.(
      section
        ~at:At.[id !%"blog_nav"]
        (List.map
           (fun ((article_name : string), _content) ->
             p
               [ a
                   ~at:At.[href !%(sprintf "blog/%s" article_name)]
                   [txt !%(name_pretty article_name)] ] )
           articles ) )
  in
  El.insert_siblings `After navbar [blog_section]

let _insert_blog blog =
  let body =
    Document.(
      find_el_by_id G.document !%"content"
      |> option_get_msg ~msg:"Did not find content by id" )
  in
  El.append_children body [html_of_blog blog]

let load_markdown ~name ~content =
  let html =
    content |> Jv.to_jstr |> github_base64_decode
    |> result_get_msg ~msg:"load_markdown: github_base64_decode failed"
    |> Base64.data_to_binary_jstr |> Showdown.to_html
  in
  Fut.return @@ {name; content= Article {html}}

let load_file ~name ~url =
  let url = Jv.to_jstr url in
  Fut.return @@ {name; content= File {url}}

let rec load_dir ~name ~tree =
  let index_html = ref None in
  let+ sub =
    tree
    |> Jv.to_list (fun elt ->
           let open Brr_io.Fetch in
           let name = Jv.to_string elt.%{"path"} in
           let sub_url = Jv.to_jstr elt.%{"url"} in
           let* response =
             request (Request.v ~init:(Request.init ()) sub_url)
           in
           let response =
             response |> result_get_msg ~msg:"load_dir: Fetch.request failed"
           in
           let* data =
             response |> Response.as_body |> Body.json
             |> Fut.map (result_get_msg ~msg:"load_dir: Body.json failed")
           in
           if name = "readme.md" then (
             index_html :=
               Some
                 ( data.%{"content"} |> Jv.to_jstr |> github_base64_decode
                 |> result_get_msg ~msg:"load_dir: github_base64_decode failed"
                 |> Base64.data_to_binary_jstr |> Showdown.to_html ) ;
             Fut.return None )
           else
             let+ sub = load ~name data in
             Some sub )
    |> Fut.of_list
    |> Fut.map (List.filter_map Fun.id)
  in
  let index_html =
    option_get_msg ~msg:"load_dir: did not find index" !index_html
  in
  {name; content= Dir {index_html; sub}}

and load ~name jv =
  if Jv.has "tree" jv then load_dir ~name ~tree:jv.%{"tree"}
  else if String.ends_with ~suffix:".md" name then
    load_markdown ~name ~content:jv.%{"content"}
  else load_file ~name ~url:jv.%{"url"}

let load_blog blog_url =
  let open Brr_io.Fetch in
  let* response = request (Request.v ~init:(Request.init ()) !%blog_url) in
  let* data =
    response
    |> result_get_msg ~msg:"load_blog: Fetch.request failed"
    |> Response.as_body |> Body.json
    |> Fut.map (result_get_msg ~msg:"loag_blog: Body.json failed")
  in
  let urls =
    Jv.(
      to_array
        (fun elt -> (to_string elt.%{"name"}, to_string elt.%{"git_url"}))
        data )
  in
  let open Fut.Syntax in
  let names, urls = Array.split urls in
  let* contents =
    urls
    |> Array.map (fun md_url ->
           request (Request.v ~init:(Request.init ()) (Jstr.of_string md_url)) )
    |> Array.to_list |> Fut.of_list
    |> Fut.map
         (List.map (result_get_msg ~msg:"load_blog: Fetch.request failed"))
  in
  let* contents =
    contents
    |> List.map (fun response -> response |> Response.as_body |> Body.json)
    |> Fut.of_list
    |> Fut.map (List.map (result_get_msg ~msg:"loag_blog: Body.json failed"))
  in
  let names = Array.to_list names in
  let index_html = ref None in
  let+ sub =
    List.combine names contents
    |> List.filter_map (fun (name, jv) ->
           if name = "readme.md" then (
             index_html :=
               Some
                 ( jv.%{"content"} |> Jv.to_jstr |> github_base64_decode
                 |> result_get_msg ~msg:"load_blog: github_base64_decode failed"
                 |> Base64.data_to_binary_jstr |> Showdown.to_html ) ;
             None )
           else Some (load ~name jv) )
    |> Fut.of_list
  in
  let index_html =
    option_get_msg ~msg:"load_blog: no index found" !index_html
  in
  {name= "blog"; content= Dir {index_html; sub}}

let not_a_blog_page () = Console.log ["This is not a blog page"]

let find_page blog url =
  let path =
    url |> Uri.path_segments
    |> result_get_msg ~msg:"find_page: Uri.path_segments failed"
    |> List.map Jstr.to_string
  in
  let rec find_blog_path = function
    | "blog" :: _ as path ->
        Some path
    | _ :: path ->
        find_blog_path path
    | [] ->
        None
  in
  let open Option_syntax in
  let* blog_path = find_blog_path path in
  let rec find_blog path blog =
    match path with
    | [] ->
        None
    | [name] ->
        if name = blog.name then Some blog else None
    | name :: path ->
        if name = blog.name then
          match blog.content with
          | Dir {sub; _} ->
              List.find_map (find_blog path) sub
          | _ ->
              None
        else None
  in
  find_blog blog_path blog

let handle_404 url =
  don't_wait_for
  @@
  let+ blog =
    load_blog "https://api.github.com/repos/EmileTrotignon/blog/contents/"
  in
  let page = find_page blog url in
  match page with
  | None ->
      not_a_blog_page ()
  | Some page ->
      let body =
        Document.(
          find_el_by_id G.document !%"content"
          |> option_get_msg ~msg:"Did not find content by id" )
      in
      Document.find_el_by_id G.document !%"blog-navlink"
      |> Option.iter (fun navlink -> El.set_class !%"current" true navlink) ;
      El.set_children body [html_of_blog_page page]

let self_url = Window.location G.window

let () = handle_404 self_url

let handle_404_export jstr =
  handle_404 (Uri.of_jstr jstr |> result_get_msg ~msg:"fail")

let () = Jv.(set global "handle_404" (Jv.callback ~arity:1 handle_404_export))
