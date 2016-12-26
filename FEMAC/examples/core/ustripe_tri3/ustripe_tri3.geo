// Gmsh project created on Sun May  1 20:40:00 2016]
lc=0.05;
Point(1) = {0,0,0,lc};
Point(2) = {3,0,0,lc};
Point(3) = {0,1,0,lc};
Point(4) = {3,1,0,lc};
Point(5) = {0,3,0,lc};
Point(6) = {3,3,0,lc};
Point(7) = {0,4,0,lc};
Point(8) = {3,4,0,lc};
Point(9) = {3,2,0,lc};

Line(1)={1, 2};
Circle(2) = {2, 9, 8};
Line(3)={8, 7};
Line(4)={7, 5};
Line(5)={5, 6};
Circle(6) = {4, 9, 6};
Line(7)={4, 3};
Line(8)={3, 1};

Line(9)={2, 4};
Line(10)={6, 8};

Line Loop(11) = {1,9,7,8} ;
Line Loop(12) = {2,-10,-6,-9} ;
Line Loop(13) = {5,10,3,4} ;


Plane Surface(1) = {11} ;
Plane Surface(2) = {12} ;
Plane Surface(3) = {13} ;


Physical Point("xy dirichlet point",1) = {1} ;
Physical Line("x dirichlet line",2) = {8} ;
Physical Line("z neumann ",3) = {4} ;

Physical Surface("surface material steel",4) = {2} ;
Physical Surface("surface material aluminium",5) = {1,3} ;
