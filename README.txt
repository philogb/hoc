
        

        HoC is a small OCaml/OpenGL visualization framework that loads CSV files holding 4D coordinates for each frame, applies custom Camera and
        Particle animations to the rendered data and saves each frame in bmp or jpeg formats.

        For a quick overview and POC please go to: <http://blog.thejit.org/2008/12/06/using-ocaml-to-visualize-radioheads-hoc-music-video-part-3/>      

        This project was first conceived as a small visualization framework to operate on Radiohead's House of Cards video data,
        as an advanced alternative to other projects that use the processing language for this.

        This README file covers the following topics:
        1.- Requirements
        2.- Generating a video
        3.- Tutorials on customizing Camera movement and Particle animations
        4.- Documentation
        5.- Credits and License

        

        1.- Requirements
            - OCaml version 3.10.x (I'm using 3.10.2)
            - OpenGL
            - ffmpeg
            - camlimages library <http://pauillac.inria.fr/camlimages/>
            - LablGL library <http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html>

        
        2.- Generating a video
            - Download Radiohead's CSV animation data from <http://code.google.com/p/radiohead/downloads/list>
            - Store all CSV files in the csv directory
            - Compile the project by typing:

            ocamlc str.cma -I +camlimages ci_core.cma ci_jpeg.cma ci_bmp.cma 
            -I +lablGL lablglut.cma lablgl.cma vertexType.ml interpolate.ml transition.ml camera.ml
             loader.ml particleTrans.ml particle.ml main.ml -o main

            - Run the project by typing "./main", you should see that images are generated for each frame in the frames folder
            - Merge all images into a video by typing: ffmpeg -f image2 -r 30 -i ./img%d.jpg -sameq -i 1.mp3 ./out.mpeg -pass 2


        3.- Tutorials on customizing Camera movement and Particle animations
            An overview of the project as well as some quick tutorials can be seen at:
            - <http://blog.thejit.org/2008/11/27/using-ocaml-to-visualize-radioheads-hoc-music-video-part-1/>
            - <http://blog.thejit.org/2008/12/02/using-ocaml-to-visualize-radioheads-hoc-music-video-part-2/>
            - <http://blog.thejit.org/2008/12/06/using-ocaml-to-visualize-radioheads-hoc-music-video-part-3/>
            
        4.- Documentation
            The "doc" folder contains the index.html documentation file. You can find there documentation for
            each module, class and type used as well as syntax colored and commented code generated with ocamldoc.  
        

        5.- Credits and License
            This project was created and is currently mantained by Nicolas Garcia Belmonte <philogb@gmail.com>, <http://blog.thejit.org>
            This project has an MIT license: <http://www.opensource.org/licenses/mit-license.php>

