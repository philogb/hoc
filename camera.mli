type camera_op =
    Translate of Gl.point3 * Gl.point3
  | Rotate of float * float * Gl.vect3
type camera_op_list =
    camera_op list * float * (Transition.trans * Transition.ease)
class camera_model :
  object
    val mutable animations : camera_op list
    val mutable time : float
    val mutable total_frames : float
    val mutable transition : Transition.trans * Transition.ease
    method draw : unit
    method get_time : float
    method rotate : float -> float -> Gl.vect3 -> float -> unit
    method set_animations :
      camera_op list * float * (Transition.trans * Transition.ease) -> unit
    method step : unit
    method translate : Gl.point3 -> Gl.point3 -> float -> unit
  end
