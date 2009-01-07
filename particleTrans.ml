(** This module provides multiple particle transformations.
    A particle transformation takes a frame as formal parameter and
        returns a frame.
        Custom frame transformations should be appended here *)

open VertexType

(** Frame/Particle transformations should be defined as type constructors *)
type transformation = Idle | Project of float * float * float | Random;;

(** Idle transformation does nothing *)
let idle x = x

(** Project transformation projects all particles to a surface *)
let project trans frame =
    match trans with
        | Project(x, y, z) -> List.map (fun (DVertex(a, b, c, d)) ->
                                       DVertex(a *. x, b *. y, c *. z, d)) frame
        | _ -> []

(** Random transformation assigns a random position to each particle *)
let random frame =
    let rand (x, y) = (Random.float (y -. x)) +. x in
    let x = (-105., 400.) and 
        y = (-890., 353.) and    
        z = (-6000., 390.) 
    in
    List.map (fun (DVertex(a, b, c, d)) ->
        let a' = rand x and 
            b' = rand y and 
            c' = rand z 
        in
            DVertex(a', b', c', d)) frame

(** Transformation Dispatcher 
      @param t Transformation Type Constructor 
      @return Transformation function *)
let get_trans t =
    match t with
        | Idle -> idle
        | Project (_, _, _) -> project t
        | Random -> random

let _ = Random.self_init ()