type 'string elt = { french : 'string; english : 'string }

type 'string t = I of 'string | V of 'string elt

type language = French | English

val to_string : language -> 'string t -> 'string
