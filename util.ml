open String
open Str

let boundaries ()=
			let sample = "/home/nicolas/hoc/HoC1/" in
			let ans = ref [(0., 0.); (0., 0.); (0., 0.); (0., 0.)] in
			let avg = ref [(0., 0.); (0., 0.); (0., 0.); (0., 0.)] in
			let max_frame = 500. in
			for csv = 1 to 500 do
				let channel = open_in (sample ^ (string_of_int csv) ^ ".csv") in
				try 
					while true do
						let line = input_line channel in
						let sp = split (regexp ",") (sub line 0 (pred (length line))) in
						let line_list = List.map float_of_string sp in
						let temp = ref [] in
							List.iter2 (fun (a, b) c ->
								temp := ((min a c), (max b c)) :: !temp) !ans line_list;
							ans := List.rev !temp
					done;
				with End_of_file -> 
					Printf.printf "%d \n" csv;
					close_in_noerr channel;
					avg := List.map2 (fun (a, b) (c, d) -> (a +. c, b +. d)) !ans !avg
			done;
			List.map (fun (x, y) -> (x /. max_frame, y /. max_frame)) !avg
			
let lines ()= 
	let sample = "/home/nicolas/hoc/HoC1/" in
			for csv = 1 to 500 do
				let channel = open_in (sample ^ (string_of_int csv) ^ ".csv") in
				let count = ref 0 in
				try 
					while true do
						let line = input_line channel in
						count := !count + 1
					done;
				with End_of_file -> 
					Printf.printf "%d \n" !count;
					close_in_noerr channel;
					count := 0
			done;

