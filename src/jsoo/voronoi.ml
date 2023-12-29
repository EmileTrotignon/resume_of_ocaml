[@@@warnings "-32"]

open Printf
open Graph
open Gg

module Float = struct
  include Float

  let ( * ) = ( *. )

  let ( - ) = ( -. )

  let ( + ) = ( +. )

  let ( / ) = ( /. )

  let square x = x * x
end

module P2_ = struct
  include P2

  type point = t

  let compare p p' =
    match Float.compare (x p) (x p') with
    | 0 ->
        Float.compare (y p) (y p')
    | c ->
        c

  let ( = ) t t' = compare t t' = 0

  let ccw p1 p2 p3 =
    let p1 = (x p1, y p1) in
    let p2 = (x p2, y p2) in
    let p3 = (x p3, y p3) in
    Delaunay.FloatPoints.ccw p1 p2 p3

  let in_circle p1 p2 p3 p4 =
    let p1 = (x p1, y p1) in
    let p2 = (x p2, y p2) in
    let p3 = (x p3, y p3) in
    let p4 = (x p4, y p4) in
    Delaunay.FloatPoints.in_circle p1 p2 p3 p4

  let random' () = v (Random.float 1.) (Random.float 1.)

  let random_b box =
    v
      (Random.float (Box2.w box) +. Box2.minx box)
      (Random.float (Box2.h box) +. Box2.miny box)
end

module P2 = struct
  include P2_
  module Map = Map.Make (P2_)
end

module Delaunay_p2 = struct
  include Delaunay.Make (P2)

  let fold_triangles f triangulation init =
    let acc = ref init in
    iter_triangles (fun a b c -> acc := f a b c !acc) triangulation ;
    !acc
end

module Edge = struct
  type t = P2.t * P2.t

  let compare (s, e) (s', e') =
    let s, e = if P2.compare s e < 0 then (s, e) else (e, s)
    and s', e' = if P2.compare s' e' < 0 then (s', e') else (e', s') in
    match P2.compare s s' with 0 -> P2.compare e e' | c -> c
end

module Circle = struct
  type t = P2.t * float

  let compare (c, r) (c', r') =
    match P2.compare c c' with 0 -> Float.compare r r' | c -> c
end

module Triangle = struct
  type t = P2.t * P2.t * P2.t

  let normalize (a, b, c) =
    match List.sort P2.compare [a; b; c] with
    | [a; b; c] ->
        (a, b, c)
    | _ ->
        assert false

  let compare (a, b, c) (a', b', c') =
    let a, b, c = normalize (a, b, c) in
    let a', b', c' = normalize (a', b', c') in
    match P2.compare a a' with
    | 0 -> (
      match P2.compare b b' with 0 -> P2.compare c c' | c -> c )
    | c ->
        c

  let circumcenter (a, b, c) =
    let open P2 in
    let ax = x a
    and ay = y a
    and bx = x b
    and by = y b
    and cx = x c
    and cy = y c in
    let d =
      Float.(2. * ((ax * (by - cy)) + (bx * (cy - ay)) + (cx * (ay - by))))
    in
    let x =
      (* (A2x+A2y)(By−Cy)+(B2x+B2y)(Cy−Ay)+(C2x+C2y)(Ay−By)
         \ 2(Ax(By−Cy)+Bx(Cy−Ay)+Cx(Ay−By))*)
      Float.(
        ( ((square ax + square ay) * (by - cy))
        + ((square bx + square by) * (cy - ay))
        + ((square cx + square cy) * (ay - by)) )
        / d )
    in
    let y =
      Float.(
        (* (A2x+A2y)(Cx−Bx)+(B2x+B2y)(Ax−Cx)+(C2x+C2y)(Bx−Ax)
           / 2(Ax(By−Cy)+Bx(Cy−Ay)+Cx(Ay−By)) *)
        ( ((square ax + square ay) * (cx - bx))
        + ((square bx + square by) * (ax - cx))
        + ((square cx + square cy) * (bx - ax)) )
        / d )
    in
    P2.v x y

  let circumcircle (a, b, c) =
    let center = circumcenter (a, b, c) in
    (center, V2.(norm (a - center)))

  let neighbours t t' : bool =
    let a, b, c = t in
    let a', b', c' = t' in
    P2.(
      (if a = a' || a = b' || a = c' then 1 else 0)
      + (if b = a' || b = b' || b = c' then 1 else 0)
      + if c = a' || c = b' || c = c' then 1 else 0 )
    = 2
end

module Edge_set = Set.Make (Edge)
module Triangle_set = Set.Make (Triangle)
module Triangle_map = Map.Make (Triangle)
module Circle_set = Set.Make (Circle)

type particule = {pos: P2.t; speed: V2.t}

type particules = particule array

let delaunay triangulation =
  Delaunay_p2.fold
    (fun s e set -> Edge_set.add (s, e) set)
    triangulation Edge_set.empty

let circles triangulation =
  Delaunay_p2.fold_triangles
    (fun a b c set -> Circle_set.add (Triangle.circumcircle (a, b, c)) set)
    triangulation Circle_set.empty

let voronoi triangulation =
  let add_triangle triangle vertex map =
    P2.Map.add vertex
      ( match P2.Map.find_opt vertex map with
      | None ->
          Triangle_set.singleton triangle
      | Some triangles ->
          Triangle_set.add triangle triangles )
      map
  in
  let triangle_map =
    Delaunay_p2.fold_triangles
      (fun a b c map ->
        let triangle = (a, b, c) in
        map |> add_triangle triangle a |> add_triangle triangle b
        |> add_triangle triangle c )
      triangulation P2.Map.empty
  in
  P2.Map.fold
    (fun _vertex triangles edges ->
      edges
      |> Triangle_set.fold
           (fun triangle edges ->
             let circumcenter = Triangle.circumcenter triangle in
             edges
             |> Triangle_set.fold
                  (fun triangle' edges ->
                    let circumcenter' = Triangle.circumcenter triangle' in
                    if Triangle.neighbours triangle triangle' then
                      Edge_set.add (circumcenter, circumcenter') edges
                    else edges )
                  triangles )
           triangles )
    triangle_map Edge_set.empty

let _ = delaunay

open Brr
open Brr_canvas

let ( .%{} ) obj prop = Jv.get obj prop

let ( @% ) f arg = Jv.apply f [|arg|]

let ( !% ) = Jstr.of_string

let path_of_circle (center, r) =
  let open C2d.Path in
  let path = create () in
  arc path ~cx:P2.(x center) ~cy:P2.(y center) ~r ~start:0. ~stop:Float.(2. * pi) ;
  path

let path_of_edges edges =
  let path = C2d.Path.create () in
  Edge_set.iter
    (fun (s, e) ->
      let open P2 in
      let open C2d.Path in
      move_to path ~x:(x s) ~y:(y s) ;
      line_to path ~x:(x e) ~y:(y e) )
    edges ;
  path

let canvas_color canvas =
  (Jv.global.%{"getComputedStyle"} @% Canvas.to_jv canvas).%{"getPropertyValue"}
  @% Jv.of_string "color"
  |> Jv.to_string

let clear_canvas canvas =
  let context = C2d.get_context canvas in
  let h = canvas |> Canvas.h |> float_of_int in
  let w = canvas |> Canvas.w |> float_of_int in
  C2d.clear_rect context ~x:0. ~y:0. ~w ~h

let transparentize ~alpha color =
  let r, g, b =
    Scanf.sscanf_opt color "rgb(%i, %i, %i)" (fun r b g -> (r, g, b))
    |> Option.value ~default:(0xfb, 0x49, 0x34)
  in
  sprintf "rgba(%i,%i,%i,%f)" r g b alpha

let colors_of_time ~time canvas =
  (* three periods of 30 seconds, interlaced with 5 seconds transitions
     30 + 5 + 30 + 5 + 30 + 5 = 105 *)
  let time = int_of_float time in
  let time = time mod 105_000 in
  let alpha_voronoi, alpha_delaunay, alpha_circles =
    if time < 30_000 then (1., 0., 0.)
    else if time < 35_000 then
      let progress = float_of_int (time - 30_000) /. 5_000. in
      (1. -. progress, progress, 0.)
    else if time < 65_000 then (0., 1., 0.)
    else if time < 70_000 then
      let progress = float_of_int (time - 65_000) /. 5_000. in
      (0., 1. -. progress, progress)
    else if time < 100_000 then (0., 0., 1.)
    else
      (* if time < 105_000 is always true*)
      let progress = float_of_int (time - 100_000) /. 5_000. in
      (progress, 0., 1. -. progress)
  in
  let color = canvas_color canvas in
  let voronoi_color =
    color |> transparentize ~alpha:alpha_voronoi |> Jstr.of_string |> C2d.color
  in
  let delaunay_color =
    color |> transparentize ~alpha:alpha_delaunay |> Jstr.of_string |> C2d.color
  in
  let circles_color =
    color |> transparentize ~alpha:alpha_circles |> Jstr.of_string |> C2d.color
  in
  (voronoi_color, delaunay_color, circles_color)

let display_image canvas ~time ~voronoi ~circles ~delaunay =
  Canvas.set_size_to_layout_size canvas ;
  let voronoi_color, delaunay_color, circles_color =
    colors_of_time ~time canvas
  in
  clear_canvas canvas ;
  let context = C2d.get_context canvas in
  C2d.set_stroke_style context voronoi_color ;
  List.iter (C2d.stroke context) voronoi ;
  C2d.set_stroke_style context delaunay_color ;
  List.iter (C2d.stroke context) delaunay ;
  C2d.set_stroke_style context circles_color ;
  List.iter (C2d.stroke context) circles

let display_particules canvas ~time particules =
  let triangulation =
    particules
    |> Array.map (fun particule -> particule.pos)
    |> Delaunay_p2.triangulate
  in
  let delaunay = [triangulation |> delaunay |> path_of_edges] in
  let voronoi = [triangulation |> voronoi |> path_of_edges] in
  let max_radius =
    let canvas_h = canvas |> Canvas.h |> float_of_int in
    let canvas_w = canvas |> Canvas.w |> float_of_int in
    min canvas_h canvas_w
  in
  let circles =
    triangulation |> circles
    |> Circle_set.filter (fun (_, r) -> r < max_radius)
    |> Circle_set.elements |> List.map path_of_circle
  in
  display_image canvas ~time ~voronoi ~circles ~delaunay

let bounds canvas =
  let canvas_h = canvas |> Canvas.h |> float_of_int in
  let canvas_w = canvas |> Canvas.w |> float_of_int in
  (* Box2.v (P2.v 0. 0.) (V2.v canvas_w canvas_h) *)
  Box2.v (P2.v (-50.) (-50.)) (V2.v (canvas_w +. 100.) (canvas_h +. 100.))

type state =
  { mutable mouse_pos: P2.t
  ; mutable particules: particules
  ; mutable previous_time: float }

let rec step ({particules; mouse_pos; previous_time} as state) canvas time =
  let bounds = bounds canvas in
  let delta_t = Float.(max 0. (time - previous_time)) in
  state.previous_time <- time ;
  Array.mapi_inplace
    (fun i {pos; speed} ->
      if i = 0 then
        (* particule 0 is the one that follows the mouse *)
        let pos = mouse_pos in
        {pos; speed}
      else
        let delta_pos = V2.(Float.(delta_t / 1000.) * speed) in
        let pos = V2.(pos + delta_pos) in
        let {pos; speed} =
          if Box2.mem pos bounds then {pos; speed}
          else
            let speed = V2.(-1. * speed) in
            let delta_pos = V2.(-2. * delta_pos) in
            let pos = V2.(pos + delta_pos) in
            {pos; speed}
        in
        {pos; speed} )
    particules ;
  display_particules canvas ~time particules ;
  ignore (G.request_animation_frame (step state canvas))

let random_speed () =
  V2.(5. * P2.random_b (Box2.v (V2.v (-1.) (-1.)) (V2.v 2. 2.)))

let follow_mouse state ev =
  let mouse = Ev.as_type ev in
  let x = Ev.Mouse.offset_x mouse in
  let y = Ev.Mouse.offset_y mouse in
  state.mouse_pos <- P2.v x y

let new_particules canvas =
  Canvas.set_size_to_layout_size canvas ;
  let canvas_h = canvas |> Canvas.h |> float_of_int in
  let canvas_w = canvas |> Canvas.w |> float_of_int in
  let n_points = Box2.area (bounds canvas) /. 5000. |> int_of_float in
  printf "Canvas dims = w%f h%f n_points =%i" canvas_w canvas_h n_points ;
  Array.init n_points (fun _i ->
      let pos = P2.random_b (bounds canvas) in
      let speed = random_speed () in
      {pos; speed} )

let canvas_resize state canvas _ev = state.particules <- new_particules canvas

let on_click state _ev =
  let {particules; _} = state in
  let particules =
    Array.init
      (1 + Array.length particules)
      (fun i ->
        if i = 0 then {(particules.(0)) with speed= random_speed ()}
        else particules.(i - 1) )
  in
  state.particules <- particules

let () =
  Random.self_init () ;
  let canvas =
    Document.find_el_by_id G.document !%"voronoi" |> Option.get |> Canvas.of_el
  in
  let particules = new_particules canvas in
  let state =
    {particules; mouse_pos= P2.v 0. 0.; previous_time= Float.infinity}
  in
  let canvas_target = canvas |> Canvas.to_jv |> Ev.target_of_jv in
  let _ = Ev.(listen mousemove (follow_mouse state) canvas_target) in
  let _ = Ev.(listen resize (canvas_resize state canvas)) canvas_target in
  let _ = Ev.(listen mouseup (on_click state)) canvas_target in
  ignore (G.request_animation_frame (step state canvas))
