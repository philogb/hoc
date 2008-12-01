open Str
open String
open Color
open VertexType

(* Loads csv frames and saves the rendered OpenGL image *)
let data =
	object (self)
		val path_to_file = "/home/nicolas/hoc/HoC1/"
		val path_to_image_file = "/home/nicolas/hoc/HoC1/images/"
		val mutable current_frame = 1
		val total_frames = 900
		val time_interval = 33
		
		method get_time_interval = 	time_interval
		
		method load_file filename =
			let channel = open_in (path_to_file ^ filename) in
			let ans = ref [] in
				try 
					while true do
						let line = input_line channel in
						let sp = split (regexp ",") (sub line 0 (pred (length line))) in
						match List.map float_of_string sp with
							| [ x; y; z; d ] -> ans := DVertex (x, y, z, d) :: !ans
							| _ -> raise (Invalid_argument "not a depth vertex")
					done;
					!ans
				with End_of_file | Invalid_argument _ -> close_in_noerr channel; !ans
		
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
				img_rgb#save (path_to_image_file ^ "img" ^ (string_of_int current_frame) ^ ".bmp")
															None []
		
		method next_frame =
			current_frame <- (current_frame + 1) mod total_frames;
			if current_frame = 0 then
				current_frame <- total_frames;
			self#load_file ((string_of_int current_frame) ^ ".csv")
end

(* Initializes openGL scene components*)
let init width height =
		GlDraw.point_size 0.5;
    GlDraw.shade_model `smooth;
    GlClear.color (0.0, 0.0, 0.0);
    GlClear.depth 1.0;
    GlClear.clear [`color; `depth];
    Gl.enable `depth_test;
    GlFunc.depth_func `lequal;
    GlMisc.hint `perspective_correction `nicest

(*	Draws the image*)
let draw () =
  GlClear.clear [`color; `depth];
  GlMat.load_identity ();
	GlMat.translate3 (-150.0, -150.0, -400.0);
	GlDraw.begins `points;
	List.iter (fun (DVertex (x, y, z, d)) ->
		let color = d /. 90. in
			GlDraw.color (color, color, color);
			GlDraw.vertex ~x:x ~y:y ~z:z ()) data#next_frame;
	GlDraw.ends ();
  Glut.swapBuffers ();
	data#save_image

(* Handle window resize *)
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

(* A timer function setted to draw a new frame each time_interval ms *)
let rec timer value =
	Glut.postRedisplay ();
	Glut.timerFunc ~ms:data#get_time_interval 
											  ~cb:(fun ~value:x -> (timer x)) ~value:value

(*	Main program function*)
let main () =
  let 
    width = 640 and
    height = 480
  in
		ignore (Glut.init Sys.argv);
    Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
    Glut.initWindowSize width height;
    ignore (Glut.createWindow "Ocaml + OpenGL + radiohead = Fun");
    Glut.displayFunc draw;
    Glut.keyboardFunc keyboard_cb;
    Glut.reshapeFunc reshape_cb;
		Glut.timerFunc ~ms:data#get_time_interval 
												 ~cb:(fun ~value:x -> (timer x)) 
												 ~value:1;
    init width height;
		Glut.mainLoop ()

let _ = main ()