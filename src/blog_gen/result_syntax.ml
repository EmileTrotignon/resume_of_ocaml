let ( let* ) e f = Result.bind e f

  let ( let+ ) e f = Result.map f e

  let rec list_map f li acc =
    match li with
    | [] ->
        Ok (List.rev acc)
    | elt :: li ->
        let* elt = f elt in
        list_map f li (elt :: acc)

  let list_map f li = list_map f li []

  let rec list_iter f li =
    match li with
    | [] ->
        Ok ()
    | elt :: li ->
        let* () = f elt in
        list_iter f li

  let add_msg ~msg r = 
    Result.map_error (fun (`Msg msg') -> `Msg (msg ^ "\n" ^ msg')) r