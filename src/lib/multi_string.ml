type 'string elt = { french : 'string; english : 'string }

type 'string t = I of 'string | V of 'string elt

type language = French | English

let to_string language multi_string =
  match multi_string with
  | I s -> s
  | V { french = french_s; english = english_s } -> (
      match language with French -> french_s | English -> english_s )
