open Core

let latex s =
  let pattern_hashtag = String.Search_pattern.create "#" in
  let pattern_percent = String.Search_pattern.create "%" in
  let s =
    String.Search_pattern.replace_all pattern_hashtag ~in_:s ~with_:"\\#"
  in
  let s =
    String.Search_pattern.replace_all pattern_percent ~in_:s ~with_:"\\%"
  in
  s
