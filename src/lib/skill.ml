type t =
  { name: string Multi_string.t
  ; strength: Strength.t
  ; description: Cmarkit.Doc.t Multi_string.t option }

type t' = {name: string; strength: Strength.t; description: string}

let to_t' ?(escaper = Core.Fn.id) language md_printer
    ({name; strength; description} : t) : t' =
  { name= escaper (Multi_string.to_string language name)
  ; strength
  ; description=
      ( match description with
      | Some d ->
            (md_printer (Multi_string.to_string language d) )
      | None ->
          "" ) }

let make ?description name strength : t = {name; strength; description}
