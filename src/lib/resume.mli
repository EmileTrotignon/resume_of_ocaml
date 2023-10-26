type t =
  { intro: string Multi_string.t
  ; formations: Formation.t list
  ; experiences: Experience.t list
  ; skills: Skill.t list
  ; languages: Language.t list
  ; firstname: string Multi_string.t
  ; lastname: string Multi_string.t
  ; phonenumber: string Multi_string.t
  ; email: string Multi_string.t
  ; website: string Multi_string.t
  ; birthdate: string Multi_string.t }

type t' =
  { intro: string
  ; formations: Formation.t' list
  ; experiences: Experience.t' list
  ; skills: Skill.t' list
  ; languages: Language.t' list
  ; firstname: string
  ; lastname: string
  ; phonenumber: string
  ; email: string
  ; website: string
  ; birthdate: string }

val to_t' : ?escaper:(string -> string) -> Multi_string.language -> Runtime_template.model -> t -> t'

val make :
     intro:string Multi_string.t
  -> formations:Formation.t list
  -> experiences:Experience.t list
  -> skills:Skill.t list
  -> languages:Language.t list
  -> firstname:string Multi_string.t
  -> lastname:string Multi_string.t
  -> phonenumber:string Multi_string.t
  -> email:string Multi_string.t
  -> website:string Multi_string.t
  -> birthdate:string Multi_string.t
  -> t
