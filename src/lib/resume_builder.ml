open Core
open Resume

let latex_url text = "\\url{" ^ text ^ "}"

let to_latex (resume : t) language =
  let md_printer = Cmarkit_latex.of_doc in
  let escaper = Escapers.latex in
  Multi_string.(
    match language with
    | French ->
        Templates.latex_fr (to_t' ~escaper language md_printer resume)
    | English ->
        Templates.latex_en (to_t' ~escaper language md_printer resume) )

let to_html (resume : t) language =
  let md_printer = Cmarkit_html.of_doc ~safe:false in
  let escaper s =
    let pattern = String.Search_pattern.create "\n" in
    String.Search_pattern.replace_all pattern ~in_:s ~with_:"<br>"
  in
  Multi_string.(
    match language with
    | French ->
        to_t' ~escaper language md_printer resume
    | English ->
        to_t' ~escaper language md_printer resume )
