open String
open Str

let _=
			let sample = "/home/nicolas/hoc/HoC1/1500.csv" in
			let channel = open_in sample in
			let ans = Array.make 4 (0.0, 0.0) in
			let len = Array.length ans in
				try 
					while true do
						let line = input_line channel in
						let sp = split (regexp ",") (sub line 0 (pred (length line))) in
						let line_array = Array.of_list (List.map float_of_string sp) in
							for i = 0 to pred (len) do
								let x, y = ans.(i) in
									ans.(i) <- ((min x line_array.(i)), (max y line_array.(i)))
							done;
					done;
					ans
				with End_of_file -> close_in_noerr channel; ans
