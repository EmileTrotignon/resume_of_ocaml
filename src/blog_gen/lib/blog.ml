type content =
  | Article of {html: string; source: string}
  | File of {content: string}
  | Dir of {index_html: string; index_source: string option; sub: t list}
[@@deriving show]

and t = {name: string; content: content} [@@deriving show]

open Bos

let is_markdown file = String.ends_with ~suffix:".md" (Fpath.basename file)

open Result_syntax

let is_index file = Fpath.basename file = "readme.md"

let html_into_page ~path html =
  let open Resume_lib in
  let breadcrumbs = path |> List.rev |> Breadcrumbs.of_string_list in
  Html.to_string
  @@ Html.blog
       (Resume_builder.to_html Instance.emile Multi_string.English)
       html breadcrumbs

let html_of_markdown ~path (md : string) =
  html_into_page ~path
    ( md |> Md_transform.insert_nbsp_in_string |> Cmarkit.Doc.of_string |> Md_transform.tranform
    |> Cmarkit_html.of_doc ~safe:false )

let auto_index ~path file (sub_files : Fpath.t list) =
  let open Tyxml.Html in
  let html =
    section
      [ h1 [txt (Fpath.basename file)]
      ; ul
          (List.map
             (fun sub_file ->
               li
                 [ a
                     ~a:[a_href (Fpath.basename sub_file)]
                     [txt (Fpath.basename sub_file)] ] )
             sub_files ) ]
  in
  html_into_page ~path (Format.asprintf "%a" (pp_elt ()) html)

let rec load_dir ~path file : (content, Rresult.R.msg) result =
  let* sub = OS.Dir.contents file |> add_msg ~msg:"load_dir: OS.Dir.contents" in
  let index, sub = List.partition is_index sub in
  let* index_html, index_source =
    match index with
    | [index] ->
        let* index_md =
          OS.File.read index |> add_msg ~msg:"load_dir: OS.File.read"
        in
        Ok (html_of_markdown ~path index_md, Some index_md)
    | [] ->
        Ok (auto_index ~path file sub, None)
    | _ :: _ ->
        Error
          (`Msg
            (Format.asprintf
               "Found multiple file named readme.md in dir %a. Should not \
                happen."
               Fpath.pp file ) )
  in
  let sub = List.filter (fun file -> Fpath.basename file <> "test") sub in
  let+ sub = list_map (load ~path) sub in
  Dir {index_html: string; index_source; sub}

and load_article ~path file =
  let+ md = OS.File.read file |> add_msg ~msg:"load_article: OS.File.read" in
  let html = html_of_markdown ~path md in
  Article {html; source= md}

and load_file file =
  let+ content = OS.File.read file |> add_msg ~msg:"load_file: OS.File.read" in
  File {content}

and load ~path file =
  let name = Fpath.basename file in
  let path = name :: path in
  let+ content =
    let* is_dir = OS.Dir.exists file in
    if is_dir then load_dir ~path file
    else if is_markdown file then load_article ~path file
    else load_file file
  in
  {name; content}

let load = load ~path:[]

let rec write_dir ~path ~name ~index_html ~sub =
  let path = Fpath.(path / name) in
  let* _existed = OS.Dir.create path in
  let* () = OS.File.write Fpath.(path / "index.html") index_html in
  list_iter (write ~path) sub

and write_article ~path ~name ~html =
  let name = Md_transform.suffix_md_to_html name in
  OS.File.write Fpath.(path / name) html

and write_file ~path ~name ~content = OS.File.write Fpath.(path / name) content

and write ~path {name; content} =
  match content with
  | Dir {index_html; index_source= _; sub} ->
      write_dir ~path ~name ~index_html ~sub
  | Article {html; source= _} ->
      write_article ~path ~name ~html
  | File {content} ->
      write_file ~path ~name ~content
