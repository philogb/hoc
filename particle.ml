open Pix_type
open Str
open String
open Color

type animation = Idle | Project;;
type animation_function = animation * (depth_vertex list -> depth_vertex list);;

class model =
object (self)
	val mutable animation_types = ref ([] : animation_function list)
	val mutable loaded_frame = ref ([] : depth_vertex list)
	val mutable start_frame = ref ([] : depth_vertex list)
	val mutable last_frame = ref ([] : depth_vertex list)
	val mutable time = ref 0.
	
	method set_animation ?(inv = false) (t: animation) =
		let rec search_animation = function
			| (tp, f1) :: tl when tp = t ->
					if not inv then
						begin
							start_frame := !last_frame;
							last_frame := f1 !last_frame
						end
					else
						begin
							start_frame := f1 !last_frame;
							last_frame := !last_frame
						end
			
			| hd :: tl -> search_animation tl
			| [] -> ()
		in
		search_animation !animation_types;
		time := 0.
	
	method step dt =
		if dt > 0. then
			begin
				time := !time +. dt;
				if !time > 1.0 then
					time := 1.
			end
	
	method draw =
		GlDraw.begins `points;
		List.iter2 (fun x y ->
						let Depth_vertex(x, y, z, d) = Interpolate.linear x y !time in
						let color = d /. 255.0 in
						GlDraw.color (color /. 1.1, color /. 1.5, color);
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

	
	method load_animations =
		(* idle is identity *)
		let anims = [(Idle, (fun x -> x));
											 (Project, (fun x -> List.map (fun (Depth_vertex(x, y, z, d)) -> 
																			Depth_vertex(x, y, 0., d)) x))]
		in
			List.iter (fun x -> animation_types := x :: !animation_types) anims;
end;;
