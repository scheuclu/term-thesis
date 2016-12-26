Point(1) = {0, 0, 0,1};
out1[] = Extrude{0, 1, 0}{ Point{1}; Layers{2}; Recombine; };
out2[] = Extrude{4, 0, 0}{ Line{out1[1]}; Layers{8}; Recombine;};
out3[] = Extrude{0, 0, 1}{ Surface{out2[1]}; Layers{2}; Recombine; };

Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {out1[1]} ;
Physical Surface("x neumann surface ",3) = {22} ;

Physical Volume("volume material steel",4) = {out3[1]} ;

Mesh.SurfaceFaces=1;
Mesh.NbPartitions=7;