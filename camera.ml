open VertexType
open Transition

type camera_op = 
	| Translate of Gl.point3 * Gl.point3  
	| Rotate of float * float * Gl.vect3

type camera_op_list = (camera_op list) * float * (trans * ease)

class camera_model =
object (self)
	val mutable total_frames = 0.
	val mutable time = 0.
	val mutable transition = (Linear, None)
	val mutable animations = []
	
	method get_time = time
	
	method set_animations ans =
		let (x, y, z) = ans in
			animations <- x;
			total_frames <- y;
			transition <- z;
			time <- 0.
	
	method step =
		if time < total_frames then
			time <- time +. 1.

	method translate start last delta =
		let (trans, ease) = transition in
		let delta_val = Transition.get_animation trans ease delta in 
		let (x, y, z) = start in
		let (x', y', z') = last in
		let DVertex(a, b, c, d) = Interpolate.cartesian (DVertex(x, y, z, 0.)) 
																										(DVertex(x', y', z', 0.)) 
																										delta_val
		in
			GlMat.translate3 (a, b, c)
	
	method rotate start last vec delta =
		let (trans, ease) = transition in
		let delta_val = Transition.get_animation trans ease delta in
		let ang = Interpolate.cartesian_float start last delta_val in
		GlMat.rotate3 ang vec 
		

		method draw =
			let delta = time /. total_frames in
				List.iter (fun anim ->
					match anim with
						| Translate(start, last) -> self#translate start last delta
						| Rotate(start, last, vec) -> self#rotate start last vec delta ) animations
end;;