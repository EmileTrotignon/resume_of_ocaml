type 'string t = I of 'string | V of {french: 'string; english: 'string}

type language = French | English

val to_string : language -> 'string t -> 'string

val i : 'string -> 'string t

val v : french:'string -> english:'string -> 'string t
(** [v ~french ~english] *)
