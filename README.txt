MAIN
build with:

 ocamlc -g str.cma -I +camlimages ci_core.cma ci_bmp.cma ci_jpeg.cma -I +lablGL lablglut.cma lablgl.cma main.ml -o main
 
 run with:
 
 env OCAMLRUNPARAM='l=30M,b' ocamlrun ./main
 
 make video with:
 
 ffmpeg -f image2 -r 30 -i ./img%d.bmp -sameq ./out.mpeg -pass 2
 
 ANIMATION
 
ocamlc -g str.cma -I +camlimages ci_core.cma ci_jpeg.cma ci_bmp.cma -I +lablGL lablglut.cma lablgl.cma interpolate.ml transition.ml particleTrans.ml camera.ml particle.ml loader.ml animation.ml -o animation 
 
 run with:
 env OCAMLRUNPARAM='l=30M,b' ocamlrun ./animation
 
 
 con la musica:
  sudo  ffmpeg -f image2 -r 30 -i ./img%d.jpg -sameq -i 1.mp3 ./out.mpeg -pass 2
 
 
 POINTS AVERAGE BOUNDARIES
 [(-104.941787579999243, 395.36581748000151);
 (-889.60895440399463, 353.070581479998111);
 (-6227.00572479999664, 390.804874619996099); (0., 254.82)]