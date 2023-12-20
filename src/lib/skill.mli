type t =
  { name: string Multi_string.t
  ; strength: Strength.t
  ; description: Cmarkit.Doc.t Multi_string.t option }

type t' = {name: string; strength: Strength.t; description: string}

val to_t' :
     ?escaper:(string -> string)
  -> Multi_string.language
  -> (Cmarkit.Doc.t -> string)
  -> t
  -> t'

val make :
     ?description:Cmarkit.Doc.t Multi_string.t
  -> string Multi_string.t
  -> Strength.t
  -> t
(** [Skill.make name ~description strength]*)
