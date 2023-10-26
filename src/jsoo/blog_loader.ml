open Brr
open Fut.Syntax
open Printf

let don't_wait_for f = Fut.await f (fun () -> ())

let ( .%{} ) obj prop = Jv.get obj prop

let ( !% ) = Jstr.of_string

let name_no_suffix name =
  assert (String.ends_with ~suffix:".md" name) ;
  String.sub name 0 (String.length name - 3)

let name_pretty name = name |> name_no_suffix |> String.split_on_char '_' |> String.concat " "

let name_html name = name_no_suffix name ^ ".html"

let article_nav_section articles =
  let document = G.document in
  let navbar = Document.(find_el_by_id document !%"sidebar" |> Option.get) in
  let blog_section =
    El.(
      section
        ~at:At.[id !%"blog_nav"]
        (List.map
           (fun ((article_name : string), _content) ->
             p [a ~at:At.[href !%(sprintf "/blog/%s" (name_html article_name))] [txt !%(name_pretty article_name)]] )
           articles ) )
  in
  El.append_children navbar [blog_section]

let run () =
  let+ result =
    let open Fut.Result_syntax in
    let open Brr_io.Fetch in
    let* response =
      Brr_io.Fetch.(
        request (Request.v ~init:(Request.init ()) !%"https://api.github.com/repos/EmileTrotignon/blog/contents/") )
    in
    let* data = response |> Response.as_body |> Body.json in
    let urls = Jv.(to_array (fun elt -> (to_string elt.%{"name"}, to_string elt.%{"git_url"})) data) in
    let open Fut.Syntax in
    let names, urls = Array.split urls in
    let* contents =
      urls
      |> Array.map (fun md_url -> Brr_io.Fetch.(request (Request.v ~init:(Request.init ()) (Jstr.of_string md_url))))
      |> Array.to_list |> Fut.of_list
      |> Fut.map (List.map Result.get_ok)
    in
    let+ contents =
      contents
      |> List.map (fun response -> response |> Response.as_body |> Body.json)
      |> Fut.of_list
      |> Fut.map (List.map Result.get_ok)
    in
    let contents = List.map (fun jv -> Base64.decode (Jv.to_jstr jv.%{"content"}) |> Result.get_ok) contents in
    let articles = List.combine (Array.to_list names) contents in
    article_nav_section articles ;
    Console.log [data] ;
    Result.ok @@ Console.log [contents]
  in
  match result with Error _e -> () | Ok () -> ()

let () = don't_wait_for (run ())
