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
            | Some (link_uri, _meta_uri)
              when String.ends_with ~suffix:".mp4" link_uri
                   || String.ends_with ~suffix:".webm" link_uri ->
                fun _text ->
                  let video_type =
                    link_uri |> String.split_on_char '.' |> List.rev |> List.hd
                  in
                  html
                    (Printf.sprintf
                       {|<video controls class="img"><source src="%s" type="video/%s" /></video>|}
                       link_uri video_type )
            | Some (link_uri, _meta_uri) ->
                fun (text : Inline.t) ->
                  Inline.Inlines
                    ( [ html
                          (Printf.sprintf {|<a class='img' href='%s'>|} link_uri)
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

let alt_flat tyre1 tyre2 =
  Tyre.(
    conv
      (function `Left a -> a | `Right a -> a)
      (fun a -> `Left a)
      (alt tyre1 tyre2) )

let ( <||> ) = alt_flat

let str_nbsp txt = Tyre.(attach ("&nbsp;" ^ txt) (str " " *> str txt))

let insert_nbsp_in_string txt =
  Result.get_ok
    Tyre.(
      replace (compile (str_nbsp ":" <||> str_nbsp ";" <||> str_nbsp "!")) txt )

let suffix_md_to_html link =
  if String.ends_with ~suffix:".md" link then
    String.sub link 0 (String.length link - 3) ^ ".html"
  else link

let tranform md = md |> image_legend |> map_link suffix_md_to_html
