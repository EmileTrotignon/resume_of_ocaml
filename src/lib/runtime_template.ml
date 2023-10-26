open Core

type elt = S of string | F of string * string

type t = elt list

type model = (string * (string -> string)) list

let render template (model : model) =
  let strings = ref [] in
  let append s = strings := s :: !strings in
  let rec aux template =
    match template with
    | [] ->
        ()
    | e :: template' ->
        ( match e with
        | S s ->
            append s
        | F (fname, s) ->
            let _, f =
              match List.find model ~f:(fun (fname', _) -> String.( = ) fname fname') with
              | Some f' ->
                  f'
              | None ->
                  failwith "function not found"
            in
            append (f s) ) ;
        aux template'
  in
  aux template ;
  String.concat (List.rev !strings)

let f func arg = F (func, arg)

let atom s = [S s]
