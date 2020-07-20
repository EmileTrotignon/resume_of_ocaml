open Core

type t = {
  formations : Formation.t list;
  experiences : Experience.t list;
  skills : Skill.t list;
  languages : Language.t list;
  firstname : string Multi_string.t;
  lastname : string Multi_string.t;
  phonenumber : string Multi_string.t;
  email : string Multi_string.t;
  website : string Multi_string.t;
  birthdate : string Multi_string.t;
}

type t' = {
  formations : Formation.t' list;
  experiences : Experience.t' list;
  skills : Skill.t' list;
  languages : Language.t' list;
  firstname : string;
  lastname : string;
  phonenumber : string;
  email : string;
  website : string;
  birthdate : string;
}

let to_t' ?(escaper = Core.Fn.id) language model
    ({
       formations;
       experiences;
       skills;
       languages;
       firstname;
       lastname;
       phonenumber;
       email;
       website;
       birthdate;
     } :
      t) : t' =
  {
    formations =
      List.map ~f:(Formation.to_t' ~escaper language model) formations;
    experiences =
      List.map ~f:(Experience.to_t' ~escaper language model) experiences;
    skills = List.map ~f:(Skill.to_t' ~escaper language model) skills;
    languages = List.map ~f:(Language.to_t' ~escaper language) languages;
    firstname = escaper (Multi_string.to_string language firstname);
    lastname = escaper (Multi_string.to_string language lastname);
    phonenumber = escaper (Multi_string.to_string language phonenumber);
    email = escaper (Multi_string.to_string language email);
    website = escaper (Multi_string.to_string language website);
    birthdate = escaper (Multi_string.to_string language birthdate);
  }
