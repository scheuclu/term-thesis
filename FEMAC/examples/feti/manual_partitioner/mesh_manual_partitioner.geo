grid_size=5.2;

Point(1) = {0,0,0,grid_size};
Point(2) = {1,0,0,grid_size};
Point(3) = {2,0,0,grid_size};
Point(4) = {3,0,0,grid_size};
// Point(5) = {0,1,0,grid_size};
Point(6) = {1,1,0,grid_size};
Point(7) = {2,1,0,grid_size};
// Point(8) = {3,1,0,grid_size};


Line(1) = {1, 2};
Line(2) = {3,4};

Line(3) = {2,3};
Line(4) = {3,6};
Line(5) = {6,7};


// lineextrude1[] = Extrude{0,1,0}{Line{1}; Layers{1}; Recombine; };
// lineextrude2[] = Extrude{0,1,0}{Line{2}; Layers{1}; Recombine; };
lineextrude1[] = Extrude{0,1,0}{Line{1};};
lineextrude2[] = Extrude{0,1,0}{Line{2};};


Line Loop(1) = {3, 4,-lineextrude1[2]};
Plane Surface(3) = {1};

Line Loop(2) = {4,5,lineextrude2[3]};
Plane Surface(4) = {2};


Physical Point("xy dirichlet point",1) = {1};
Physical Line("x dirichlet line",2) = lineextrude1[3];
Physical Line("x neumann line",3) = lineextrude2[2];



Physical Surface("material1",4) = {lineextrude1[1],4};
Physical Surface("material2",5) = {lineextrude2[1],3};

Physical Surface("sub1",6) = {lineextrude1[1],3};
Physical Surface("sub2",7) = {lineextrude2[1]};
Physical Surface("sub3",8) = {4};


Geometry.LabelType=2;
Geometry.SurfaceNumbers=1;
Geometry.LineNumbers=1;
Geometry.PointNumbers=1;
Mesh.SurfaceFaces=1;
Solver.ShowInvisibleParameters=1;Recombine Surface {1};

