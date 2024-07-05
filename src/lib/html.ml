open Tyxml
open Html

let breadcrumbs bc =
  ul
    ~a:[a_id "breadcrumbs"]
    (List.map
       (fun (path, name) ->
         li [a ~a:[a_href ("/" ^ String.concat "/" path)] [txt name]] )
       bc )

let contact (cv : Resume.t') =
  section
    [ p
        [ a
            ~a:[a_href "https://github.com/EmileTrotignon"]
            [ img ~src:"/icons/github-icon.svg" ~alt:"Github icon"
                ~a:[a_class ["icon"]]
                ()
            ; txt "Github" ] ]
    ; p
        [ a
            ~a:[a_href {%eml|mailto:<%- cv.email %>|}]
            [ span
                ~a:[a_class ["icon"]]
                [i ~a:[a_class ["fas"; "fa-envelope"; "fa-lg"]] []]
            ; txt cv.email ] ]
    ; p [txt {%eml|Born <%=cv.birthdate%>|}] ]

let navmenu current =
  let navmenu_item ?id name url =
    a
      ~a:
        ( [ a_href url
          ; a_class
              ( "button"
              :: (if String.equal name current then ["current"] else []) ) ]
        @ match id with None -> [] | Some id -> [a_id id] )
      [txt name]
  in
  section
    ~a:[a_id "navmenu"]
    [ navmenu_item "Index" "/"
    ; navmenu_item "Software" "/software"
    ; navmenu_item "Resume" "/resume"
    ; navmenu_item ~id:"blog-navlink" "Blog" "/blog" ]

let sidebar items = nav ~a:[a_id "sidebar"] items

let page (cv : Resume.t') content =
  html
    ~a:[a_lang "en"]
    (head
       (title
          (txt {%eml|<%- cv.firstname %> <%- cv.lastname %>'s personal page|}) )
       [ meta ~a:[a_charset "utf-8"] ()
       ; meta
           ~a:
             [a_name "viewport"; a_content "width=device-width, initial-scale=1"]
           ()
       ; link ~rel:[`Stylesheet] ~href:"/style.css" ()
       ; link ~rel:[`Stylesheet]
           ~href:
             "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap"
           ()
       ; link ~rel:[`Stylesheet]
           ~href:
             "https://fonts.googleapis.com/css2?family=Fira+Sans&display=swap"
           ()
       ; script
           ~a:
             [ a_src "https://kit.fontawesome.com/0c027fe19b.js"
             ; a_crossorigin `Anonymous ]
           (txt "") ] )
    (body
       [ header
           [ canvas
               ~a:
                 [ Unsafe.string_attrib "resize" "true"
                 ; a_id "voronoi"
                 ; a_style "user-select: none;"
                 ; Unsafe.string_attrib "data-paper-scope" "1" ]
               []
           ; h1
               [ a
                   ~a:[a_href "/"]
                   [txt {%eml|<%- cv.firstname %> <%- cv.lastname %>|}] ] ]
       ; div ~a:[a_id "body"] content
       ; script ~a:[a_src "/highlight.js"] (txt "")
       ; script ~a:[a_src "/voronoi.js"] (txt "") ] )

let txt = Unsafe.data

let resume (cv : Resume.t') =
  let icon_of_string s =
    let icon_of_filename filename =
      img
        ~a:[a_class ["icon"]]
        ~src:{%eml|icons/<%- filename %>|} ~alt:filename ()
    in
    match Core.String.lowercase s with
    | "ocaml" ->
        Some (icon_of_filename "ocaml-icon.svg")
    | "c++" | "cpp" ->
        Some (icon_of_filename "cpp-icon.svg")
    | "c#" ->
        Some (icon_of_filename "c-sharp-icon.svg")
    | "python" ->
        Some (icon_of_filename "python-icon.svg")
    | _ ->
        None
  in
  let strength s =
    match (s : Strength.t) with
    | Basic ->
        span ~a:[a_class ["strength-1"]] []
    | Intermediate ->
        span ~a:[a_class ["strength-2"]] []
    | Strong ->
        span ~a:[a_class ["strength-3"]] []
    | VeryStrong ->
        span ~a:[a_class ["strength-4"]] []
  in
  let breadcrumbs = breadcrumbs @@ Breadcrumbs.of_string_list ["resume"] in
  let language (l : Language.t') =
    p
      ~a:[a_class ["strength-item"]]
      [ txt l.name
      ; ( match l.strength with
        | Basic ->
            span ~a:[a_class ["strength-1"]] []
        | Intermediate ->
            span ~a:[a_class ["strength-2"]] []
        | Strong ->
            span ~a:[a_class ["strength-3"]] []
        | VeryStrong ->
            span ~a:[a_class ["strength-4"]] [] ) ]
  in
  let _sidebar_skill (s : Skill.t') =
    p
      [ a
          ~a:[a_href {%eml|#<%- s.name %>|}; a_class ["strength-item"]]
          ( ( match icon_of_string s.name with
            | Some icon ->
                span [icon; txt s.name]
            | None ->
                span [txt s.name] )
          :: [strength s.strength] ) ]
  in
  let formation (f : Formation.t') =
    div
      ~a:[a_class ["item"]]
      [ h3 [txt f.school]
      ; div
          ~a:[a_class ["subtitle"]]
          ( (if f.location <> "" then [txt (f.location ^ ", ")] else [])
          @ [txt (f.date_start ^ " - " ^ f.date_end)] )
      ; p [txt (f.diploma ^ (if f.result <> "" then " - " else "") ^ f.result)]
      ; p [txt f.description] ]
  in
  let experience (e : Experience.t') =
    div
      ~a:[a_class ["item"]]
      [ h3 [txt e.title]
      ; div
          ~a:[a_class ["subtitle"]]
          [txt (e.location ^ (if e.location <> "" then ", " else "") ^ e.date)]
      ; p [txt e.description] ]
  in
  let skill (s : Skill.t') =
    div
      ~a:[a_class ["item"]]
      [ h3
          ~a:[a_id s.name; a_class ["strength-item"]]
          [txt s.name; strength s.strength]
      ; p [txt s.description] ]
  in
  page cv
    [ sidebar
        [ navmenu "Resume"
        ; contact cv
        ; section ([h2 [txt "Languages"]] @ List.map language cv.languages)
          (*section
            ([h2 [txt "Technical skills"]] @ List.map sidebar_skill cv.skills)*)
        ]
    ; breadcrumbs
    ; article
        ~a:[a_id "content"]
        [ section ([h2 [txt "Formation"]] @ List.map formation cv.formations)
        ; section ([h2 [txt "Experience"]] @ List.map experience cv.experiences)
        ; section ([h2 [txt "Technical skills"]] @ List.map skill cv.skills) ]
    ]

let index cv =
  let breadcrumbs = breadcrumbs @@ Breadcrumbs.of_string_list [] in
  page cv
    [ sidebar [navmenu "Index"; contact cv]
    ; breadcrumbs
    ; article
        ~a:[a_id "content"]
        [ section
            [ p [txt "Welcome to my home page"]
            ; p
                [ txt
                    {|I used to be a student in computer science at ENS Paris-Saclay, nowadays I am a dev at Tarides,
were I work on tools for ocaml like odoc and ocamlformat.

I am very interested in the OCaml language and programming languages in general.
You can check some of my projects out on my <a href="https://github.com/EmileTrotignon">github</a>,
and my resume on this website.|}
                ] ] ] ]

type software = {url: string; name: string; description: string}

let software cv =
  let one_software {url; name; description} =
    li [a ~a:[a_href url] [txt name]; txt ", "; txt description]
  in
  let breadcrumbs = breadcrumbs @@ Breadcrumbs.of_string_list ["software"] in
  let creations =
    [ { url= "https://github.com/EmileTrotignon/embedded_ocaml_templates"
      ; name= "ocaml_embedded_templates"
      ; description= "a template engine that uses OCaml as its logic." }
    ; { url= "https://github.com/EmileTrotignon/highlexer"
      ; name= "highlexer"
      ; description= "an accurate code highlighter for OCaml." } ]
  in
  let contributions =
    [ { url= "https://github.com/ocaml-ppx/ocamlformat"
      ; name= "ocamlformat"
      ; description= "the OCaml code formatter." }
    ; { url= "https://github.com/ocaml/odoc"
      ; name= "odoc"
      ; description= "the modern OCaml documentation generator." }
    ; { url= "https://github.com/art-w/sherlodoc"
      ; name= "sherlodoc"
      ; description= "a search engine for OCaml documentation." }
    ; { url= "https://github.com/art-w/gamelle"
      ; name= "gamelle"
      ; description=
          "An OCaml 2D game library with browser and native backends." }
    ; { url= "https://github.com/ocaml/dune"
      ; name= "dune"
      ; description= "the OCaml build system." }
    ; { url= "https://gallium.inria.fr/~fpottier/menhir/"
      ; name= "menhir"
      ; description= "the OCaml LR1 parser generator." } ]
  in
  page cv
    [ sidebar [navmenu "Software"; contact cv]
    ; breadcrumbs
    ; article
        ~a:[a_id "content"]
        [ section
            [ p [txt "I am responsible for the following projects:"]
            ; ul (List.map one_software creations)
            ; p [txt "I have also contributed to the following projects:"]
            ; ul (List.map one_software contributions) ] ] ]

let page_404 cv =
  page cv
    [ sidebar [navmenu "Error 404"; contact cv]
    ; article
        ~a:[a_id "content"]
        [section [h1 [txt "Error 404 : page was not found."]]] ]

let to_string ty = Format.asprintf "%a" (Tyxml_html.pp ()) ty

let blog cv blog bc =
  (*
    <%# (cv: Resume.t') (blog: string) breadcrumbs %>
<%- page_top cv %>
    <%- Components.sidebar_top %>
        <%- Components.navmenu "Blog" %>
        <%- Components.contact cv %>
    <%- Components.sidebar_bot %>
    <%- Components.breadcrumbs breadcrumbs %>
    <div id="content-wrapper">
        <article id="content">
            <%- blog %>
        </article>
    </div>

<%- page_bot %>*)
  page cv
    [ sidebar [navmenu "Blog"; contact cv]
    ; breadcrumbs bc
    ; article ~a:[a_id "content"] [Unsafe.data blog] ]
