Point(1) = {0, 0, 0};
out1[] = Extrude{1, 0, 0}{ Point{1}; Layers{1}; Recombine;};
out2[] = Extrude{1.0, 0, 0}{ Point{out1[0]}; Layers{1}; Recombine; };


out4[] = Extrude{0, 1, 0}{ Line{out1[1],out2[1]}; Layers{1}; Recombine;};


out5[] = Extrude{0, 1, 0}{ Line{3,7}; Layers{1}; Recombine;};

Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {4,12} ;
Physical Line("x neumann ",3) = {9,17} ;

Physical Surface("surface material steel",4) = {6,10,14,18} ;

Mesh.SurfaceFaces=1;
Mesh.NbPartitions=4;
Mesh.Partitioner=1;

