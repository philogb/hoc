open Pix_type


(* contains display lists for spheres, cubes, etc *)
let display_lists = ref ([]:GlList.t list);;

let make f =
	let list = GlList.create `compile in
		GlMat.push ();
		f ();
		GlList.ends ();
		GlMat.pop ();
		display_lists := list :: !display_lists;;
	
let make_cube () =
	make (fun () -> Glut.solidCube ~size:1.0);;

let cube = function
	| Depth_vertex (x, y, z, d) ->
		GlMat.push ();
		GlMat.translate ~x:x ~y:y ~z:z ();
		GlMat.rotate ~angle:40.0 ~x:1.0 ~y:1.0 ~z:1.0 ();
		Glut.solidSphere ~radius:5.0 ~slices:5 ~stacks:5;
		GlMat.pop ()