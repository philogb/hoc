type trans =
    Linear
  | Quad
  | Cubic
  | Quart
  | Quint
  | Circ
  | Sine
  | Back
  | Elastic
type ease = None | EaseOut | EaseIn | EaseInOut
val pi : float
val ease_in : ('a -> 'b) -> 'a -> 'b
val ease_out : (float -> float) -> float -> float
val ease_in_out : (float -> float) -> float -> float
val linear : 'a -> 'a
val quad : float -> float
val cubic : float -> float
val quart : float -> float
val quint : float -> float
val circ : float -> float
val sine : float -> float
val back : float -> float
val elastic : float -> float
val get_transition : trans -> float -> float
val get_ease : ease -> (float -> float) -> float -> float
val get_animation : trans -> ease -> float -> float
