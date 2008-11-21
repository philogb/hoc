open Str
open String
open Color
open Pix_type

let data =
	object (self)
		val path_to_file = "/home/nicolas/hoc/HoC1/"
		val path_to_image_file = "/home/nicolas/hoc/HoC1/images/"
		val total_frames = 2101
		val mutable current_frame = ref 0
		val time_interval = 33
		
		method get_time_interval =
			time_interval
		
		method load_file filename =
			let channel = open_in (path_to_file ^ filename) in
			let ans = ref [] in
				try 
					while true do
						let line = input_line channel in
						let sp = split (regexp ",") (sub line 0 (pred (length line))) in
						let [ x; y; z; d ] = List.map float_of_string sp in
						ans := Depth_vertex (x, y, z, d) :: !ans;
					done;
					!ans
				with End_of_file -> close_in_noerr channel; !ans
		
		method save_image =
				let img_rgb = new OImages.rgb24 600 400 in
				let pixels = GlPix.read 
					~x:0 ~y:0 
					~width:600 ~height:400 
					~format:`rgb ~kind:`ubyte
				in
				let praw = GlPix.to_raw pixels in
				let raw = Raw.gets ~pos:0 ~len:(Raw.byte_size praw) praw in
				let w = GlPix.width pixels in
				let h = GlPix.height pixels in
				for i = 0 to pred (w * h) do
					let color_rgb = { r = raw.(i * 3 + 2); 
																	g = raw.(i * 3 + 1); 
																	b = raw.(i * 3 + 0) } 
					in
						img_rgb#set (i mod w) (i / w) color_rgb;
				done;
				img_rgb#save (path_to_image_file ^ "img" ^ (string_of_int !current_frame) ^ ".bmp")
															None [];
		
		method next_frame =
			current_frame := (!current_frame + 1) mod total_frames;
			if !current_frame = 0 then
				current_frame := total_frames;
			self#load_file ((string_of_int !current_frame) ^ ".csv");
		end;; 

let init_gl width height =
		GlDraw.point_size 0.5;
    GlDraw.shade_model `smooth;
    GlClear.color (0.0, 0.0, 0.0);
    GlClear.depth 1.0;
    GlClear.clear [`color; `depth];
    Gl.enable `depth_test;
    GlFunc.depth_func `lequal;
    GlMisc.hint `perspective_correction `nicest

let draw_gl_scene () =
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();
	GlMat.translate3 (-150.0, -150.0, -400.0);
	GlDraw.begins `points;
	List.iter (fun (Depth_vertex (x, y, z, d)) ->
		let color = d /. 255.0 in
			GlDraw.color (color /. 1.1, color /. 1.5, color);
			GlDraw.vertex ~x:x ~y:y ~z:z ()) (data#next_frame);
	GlDraw.ends ();
(*	List.iter (fun x ->                        *)
(*		match x with                             *)
(*			| Depth_vertex (_, _, _, d) ->         *)
(*				let color = d /. 255.0 in            *)
(*					GlDraw.color (color, color, color);*)
(*					Render.cube x) data#next_frame;    *)

  Glut.swapBuffers ();
	data#save_image;;

(* Handle window reshape events *)
let reshape_cb ~w ~h =
  let 
    ratio = (float_of_int w) /. (float_of_int h) 
  in
    GlDraw.viewport 0 0 w h;
    GlMat.mode `projection;
    GlMat.load_identity ();
    GluMat.perspective 45.0 ratio (0.1, 1300.0);
    GlMat.mode `modelview;
    GlMat.load_identity ()

(* Handle keyboard events *)
let keyboard_cb ~key ~x ~y =
  match key with
    | 27 (* ESC *) -> exit 0
    | _ -> ()

let rec timer value =
	if value = 1 then
		Glut.postRedisplay ();
	Glut.timerFunc ~ms:data#get_time_interval ~cb:(fun ~value:x -> (timer x)) ~value:value;;

let visibility (state:Glut.visibility_state_t) =
	match state with
		| Glut.VISIBLE -> timer 1
		| _ -> timer 0;;

let enable () =
	Gl.enable `lighting;
	Gl.enable `depth_test;
	Gl.enable `light0;
	Gl.enable `polygon_smooth;
	Gl.enable `color_material


let main () =
  let 
    width = 640 and
    height = 480
  in
		ignore (Glut.init Sys.argv);
    Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
    Glut.initWindowSize width height;
    ignore (Glut.createWindow "Ocaml + OpenGL + radiohead = Fun");
    Glut.displayFunc draw_gl_scene;
    Glut.keyboardFunc keyboard_cb;
    Glut.reshapeFunc reshape_cb;
		Glut.timerFunc ~ms:data#get_time_interval 
												 ~cb:(fun ~value:x -> (timer x)) 
												 ~value:1;
		Glut.visibilityFunc ~cb:(fun ~state -> (visibility state));
		enable ();
    init_gl width height;
		Glut.mainLoop ()

let _ = main ()