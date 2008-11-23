type trans = Linear | Quart
type ease = None | EaseOut | EaseIn | EaseInOut

let ease_in trans pos = 
	trans pos
	
let ease_out trans pos =
	1. -. trans (1. -. pos)

let ease_in_out trans pos =
	if pos <= 0.5 then
		(trans (2. *. pos)) /. 2.
	else
		(2. -. (trans (2. *. (1. -. pos)))) /. 2.

let linear pos =
	pos

let quart pos =
	pos ** 4.

let get_transition = function
	| Linear -> linear
	| Quart -> quart

let get_ease = function
	| None | EaseIn -> ease_in
	| EaseOut -> ease_out
	| EaseInOut -> ease_in_out

let get_animation t e =
	(fun x -> ((get_ease e) (get_transition t) x))
