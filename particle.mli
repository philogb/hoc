type animation_op =
    ParticleTrans.transformation * float *
    (Transition.trans * Transition.ease)
val iof : float -> int
class particle_model :
  object
    val mutable last_frame : VertexType.depth_vertex list
    val mutable loaded_frame : VertexType.depth_vertex list
    val mutable refresh_frames : bool
    val mutable start_frame : VertexType.depth_vertex list
    val mutable time : float
    val mutable total_frames : float
    val mutable transition : Transition.trans * Transition.ease
    method balance : unit
    method draw : float -> unit
    method set_animation :
      float ->
      bool * bool *
      (ParticleTrans.transformation * float *
       (Transition.trans * Transition.ease)) ->
      unit
    method step : unit
  end
