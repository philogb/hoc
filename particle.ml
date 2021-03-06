(** The particule module handles particle transformations/interpolations *)

open VertexType
open Str
open String
open ParticleTrans
open Transition

(** Similar to the Camera transition, an animation operation is a
    particle transformation, its duration and special information about
        how this animation is done *)
type animation_op = transformation * float * (Transition.trans * Transition.ease)

let iof = int_of_float

(** The particule model handles the logic for particle animation/interpolation 
    see Camera *)
class particle_model =
 object (self)
    val mutable start_frame = ([] : depth_vertex list)
    val mutable last_frame =  ([] : depth_vertex list)
    val mutable loaded_frame =([] : depth_vertex list)
    val mutable transition = (Linear, None)
    val mutable time = 0.
    val mutable total_frames = 0.
    val mutable refresh_frames = false
    
    (** Sets the current particle animation/interpolation to be performed *)
    method set_animation current_frame anim =
        let (inv, refresh_after, t) = anim in
        let (trans, tf, trans_type) = t in
        let anim = ParticleTrans.get_trans trans in
        if refresh_after then
            loaded_frame <- Loader.get_frame (iof (current_frame +. tf));
        if not inv then
            begin
                start_frame <- last_frame;
                last_frame <- anim loaded_frame
            end
        else
            begin
                start_frame <- anim loaded_frame;
                last_frame <- loaded_frame
            end;
        self#balance;

        time <- 0.;
        total_frames <- tf;
        transition <- trans_type;
        refresh_frames <- refresh_after
    
    (** Increases relative animation time *)
    method step =
        if time < total_frames then
                time <- time +. 1.

    (** Interpolates the particle, rendering the result *)
    method draw current_frame =
        if time = total_frames && refresh_frames then
            begin
                loaded_frame <- Loader.get_frame (iof current_frame);
                last_frame <- loaded_frame;
                start_frame <- loaded_frame
            end;    
        
        let delta = time /. total_frames in
        let (trans, ease) = transition in
        let delta_val = Transition.get_animation trans ease delta in 
            GlDraw.begins `points;
            List.iter2 (fun x y ->
                            let DVertex(x, y, z, d) = Interpolate.cartesian x y delta_val in
                            let color = d /. 255.0 in
                            GlDraw.color (color, color, color);
                            GlDraw.vertex ~x: x ~y: y ~z: z ()
                ) start_frame last_frame;
            GlDraw.ends ()

    (** Balances the first or the last frame in order to have the same amount of particles *)
        method balance =
            let len = List.length in
            let start, last = (len start_frame, len last_frame) in
            let count = abs (start - last) in
            for i = 0 to pred count do
                if start < last then
                    start_frame <- (List.hd start_frame) :: start_frame
                else
                    last_frame  <- (List.hd last_frame) :: last_frame
            done
end