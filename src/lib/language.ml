type t = {name: string Multi_string.t; strength: Strength.t}
type t' = {name: string; strength: Strength.t}

let to_t' ?(escaper = Core.Fn.id) language ({name; strength} : t) : t' =
  {name= escaper (Multi_string.to_string language name); strength}

let make name strength : t = {name; strength}
