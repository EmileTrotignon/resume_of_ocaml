open Core

type t =
  { title: string Multi_string.t
  ; description: Runtime_template.t Multi_string.t option
  ; company: string Multi_string.t
  ; location: string Multi_string.t option
  ; date: string Multi_string.t }

type t' = {title: string; description: string; company: string; location: string; date: string}

let to_t' ?(escaper = Fn.id) language model ({title; description; company; location; date} : t) : t' =
  { title= escaper (Multi_string.to_string language title)
  ; description=
      ( match description with
      | Some d ->
          escaper (Runtime_template.render (Multi_string.to_string language d) model)
      | None ->
          "" )
  ; company= escaper (Multi_string.to_string language company)
  ; location= (match location with Some l -> escaper (Multi_string.to_string language l) | None -> "")
  ; date= escaper (Multi_string.to_string language date) }

let make title ?description company ?location date : t = {title; description; company; location; date}
