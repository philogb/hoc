open Pix_type

type coordinates = Cartesian | Spherical | Cylindrical

let squared_norm (Depth_vertex(x, y, z, d)) =
	x *. x +. y *. y +. z *. z
	
let normalize v =
	let n = sqrt (squared_norm v) in
		match v with
			| Depth_vertex(x, y, z, d) -> Depth_vertex(x /. n, y /. n, z /. n, d)

let cartesian_float x x' r = 
	x +. (x' -. x) *. r

let cartesian (Depth_vertex(x, y, z, d)) (Depth_vertex(x', y', z', d')) r =
	let l x x' = x +. (x' -. x) *. r in
		let x'' = l x x' and
		y'' = l y y' and
		z'' = l z z' in
			Depth_vertex(x'', y'', z'', d)

let spherical (Depth_vertex(x, y, z, d)) (Depth_vertex(x', y', z', d')) r =
	let prod = x *. x' +. y *. y' +. z *. z' in
	let omega = sin prod in
	let c = (sin ((1. -. r) *. prod)) /. omega in
	let d = (sin (r *. omega)) /. omega in
	let [| xt; yt; zt |] = Array.map (fun x -> x *. c) [| x; y; z |] in
	let [| xt'; yt'; zt' |] = Array.map (fun x -> x *. d) [| x'; y'; z' |] in
	Depth_vertex(xt +. xt', yt +. yt', zt +. zt', d)
			
		