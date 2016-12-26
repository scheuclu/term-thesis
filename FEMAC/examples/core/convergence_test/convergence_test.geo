lc = 2e-1;

Point(1) = {0, 0, 0, lc};
Point(2) = {15, 0, 0, lc};

Line(1) = {1,2};



out1[] = Extrude{0, 1, 0}{ Line{1}; Layers{1/lc}; Recombine;};



Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {3} ;
Physical Line("y neumann ",3) = {4} ;
Physical Surface("surface material steel",4) = {5};
