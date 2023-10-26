type t = {name: string Multi_string.t; strength: Strength.t; description: Runtime_template.t Multi_string.t option}

type t' = {name: string; strength: Strength.t; description: string}

let to_t' ?(escaper = Core.Fn.id) language model ({name; strength; description} : t) : t' =
  { name= escaper (Multi_string.to_string language name)
  ; strength
  ; description=
      ( match description with
      | Some d ->
          escaper (Runtime_template.render (Multi_string.to_string language d) model)
      | None ->
          "" ) }

let make ?description name strength : t = {name; strength; description}
