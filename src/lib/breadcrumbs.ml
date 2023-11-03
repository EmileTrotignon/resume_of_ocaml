type input = string list

type output = (string list * string) list

let of_string_list input =
  let index_crumb = ([], "~") in
  let _, crumbs =
    List.fold_left_map
      (fun path name ->
        let path = name :: path in
        let crumb = (List.rev path, name) in
        (path, crumb) )
      [] input
  in
  index_crumb :: crumbs
