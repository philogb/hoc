(** Provides custom interpolation functions *)

open VertexType

(** Interpolation can be done in Cartesian, Spherical or Cylindrical
    coordinates. By using different coordinate systems we can define
        different types of interpolations.
        However, this isn't yet implemented -although it's easily extendable *)
type coordinates = Cartesian | Spherical | Cylindrical

let normalize v =
    let squared_norm (DVertex(x, y, z, d)) =
        x *. x +. y *. y +. z *. z
    in
    let n = sqrt (squared_norm v) in
    let DVertex(x, y, z, d) = v in
        DVertex(x /. n, y /. n, z /. n, d)

(** Cartesian interpolation for floats *)
let cartesian_float x x' r = 
    x +. (x' -. x) *. r

(** Cartesian interpolation for DVertex *)
let cartesian (DVertex(x, y, z, d)) (DVertex(x', y', z', d')) r =
    let l = (fun x x' -> cartesian_float x x' r) in
    let x'' = l x x' and
        y'' = l y y' and
        z'' = l z z' and
        d'' = l d d' 
    in
      DVertex(x'', y'', z'', d'')

(*let spherical, cylindrical*)