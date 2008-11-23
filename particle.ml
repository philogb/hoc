open Pix_type
open Str
open String
open ParticleTrans
open Transition

type animation_op = transformation * float * (Transition.trans * Transition.ease)

class particle_model =
object (self)
	val mutable loaded_frame = ref ([] : depth_vertex list)
	val mutable start_frame = ref ([] : depth_vertex list)
	val mutable last_frame = ref ([] : depth_vertex list)
	val mutable transition = ref  (Linear, None)
	val mutable time = ref 0.
	val mutable total_frames = ref 0.
	
	method get_time = !time
	
	method set_animation ~invert (t: animation_op) =
		let (trans, tf, trans_type) = t in
		total_frames := tf;
		let anim = ParticleTrans.get_trans trans in
		if not invert then
			begin
				start_frame := !last_frame;
				last_frame := anim !last_frame
			end
		else
			begin
				start_frame := anim !last_frame;
				last_frame := !last_frame
			end;
		time := 0.;
		total_frames := tf;
		transition := trans_type
	
	method step =
		if !time < !total_frames then
				time := !time +. 1.
	
	method draw =
		let delta = !time /. !total_frames in
		let (trans, ease) = !transition in
		let delta_val = Transition.get_animation trans ease delta in 
			GlDraw.begins `points;
			List.iter2 (fun x y ->
							let Depth_vertex(x, y, z, d) = Interpolate.cartesian x y delta_val in
							let color = d /. 255.0 in
							GlDraw.color (color, color, color);
							GlDraw.vertex ~x: x ~y: y ~z: z ()
				) !start_frame !last_frame;
			GlDraw.ends ()
	
	method load_frame =
		loaded_frame := [];
		let channel = open_in "/home/nicolas/hoc/HoC1/1.csv" in
		try
			while true do
				let line = input_line channel in
				let sp = split (regexp ",") (sub line 0 (pred (length line))) in
				let [ x; y; z; d ] = List.map float_of_string sp in
				loaded_frame := Depth_vertex (x, y, z, d) :: !loaded_frame;
			done;
		with End_of_file -> 
			close_in_noerr channel;
			if List.length !last_frame = 0 then
				last_frame := !loaded_frame
end
