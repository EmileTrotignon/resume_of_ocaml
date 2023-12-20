type t =
  { school: string Multi_string.t
  ; diploma: string Multi_string.t
  ; description: Cmarkit.Doc.t Multi_string.t option
  ; location: string Multi_string.t option
  ; date_start: string Multi_string.t option
  ; date_end: string Multi_string.t option
  ; result: string Multi_string.t option }

type t' =
  { school: string
  ; diploma: string
  ; description: string
  ; location: string
  ; date_start: string
  ; date_end: string
  ; result: string }

val to_t' :
     ?escaper:(string -> string)
  -> Multi_string.language
  -> (Cmarkit.Doc.t -> string)
  -> t
  -> t'

val make :
     ?description:Cmarkit.Doc.t Multi_string.t
  -> ?location:string Multi_string.t
  -> ?date_start:string Multi_string.t
  -> ?date_end:string Multi_string.t
  -> ?result:string Multi_string.t
  -> string Multi_string.t
  -> string Multi_string.t
  -> t
