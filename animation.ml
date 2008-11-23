open Str
open String
open Pix_type
open Particle
open ParticleTrans
open Camera
open Transition

let part = new particle_model;;
let cam = new camera_model;;

let init width height =
		GlDraw.point_size 0.5;
    GlDraw.shade_model `smooth;
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
(*	GlMat.translate3 (-100.0, -150.0, -300.0);*)
	GlMat.push ();
	cam#draw;
	part#draw;
	GlMat.pop ();
	Glut.swapBuffers ()

(* Handle window reshape events *)
let reshape_cb ~w ~h =
  let 
    ratio = (float_of_int w) /. (float_of_int h) 
  in
    GlDraw.viewport 0 0 w h;
    GlMat.mode `projection;
    GlMat.load_identity ();
    GluMat.perspective 45.0 ratio (0.1, 800.0);
    GlMat.mode `modelview;
    GlMat.load_identity ()

(* Handle keyboard events *)
let keyboard_cb ~key ~x ~y =
  match key with
    | 27 (* ESC *) -> exit 0
    | _ -> ()

let rec update value =
	part#step;
	cam#step;
	Glut.postRedisplay ();
	Glut.timerFunc ~ms:40 
											 ~cb:(fun ~value:x -> (update x)) 
											 ~value:1

let enable () =
	Gl.enable `depth_test

let main () =
  let 
    width = 640 and
    height = 480
  in
		ignore (Glut.init Sys.argv);
    Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
    Glut.initWindowSize width height;
    ignore (Glut.createWindow "Ocaml + OpenGL + radiohead = Fun");

		enable ();
    init width height;
		part#load_frame;
		part#set_animation ~invert:true (Random, 250., (Quart, EaseOut));
		cam#set_animations ([ Translate((-100., -150., 0.), (0., -150., -350.)); Rotate(0., 40., (0., 1., 0.)) ], 500., (Linear, None));
			
    Glut.displayFunc draw;
    Glut.keyboardFunc keyboard_cb;
    Glut.reshapeFunc reshape_cb;
		Glut.timerFunc ~ms:40 
												 ~cb:(fun ~value:x -> (update x)) 
												 ~value:1;
		Glut.mainLoop ()

let _ = main ()