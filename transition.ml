type trans = Linear | Quad | Cubic | Quart | Quint | Circ | Sine | Back | Elastic
type ease = None | EaseOut | EaseIn | EaseInOut

let pi = (acos 0.) *. 2.

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

let quad pos =
	pos ** 2.

let cubic pos =
	pos ** 3.

let quart pos =
	pos ** 4.

let quint pos =
	pos ** 5.

let circ pos =
	1. -. (sin (acos pos))

let sine pos =
	1. -. (sin (1. -. pos) *. (pi /. 2.))

let back pos =
	let x = 1.618 in
	pos *. pos *. ((x +. 1.) *. pos +. x)

let elastic pos =
	let pos' = pos -. 1. in
	(2. ** (10. *. pos')) *. cos (20. *. pos *. pi *. 0.333333)


let get_transition = function
	| Linear -> linear
	| Quad -> quad
	| Cubic -> cubic
	| Quart -> quart
	| Quint -> quint
	| Circ -> circ
	| Sine -> sine
	| Back -> back
	| Elastic -> elastic

let get_ease = function
	| None | EaseIn -> ease_in
	| EaseOut -> ease_out
	| EaseInOut -> ease_in_out

let get_animation t e =
	(fun x -> ((get_ease e) (get_transition t) x))
