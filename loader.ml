(** Loads CSV files and saves OpenGL rendered images into bmp or jpeg files *)

open Str
open String
open VertexType
open Color

let soi = string_of_int

(** Path to CSV files *)
let path = "/home/nicolas/hoc/HoC1/"

(** Path to image files *)
let img_path = "/home/nicolas/hoc/HoC1/images/"
        
(** Loads a CSV file and returns a 4D vertex array *)
let load_file filename =
    let channel = open_in (path ^ filename) in
    let ans = ref [] in
        try 
            while true do
                let line = input_line channel in
                let sp = split (regexp ",") (sub line 0 (pred (length line))) in
                match List.map float_of_string sp with
                    | [ x; y; z; d ] -> ans := DVertex (x, y, z, d) :: !ans
                    | _ -> raise (Invalid_argument "not a depth vertex")
            done;
            !ans
        with End_of_file | Invalid_argument _ -> close_in_noerr channel; !ans
        
(** Returns a specific frame *)
let get_frame num = load_file ((soi num) ^ ".csv")

(** Saves the rendered OpenGL image into bmp or jpeg files *)
let save_frame num =
    let img_rgb = new OImages.rgb24 1000 600 in
    let pixels = GlPix.read 
        ~x:0 ~y:0 
        ~width:1000 ~height:600 
        ~format:`rgb ~kind:`ubyte
    in
    let praw = GlPix.to_raw pixels in
    let raw = Raw.gets ~pos:0 ~len:(Raw.byte_size praw) praw in
    let w = GlPix.width pixels in
    let h = GlPix.height pixels in

    for i = 0 to pred (w * h) do
        let color_rgb = { r = raw.(i * 3 + 2); 
                          g = raw.(i * 3 + 1); 
                          b = raw.(i * 3 + 0) } 
        in
            img_rgb#set (i mod w) (i / w) color_rgb;
    done;
    
    img_rgb#save (img_path ^ "img" ^ (soi num) ^ ".bmp")
                                                None []
