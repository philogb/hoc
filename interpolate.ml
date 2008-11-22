open Pix_type

type interpolation = Cartesian | Spherical | Cylindrical
type effect = Linear | EaseOut | EaseIn | EaseInOut

let linear (Depth_vertex(x, y, z, d)) (Depth_vertex(x', y', z', d')) r =
	let l x x' = x +. (x' -. x) *. r in
		let x'' = l x x' and
		y'' = l y y' and
		z'' = l z z' in
			Depth_vertex(x'', y'', z'', d)