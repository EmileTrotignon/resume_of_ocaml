type t = Basic | Intermediate | Strong | VeryStrong

let to_mstring strength =
  match strength with
  | Basic -> Multi_string.V { french = "basique"; english = "basic" }
  | Intermediate ->
      Multi_string.V { french = "intermediaire"; english = "intermediate" }
  | Strong -> Multi_string.V { french = "fort"; english = "strong" }
  | VeryStrong ->
      Multi_string.V { french = "tres fort"; english = "very strong" }
