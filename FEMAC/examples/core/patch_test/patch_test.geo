lc = 1e-1;

Point(1) = {0, 0, 0};
Point(2) = {1, 0, 0};
Point(3) = {2, 0, 0};
Point(4) = {3, 0, 0};
Point(5) = {4, 0, 0};
Point(6) = {5, 0, 0};


Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};



out1[] = Extrude{0, 1, 0}{ Line{1}; };
out2[] = Extrude{0, 1, 0}{ Line{2}; };
out3[] = Extrude{0, 1, 0}{ Line{3}; };
out4[] = Extrude{0, 1, 0}{ Line{4}; };
out5[] = Extrude{0, 1, 0}{ Line{5}; };


//Recombine Surface {5};
Transfinite Line {1,6,7} = 12 Using Progression 1.0;
Transfinite Line {2,8,10} = 10 Using Progression 1.0;
Transfinite Line {3,12,14} = 4 Using Progression 1.0;
Transfinite Line {4,16,18} = 6 Using Progression 1.0;
Transfinite Line {5,20,22,24} = 16 Using Progression 1.0;

Recombine Surface{13,21};

Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {7} ;
Physical Line("x neumann ",3) = {24} ;

Physical Surface("surface material steel",4) = {9,13,17,21,25} ;
