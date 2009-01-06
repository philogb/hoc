open Str
open String
open Particle
open ParticleTrans
open Camera
open Transition

let part = new particle_model
let cam =  new camera_model

let timeline = 
	object (self)
		val mutable frame = 0.
		val camera_timeline = [
			(1., ([ Translate((-100., -150., 0.), (0., -150., -350.)); 
							Rotate(0., 40., (0., 1., 0.)) 
						], 300., (Quad, EaseInOut)));

			(310., ([ Translate((0., -150., -350.), (-100., -150., -300.)); 
								Rotate(40., -40., (0., 1., 0.)) 
							], 300., (Quad, EaseInOut)))
			]
		
		val particle_timeline = [
			(1., (true, true, (Random, 120., (Elastic, EaseOut))));
			(420., (false, false, (Random, 50., (Quad, EaseOut))));
			(471., (false, true, (Idle, 80., (Quad, EaseIn))))
			]
			
		method get_frame = frame
		
		method tick =
			frame <- frame +. 1.;
			self#update_camera;
			self#update_animation
		
		method update_camera =
			try
				let camera_anim = List.assoc frame camera_timeline in
					cam#set_animations camera_anim;
				with
					| Not_found -> ()
		
		method update_animation =
			try
				let anim = List.assoc frame particle_timeline in
					part#set_animation frame anim;
			with
					| Not_found -> ()
end

let init width height =
	GlDraw.point_size 4.;
	GlClear.color (0.0, 0.0, 0.0);
	GlClear.depth 1.0;
	GlClear.clear [`color; `depth];
	Gl.enable `depth_test;
	GlFunc.depth_func `lequal;
	GlMisc.hint `perspective_correction `nicest

let draw () =
  GlClear.clear [`color; `depth];
	GlMat.mode `modelview;
  GlMat.load_identity ();
	GlMat.push ();
	cam#draw;
	part#draw timeline#get_frame;
	GlMat.pop ();
	Glut.swapBuffers ();
	Loader.save_frame (int_of_float timeline#get_frame)
	
(* Handle window reshape events *)
let reshape_cb ~w ~h =
  let 
    ratio = (float_of_int w) /. (float_of_int h) 
  in
    GlDraw.viewport 0 0 w h;
    GlMat.mode `projection;
    GlMat.load_identity ();
    GluMat.perspective 45.0 ratio (0.1, 800.0);
    GlMat.mode `modelview
		
(* Handle keyboard events *)
let keyboard_cb ~key ~x ~y =
  match key with
    | 27 (* ESC *) -> exit 0
    | _ -> ()

let rec update value =
	timeline#tick;
	part#step;
	cam#step;
	Glut.postRedisplay ();
	Glut.timerFunc ~ms:10 
								 ~cb:(fun ~value:x -> (update x)) 
								 ~value:1

let main () =
  let 
    width = 1000 and
    height = 600
  in
		ignore (Glut.init Sys.argv);
    Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
    Glut.initWindowSize width height;
    ignore (Glut.createWindow "Particle Visualizer");
    init width height;
		timeline#tick;
    Glut.displayFunc draw;
    Glut.keyboardFunc keyboard_cb;
    Glut.reshapeFunc reshape_cb;
		Glut.timerFunc ~ms:10 
									 ~cb:(fun ~value:x -> (update x)) 
									 ~value:1;
		Glut.mainLoop ()

let _ = main ()