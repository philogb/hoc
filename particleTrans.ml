open VertexType

type transformation = Idle | Project of float * float * float | Random;;

Random.self_init ();;

let idle x = x

let project trans frame =
	match trans with
		| Project(x, y, z) ->	List.map (fun (DVertex(a, b, c, d)) ->
															DVertex(a *. x, b *. y, c *. z, d)) frame
		| _ -> []

let random frame =
	let x = (-105., 400.) and y = (-890., 353.) and	z = (-6000., 390.) in
	let rand (x, y) = (Random.float (y -. x)) +. x in
	 List.map (fun (DVertex(a, b, c, d)) ->
		let a' = rand x and b' = rand y and c' = rand z in
		DVertex(a', b', c', d)) frame
	
let get_trans t =
	match t with
		| Idle -> idle
		| Project (_, _, _) -> project t
		| Random -> random