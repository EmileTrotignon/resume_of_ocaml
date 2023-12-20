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
