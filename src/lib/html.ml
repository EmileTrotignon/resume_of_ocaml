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
       ; link ~rel:[`Stylesheet] ~href:"/style.css" ()
       ; link ~rel:[`Stylesheet]
           ~href:
             "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap"
           ()
       ; link ~rel:[`Stylesheet]
           ~href:
             "https://fonts.googleapis.com/css2?family=Fira+Sans&display=swap"
           ()
       ; script ~a:[a_src "/js/rhill-voronoi-core.js"] (txt "")
       ; script
           ~a:
             [ a_src "https://kit.fontawesome.com/0c027fe19b.js"
             ; a_crossorigin `Anonymous ]
           (txt "")
       ; script
           ~a:
             [ a_src
                 "https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.12.11/paper-full.min.js"
             ]
           (txt "")
       ; script
           ~a:
             [ Unsafe.string_attrib "type" "text/paperscript"
             ; Unsafe.string_attrib "canvas" "canvas-1" ]
           (Unsafe.data
              {|
      var voronoi =  new Voronoi();
      var sites = generateBeeHivePoints(view.size / 75, true);
      var speeds = generateSpeeds(view.size / 75);
      console.log(speeds);
      var forces = generateSpeeds(view.size / 75);
      var bbox, diagram;
      var oldSize = view.size;
      var spotColor = new Color('rgba(240, 84, 76, 0.66)');
      var mousePos = view.center;
      var selected = false;

      onResize();

      function onMouseDown(event) {
          sites.push(event.point);
          renderDiagram();
      }

      function onMouseMove(event) {
          mousePos = event.point;
          mousePos.speed = new Point(0.0);
          mousePos.force = new Point(0.0);
          if (event.count == 0)
          {
              sites.push(mousePos);
              speeds.push(new Point(0,0));
              forces.push(new Point(0,0));
          }

          sites[sites.length - 1] = mousePos;
          speeds[speeds.length - 1] = new Point(0,0);
          forces[forces.length - 1] = new Point(0,0);
      }

      function moveSites() {
        for (var i = 0; i < sites.length; i++) {
          if ((sites[i] + speeds[i]).isInside(new Rectangle(new Point(bbox.xl, bbox.yt), new Point(bbox.xr, bbox.yb))))
            sites[i] += speeds[i];
          else
            speeds[i] *= -1;
          //sites[i] = moveToRect(sites[i], new Rectangle(new Point(bbox.xl, bbox.yt), new Point(bbox.xr, bbox.yb)));
          var length = Math.sqrt(speeds[i].x * speeds[i].x + speeds[i].y * speeds[i].y);
          speeds[i] += forces[i];
          var new_length = Math.sqrt(speeds[i].x * speeds[i].x + speeds[i].y * speeds[i].y);
          speeds[i].x = speeds[i].x * length / new_length;
          speeds[i].y = speeds[i].y * length / new_length;
          forces[i] = (Point.random() - new Point(0.5, 0.5)) / 100;
        }
      }

      function moveToRect(point, rect) {
        point2 = new Point(point);
        while(!point2.isInside(rect)) {
          if (point2.x < rect.left)
            point2.x += rect.width;
          if (point2.x > rect.right)
            point2.x -= rect.width;
          if (point2.y < rect.top)
            point2.y += rect.height;
          if (point2.y > rect.bottom)
            point2.y -= rect.height;
        }
        return point2;
      }

      function renderDiagram() {
          project.activeLayer.children = [];
          moveSites();
          var diagram = voronoi.compute(sites, bbox);
          if (diagram) {
              for (var i = 0, l = sites.length; i < l; i++) {
                  var cell = diagram.cells[sites[i].voronoiId];
                  if (cell) {
                      var halfedges = cell.halfedges,
                          length = halfedges.length;
                      if (length > 2) {
                          var points = [];
                          for (var j = 0; j < length; j++) {
                              v = halfedges[j].getEndpoint();
                              points.push(new Point(v));
                          }
                          createPath(points, sites[i]);
                      }
                  }
              }
          }
      }

      function removeSmallBits(path) {
          var averageLength = path.length / path.segments.length;
          var min = path.length / 50;
          for(var i = path.segments.length - 1; i >= 0; i--) {
              var segment = path.segments[i];
              var cur = segment.point;
              var nextSegment = segment.next;
              var next = nextSegment.point + nextSegment.handleIn;
              if (cur.getDistance(next) < min) {
                  segment.remove();
              }
          }
      }

      function generateBeeHivePoints(size, loose) {
          var points = [];
          var col = view.size / size;
          for(var i = -1; i < size.width + 1; i++) {
              for(var j = -1; j < size.height + 1; j++) {
                  var point = new Point(i, j) / new Point(size) * view.size + col / 2;
                  if(j % 2)
                      point += new Point(col.width / 2, 0);
                  if(loose)
                      point += (col) * Point.random() - col / 4;
                  points.push(point);
              }
          }
          return points;
      }

      function generateSpeeds(size)
      {
        var points = [];
          for(var i = -1; i < size.width + 1; i++) {
              for(var j = -1; j < size.height + 1; j++) {
                  var speed = new Point(Math.random()/8, Math.random()/4);
                  points.push(speed);
              }
          }
          return points;
      }

      function createPath(points, center) {
          var paths = new CompoundPath();
          if (!selected) {
              paths.strokeColor = spotColor;
          } else {
              paths.fullySelected = selected;
          }
          //paths.closed = true;

          for (var i = 0, l = points.length; i < l; i++) {
              var point = points[i];
              var next = points[(i + 1) == points.length ? 0 : i + 1];
              var prec = points[(i - 1) == 0 ? points.length -1 : i - 1];
              var vector = (next - point) / 2;
              var path = new Path.Line(point, next);
              path.scale(0.66);

              //var circle = new Path.Circle(point, 1);
              //circle.fillColor = new Color("white");
              paths.addChild(path);
              //paths.addChild(circle);
          }
          //removeSmallBits(path);

          return paths;
      }

      function onResize() {
          var margin = 0;
          bbox = {
              xl: margin,
              xr: view.bounds.width - margin,
              yt: margin,
              yb: view.bounds.height - margin
          };
          for (var i = 0, l = sites.length; i < l; i++) {
              sites[i] = sites[i] * view.size / oldSize;
          }
          oldSize = view.size;
      }
      function onFrame(event) {
          renderDiagram();
      }
      /*function onKeyDown(event) {
          if (event.key == 'space') {
              selected = !selected;
              renderDiagram();
          }
      }*/
      |} )
       ] )
    (body
       [ header
           [ canvas
               ~a:
                 [ Unsafe.string_attrib "resize" "true"
                 ; a_id "canvas-1"
                 ; a_style "user-select: none;"
                 ; Unsafe.string_attrib "data-paper-scope" "1" ]
               []
           ; h1
               [ a
                   ~a:[a_href "/"]
                   [txt {%eml|<%- cv.firstname %> <%- cv.lastname %>|}] ] ]
       ; div ~a:[a_id "body"] content
       ; script ~a:[a_src "/highlight.js"] (txt "") ] )

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
  let sidebar_skill (s : Skill.t') =
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
      ; p [txt (f.diploma ^ if f.result <> "" then " - " else "" ^ f.result)]
      ; p [txt f.description] ]
  in
  let experience (e : Experience.t') =
    div
      ~a:[a_class ["item"]]
      [ h3 [txt e.title]
      ; div
          ~a:[a_class ["subtitle"]]
          [txt (e.location ^ if e.location <> "" then ", " else "" ^ e.date)]
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
        ; section
            ([h2 [txt "Technical skills"]] @ List.map sidebar_skill cv.skills)
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

let software cv =
  let breadcrumbs = breadcrumbs @@ Breadcrumbs.of_string_list [] in
  let contributions =
    [ ("https://github.com/ocaml-ppx/ocamlformat", "ocamlformat")
    ; ("https://github.com/ocaml/odoc", "odoc")
    ; ("https://github.com/art-w/sherlodoc", "sherlodoc")
    ; ("https://github.com/ocaml/dune", "dune")
    ; ("https://gallium.inria.fr/~fpottier/menhir/", "menhir") ]
  in
  page cv
    [ sidebar [navmenu "Software"; contact cv]
    ; breadcrumbs
    ; article
        ~a:[a_id "content"]
        [ section
            [ p [txt "I am responsible for the following project :"]
            ; ul
                [ li
                    [ a
                        ~a:
                          [ a_href
                              "https://github.com/EmileTrotignon/embedded_ocaml_templates"
                          ]
                        [txt "ocaml_embedded_templates"] ] ]
            ; p [txt "I have also contributed to the following projects :"]
            ; ul
                (List.map
                   (fun (url, name) -> li [a ~a:[a_href url] [txt name]])
                   contributions ) ] ] ]

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
