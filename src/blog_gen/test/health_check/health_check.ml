open Blog_gen
open Result_syntax

let contains text regexp =
  match Tyre.exec regexp text with
  | Ok () ->
      true
  | Error (`NoMatch _) ->
      false
  | Error _ ->
      assert false

let path_regexp path =
  Tyre.(compile (str {|(|} *> str (String.concat "/" path) *> str {|)|}))

let rec mentions path Blog.{name; content} =
  let regexp = path_regexp path in
  match content with
  | Blog.Article {source; html= _} ->
      contains source regexp
  | Blog.File {content= _} ->
      false
  | Blog.Dir {index_html= _; index_source; sub} ->

      let path =
        match path with
        | [] ->
            ["readme.md"]
        | hd :: tl when name = hd ->
            tl
        | path ->
            ".." :: path
      in
      ( match index_source with
      | None ->
          false
      | Some index_source ->
          let regexp = path_regexp path in
          contains index_source regexp )
      || List.exists (mentions path) sub

let check_mention path blog =
  if mentions path blog then ()
  else Printf.printf "%S is not mentionned\n" (String.concat "/" path)

let rec health_check whole_blog path_rev ({name; content} : Blog.t) =
  let path_rev = name :: path_rev in
  let path = List.rev path_rev in
  match content with
  | Blog.Article _ | Blog.File {content= _} ->
      check_mention path whole_blog
  | Blog.Dir {index_html= _; index_source; sub} ->
      if Option.is_some index_source then check_mention path whole_blog ;
      List.iter (health_check whole_blog path_rev) sub

let health_check blog = Ok (health_check blog [] blog)

let main input =
  let* input = Fpath.of_string input in
  let* blog = Blog.load input in
  health_check blog

let main input =
  main input
  |> Result.map_error (fun err -> Format.asprintf "%a" Rresult.R.pp_msg err)

open Cmdliner

let input =
  let doc = "Directory were the mardown files are." in
  Arg.(required & pos 0 (some file) None (info [] ~docv:"INPUT" ~doc))

let cmd =
  let doc = "Generate html files from markdown structure" in
  let info = Cmd.info "blog_gen" ~version:"%%VERSION%%" ~doc in
  Cmd.v info Term.(const main $ input)

let main () = exit (Cmd.eval_result cmd)

let () = main ()
