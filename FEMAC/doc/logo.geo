Fx=0;
Fy=0;

Ex=4;
Ey=0;

Mx=8;
My=0;

Ax=13;
Ay=0;

Cx=18;
Cy=0;

lF=0.6;
lE=0.6;
lM=0.6;
lA=0.6;
lC=0.6;


Point(1) = {Fx+0,Fy+0, 0,lF};
Point(2) = {Fx+1,Fy+0, 0,lF};
Point(3) = {Fx+1,Fy+2, 0,lF};
Point(4) = {Fx+2,Fy+2, 0,lF};
Point(5) = {Fx+2,Fy+3, 0,lF};
Point(6) = {Fx+1,Fy+3, 0,lF};
Point(7) = {Fx+1,Fy+4, 0,lF};
Point(8) = {Fx+3,Fy+4, 0,lF};
Point(9) = {Fx+3,Fy+5, 0,lF};
Point(10) = {Fx+0,Fy+5, 0,lF};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,7};
Line(7) = {7,8};
Line(8) = {8,9};
Line(9) = {9,10};
Line(10) = {10,1};
Line Loop(11) = {1,2,3,4,5,6,7,8,9,10} ;
Plane Surface(1) = {11} ;

//////////////////////////////////////////////////////////////

Point(12) = {Ex+0,Ey+0, 0,lE};
Point(13) = {Ex+3,Ey+0, 0,lE};
Point(14) = {Ex+3,Ey+1, 0,lE};
Point(15) = {Ex+1,Ey+1, 0,lE};
Point(16) = {Ex+1,Ey+2, 0,lE};
Point(17) = {Ex+2,Ey+2, 0,lE};
Point(18) = {Ex+2,Ey+3, 0,lE};
Point(19) = {Ex+1,Ey+3, 0,lE};
Point(20) = {Ex+1,Ey+4, 0,lE};
Point(21) = {Ex+3,Ey+4, 0,lE};
Point(22) = {Ex+3,Ey+5, 0,lE};
Point(23) = {Ex+0,Ey+5, 0,lE};

Line(24) = {12,13};
Line(25) = {13,14};
Line(26) = {14,15};
Line(27) = {15,16};
Line(28) = {16,17};
Line(29) = {17,18};
Line(30) = {18,19};
Line(31) = {19,20};
Line(32) = {20,21};
Line(33) = {21,22};
Line(34) = {22,23};
Line(35) = {23,12};

Line Loop(36) = {24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35};
Plane Surface(2) = {36} ;

///////////////////////////////////////////////////////

Point(24) = {Mx+0,My+0, 0,lM};
Point(25) = {Mx+1,My+0, 0,lM};
Point(26) = {Mx+1,My+3, 0,lM};
Point(27) = {Mx+2,My+1, 0,lM};
Point(28) = {Mx+3,My+3, 0,lM};
Point(29) = {Mx+3,My+0, 0,lM};
Point(30) = {Mx+4,My+0, 0,lM};
Point(31) = {Mx+4,My+5, 0,lM};
Point(32) = {Mx+3,My+5, 0,lM};
Point(33) = {Mx+2,My+3, 0,lM};
Point(34) = {Mx+1,My+5, 0,lM};
Point(35) = {Mx+0,My+5, 0,lM};

Line(37) = {24,25};
Line(38) = {25,26};
Line(39) = {26,27};
Line(40) = {27,28};
Line(41) = {28,29};
Line(42) = {29,30};
Line(43) = {30,31};
Line(44) = {31,32};
Line(45) = {32,33};
Line(46) = {33,34};
Line(47) = {34,35};
Line(48) = {35,24};

Line Loop(49) = {37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48};
Plane Surface(3) = {49};

/////////////////////////////////////////////////////////////////

Point(401) = {Ax+0,Ay+0, 0,lA};
Point(402) = {Ax+1,Ay+0, 0,lA};
Point(403) = {Ax+1.25,Ay+1, 0,lA};
Point(404) = {Ax+2.75,Ay+1, 0,lA};
Point(405) = {Ax+3,Ay+0, 0,lA};
Point(406) = {Ax+4,Ay+0, 0,lA};
Point(407) = {Ax+3,Ay+5, 0,lA};
Point(408) = {Ax+1,Ay+5, 0,lA};

Point(409) = {Ax+1.5,Ay+2, 0,lA};
Point(410) = {Ax+2.5,Ay+2, 0,lA};
Point(411) = {Ax+2,Ay+4, 0,lA};

Line(401) = {401,402};
Line(402) = {402,403};
Line(403) = {403,404};
Line(404) = {404,405};
Line(405) = {405,406};
Line(406) = {406,407};
Line(407) = {407,408};
Line(408) = {408,401};

Line(409) = {409,410};
Line(410) = {410,411};
Line(411) = {411,409};

Line Loop(412) = {401, 402, 403, 404, 405, 406, 407, 408};
Line Loop(413) = {409, 410, 411};
Ruled Surface(401) = {412, 413};
//////////////////////////



//Point(501) = {Cx+0,Cy+0, 0,lC};
Point(502) = {Cx+2.5,Cy+0, 0,lC};
Point(503) = {Cx+3,Cy+0, 0,lC};
Point(504) = {Cx+3,Cy+1, 0,lC};

Point(505) = {Cx+2.5,Cy+1, 0,lC};

Point(506) = {Cx+1,Cy+2.5, 0,lC};
Point(507) = {Cx+2.5,Cy+2.5, 0,lC};

Point(508) = {Cx+2.5,Cy+4, 0,lC};

Point(509) = {Cx+3,Cy+4, 0,lC};
Point(510) = {Cx+3,Cy+5, 0,lC};
Point(511) = {Cx+2.5,Cy+5, 0,lC};
//Point(512) = {Cx+0,Cy+5, 0,lC};
Point(513) = {Cx+0,Cy+2.5, 0,lC};


Line(501) = {502, 503};
Line(502) = {503, 504};
Line(503) = {504, 505};
Circle(504) = {508, 507, 505};
Line(505) = {508, 509};
Line(506) = {509, 510};
Line(507) = {510, 511};
Circle(508) = {511, 507, 502};
Line Loop(509) = {501, 502, 503, -504, 505, 506, 507, 508};
Plane Surface(501) = {509};

/////////////////////////////////////////////////

Physical Line("xy dirichlet line",1) = {1, 24, 37, 42, 401, 405, 501};

Physical Line("y neumann line",2) = {9, 34, 47, 44, 407, 507};

//Physical Surface("surface material steel",3) = {1, 2, 3, 401, 501};

Physical Surface(510) = {1, 2, 3, 401, 501};
