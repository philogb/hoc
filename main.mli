val part : Particle.particle_model
val cam : Camera.camera_model
val timeline :
  < get_frame : float; tick : unit; update_animation : unit;
    update_camera : unit >
val init : 'a -> 'b -> unit
val draw : unit -> unit
val reshape_cb : w:int -> h:int -> unit
val keyboard_cb : key:int -> x:'a -> y:'b -> unit
val update : int -> unit
val main : unit -> unit
