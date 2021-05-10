open Core
open Resume

let latex_url text = "\\url{" ^ text ^ "}"

let to_latex (resume : t) language =
  let model = [("url", fun s -> "\\url{" ^ s ^ "}")] in
  let escaper s =
    let pattern = String.Search_pattern.create "#" in
    String.Search_pattern.replace_all pattern ~in_:s ~with_:"\\#" in
  Multi_string.(
    match language with
    | French -> Templates.latex_fr (to_t' ~escaper language model resume)
    | English -> Templates.latex_en (to_t' ~escaper language model resume))

let to_html (resume : t) language =
  let model = [("url", fun s -> "<a href='" ^ s ^ "'>" ^ s ^ "</a>")] in
  let escaper s =
    let pattern = String.Search_pattern.create "\n" in
    String.Search_pattern.replace_all pattern ~in_:s ~with_:"<br>" in
  Multi_string.(
    match language with
    | French -> to_t' ~escaper language model resume
    | English -> to_t' ~escaper language model resume)
