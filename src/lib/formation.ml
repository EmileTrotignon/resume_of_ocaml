open Core

type t = {
  school : string Multi_string.t;
  diploma : string Multi_string.t;
  description : Runtime_template.t Multi_string.t option;
  location : string Multi_string.t option;
  date_start : string Multi_string.t option;
  date_end : string Multi_string.t option;
  result : string Multi_string.t option;
}

type t' = {
  school : string;
  diploma : string;
  description : string;
  location : string;
  date_start : string;
  date_end : string;
  result : string;
}

let to_t' ?(escaper = Fn.id) language model
    ({ school; diploma; description; location; date_start; date_end; result } :
      t) : t' =
  {
    school = escaper (Multi_string.to_string language school);
    diploma = escaper (Multi_string.to_string language diploma);
    description =
      ( match description with
      | Some description ->
          escaper
            (Runtime_template.render
               (Multi_string.to_string language description)
               model)
      | None -> "" );
    location =
      ( match location with
      | Some location -> escaper (Multi_string.to_string language location)
      | None -> "" );
    date_start =
      ( match date_start with
      | Some date_start -> escaper (Multi_string.to_string language date_start)
      | None -> "" );
    date_end =
      ( match date_end with
      | Some date_end -> escaper (Multi_string.to_string language date_end)
      | None -> "" );
    result =
      ( match result with
      | Some result -> escaper (Multi_string.to_string language result)
      | None -> "" );
  }
