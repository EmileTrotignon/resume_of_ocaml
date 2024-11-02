open Blog_gen
open Result_syntax

let main input output =
  let* input = Fpath.of_string input in
  let* output = Fpath.of_string output in
  let* blog = Blog.load input in
  Blog.write ~path:output blog

let main input output =
  main input output
  |> Result.map_error (fun err -> Format.asprintf "%a" Rresult.R.pp_msg err)

open Cmdliner

let input =
  let doc = "Directory were the mardown files are." in
  Arg.(required & pos 0 (some file) None (info [] ~docv:"INPUT" ~doc))

let output =
  let doc = "Directory to output the HTML files to." in
  Arg.(required & pos 1 (some string) None (info [] ~docv:"OUTPUT" ~doc))

let cmd =
  let doc = "Generate html files from markdown structure" in
  let info = Cmd.info "blog_gen" ~version:"%%VERSION%%" ~doc in
  Cmd.v info Term.(const main $ input $ output)

let main () = exit (Cmd.eval_result cmd)

let () = main ()
