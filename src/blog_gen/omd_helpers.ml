open Omd

module Map_link = struct
  let rec inline f (md : 'a Omd.inline) =
    match md with
    | Concat (attr, list) ->
        let list = List.map (inline f) list in
        Concat (attr, list)
    | Text (attr, str) ->
        Text (attr, str)
    | Emph (attr, i) ->
        let i = inline f i in
        Emph (attr, i)
    | Strong (attr, i) ->
        let i = inline f i in
        Strong (attr, i)
    | Code (attr, str) ->
        Code (attr, str)
    | Hard_break attr ->
        Hard_break attr
    | Soft_break attr ->
        Soft_break attr
    | Link (attr, l) ->
        let l = link f l in
        Link (attr, l)
    | Image (attr, image) ->
        let image = link f image in
        Image (attr, image)
    | Html (attr, html) ->
        Html (attr, html)

  and link f ({label; destination; title} : 'a link) =
    let label = inline f label and destination = f destination in
    {label; destination; title}

  and def_elt f ({term; defs} : 'a Omd.def_elt) =
    let term = inline f term in
    let defs = List.map (inline f) defs in
    {term; defs}

  and block f (b : 'a Omd.block) =
    match b with
    | Paragraph (attr, i) ->
        let i = inline f i in
        Paragraph (attr, i)
    | List (attr, ty, spacing, bl) ->
        let bl = List.map (List.map (block f)) bl in
        List (attr, ty, spacing, bl)
    | Blockquote (attr, bl) ->
        let bl = List.map (block f) bl in
        Blockquote (attr, bl)
    | Thematic_break attr ->
        Thematic_break attr
    | Heading (attr, n, i) ->
        let i = inline f i in
        Heading (attr, n, i)
    | Code_block (attr, str, str') ->
        Code_block (attr, str, str')
    | Html_block (attr, str) ->
        Html_block (attr, str)
    | Definition_list (attr, defs) ->
        let defs = List.map (def_elt f) defs in
        Definition_list (attr, defs)
    | Table (attr, top, cells) ->
        let top = List.map (fun (i, a) -> (inline f i, a)) top in
        let cells = List.map (List.map (inline f)) cells in
        Table (attr, top, cells)

  and doc f (d : doc) : doc = List.map (block f) d
end
