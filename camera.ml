(** The camera module handles advanced camera animations *)

open VertexType
open Transition

(** A camera operation is a Translation or Rotation *)
type camera_op = 
	| Translate of Gl.point3 * Gl.point3  (** Translate from to *)
	| Rotate of float * float * Gl.vect3  (** Rotate angle_from angle_to vertex *)

(** Camera transitions are a list of camera operations with their
    duration (in frames) and transition and easing options *)
type camera_op_list = (camera_op list) * float * (trans * ease)

(** The camera_model class applies advanced camera transformations
    before the data is rendered *)
class camera_model =
object (self)
	(** Duration for the camera transition (expressed
      in number of frames) *)
	val mutable total_frames = 0.

	(** Current relative frame *)
	val mutable time = 0.

	(** How time elapses -linear/quad, etc- *)
	val mutable transition = (Linear, None)

	(** List of camera operations to be performed -rotations, translations, etc- *)
	val mutable animations = []
	
	(** Returns current relative frame for the transition *)
	method get_time = time

	(** Sets the camera operations, duration for these
		  operations and special transitions to be performed *)	
	method set_animations ans =
		let (x, y, z) = ans in
			animations <- x;
			total_frames <- y;
			transition <- z;
			time <- 0.
	
	(** Animation step *)	
	method step =
		if time < total_frames then
			time <- time +. 1.

	(** Translates the image for some delta *)	
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
	
	(** Rotates the image for some delta *)
	method rotate start last vec delta =
		let (trans, ease) = transition in
		let delta_val = Transition.get_animation trans ease delta in
		let ang = Interpolate.cartesian_float start last delta_val in
		GlMat.rotate3 ang vec 
		
	(** Applies the Camera operations *)
		method draw =
			let delta = time /. total_frames in
				List.iter (fun anim ->
					match anim with
						| Translate(start, last) -> self#translate start last delta
						| Rotate(start, last, vec) -> self#rotate start last vec delta ) animations
end