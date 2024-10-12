open Cmarkit

let map_link link_f md =
  let inline _m = function
    | Inline.Link (link, meta) -> (
      match Inline.Link.reference link with
      | `Ref _ ->
          `Default
      | `Inline (link_def, meta') -> (
          let link_uri = Link_definition.dest link_def in
          match link_uri with
          | None ->
              `Default
          | Some (link_uri, meta_uri) ->
              let link_uri = link_f link_uri in
              let link_uri = Some (link_uri, meta_uri) in
              let link_def =
                Link_definition.(
                  make ~layout:(layout link_def)
                    ~defined_label:(defined_label link_def)
                    ?label:(label link_def) ?dest:link_uri
                    ?title:(title link_def) () )
              in
              let ref = `Inline (link_def, meta') in
              let link = Inline.Link.(make (text link) ref) in
              Mapper.ret (Inline.Link (link, meta)) ) )
    | _ ->
        `Default
  in
  let mapper = Mapper.make ~inline () in
  Mapper.map_doc mapper md

let html str = Inline.Raw_html (Block_line.tight_list_of_string str, Meta.none)

let image_legend md =
  let inline _m = function
    | Inline.Image (link, _meta) as image ->
        let text = Inline.Link.text link in
        let add_link =
          match Inline.Link.reference link with
          | `Ref _ ->
              Fun.id
          | `Inline (link_def, _meta') -> (
            match Link_definition.dest link_def with
            | None ->
                Fun.id
            | Some (link_uri, _meta_uri) ->
                fun (text : Inline.t) ->
                  Inline.Inlines
                    ( [ html (Printf.sprintf {|<a class='img' href='%s'>|} link_uri)
                      ; text
                      ; html "</a>" ]
                    , Meta.none ) )
        in
        let caption =
          [html {|<span class='caption'>|}; text; html {|</span>|}]
        in
        Mapper.ret (Inline.Inlines (add_link image :: caption, Meta.none))
    | _ ->
        `Default
  in
  let mapper = Mapper.make ~inline () in
  Mapper.map_doc mapper md
