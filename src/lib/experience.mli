type t = {
  title : string Multi_string.t;
  description : Runtime_template.t Multi_string.t option;
  company : string Multi_string.t;
  location : string Multi_string.t option;
  date : string Multi_string.t;
}

type t' = {
  title : string;
  description : string;
  company : string;
  location : string;
  date : string;
}

val to_t' : ?escaper:(string -> string) -> Multi_string.language -> Runtime_template.model -> t -> t'
