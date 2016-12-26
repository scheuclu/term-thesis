lc = 1;

Point(1) = {0, 0, 0,lc};
Point(2) = {8, 0, 0,lc};


Line(1) = {1,2};



out1[] = Extrude{0, 1.5, 0}{ Line{1}; Layers{4}; Recombine; };


Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {3} ;
Physical Line("x neumann ",3) = {4} ;

Physical Surface("surface material steel",4) = {5} ;
