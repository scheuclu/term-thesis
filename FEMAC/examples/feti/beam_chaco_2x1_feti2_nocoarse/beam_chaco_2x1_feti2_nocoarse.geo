Point(1) = {0, 0, 0,1.6};
out1[] = Extrude{0, 1, 0}{ Point{1}; };
out2[] = Extrude{2, 0, 0}{ Line{out1[1]}; };

Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {1} ;
Physical Line("x neumann ",3) = {2} ;

Physical Surface("surface material steel",4) = {5} ;

Mesh.SurfaceFaces=1;
Mesh.NbPartitions=2;