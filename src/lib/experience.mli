type t =
  { title: string Multi_string.t
  ; description: Cmarkit.Doc.t Multi_string.t option
  ; company: string Multi_string.t
  ; location: string Multi_string.t option
  ; date: string Multi_string.t }

type t' =
  { title: string
  ; description: string
  ; company: string
  ; location: string
  ; date: string }

val to_t' :
     ?escaper:(string -> string)
  -> Multi_string.language
  -> (Cmarkit.Doc.t -> string)
  -> t
  -> t'

val make :
     string Multi_string.t
  -> ?description:Cmarkit.Doc.t Multi_string.t
  -> string Multi_string.t
  -> ?location:string Multi_string.t
  -> string Multi_string.t
  -> t
(** [make title ?description company ?location date] *)
