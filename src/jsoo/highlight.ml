open Brr

let ( .%{} ) obj prop = Jv.get obj prop

let ( !% ) = Jstr.of_string

let highlight_snippet el =
  Console.log [!%"highlighting"; el] ;
  let src =
    (El.to_jv el).%{"innerHTML"} |> Jv.to_string |> Highlexer.unescape
  in
  let annotated = Highlexer.of_string src in
  let html =
    List.map
      (fun Highlexer.{tag; content} ->
        match tag with
        | Some tag ->
            El.(span ~at:At.[class' !%tag] [txt !%content])
        | None ->
            El.txt !%content )
      annotated
  in
  El.set_children el html

let () =
  let ocaml_snippets = Brr.El.find_by_class !%"language-ocaml" in
  Console.log ["ocaml snippets"; ocaml_snippets] ;
  List.iter highlight_snippet ocaml_snippets
