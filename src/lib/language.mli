type t = { name : string Multi_string.t; strength : Strength.t }

type t' = { name : string; strength : Strength.t }

val to_t' : ?escaper:(string -> string) -> Multi_string.language -> t -> t'
