DefineConstant[ total_x = {6, Min 0, Max 120, Step 1,
                         Name "1_Total size/size x"} ];

DefineConstant[ total_y = {6, Min 0, Max 120, Step 1,
                         Name "1_Total size/size y"} ];

DefineConstant[ numele_x_per_sub = {8, Min 1, Max 1200, Step 1,
                         Name "2_NumEle/numele x per sub"} ];

DefineConstant[ numele_y_per_sub = {8, Min 1, Max 1200, Step 1,
                         Name "2_NumEle/numele y per sub"} ];

DefineConstant[ numsubs_x = {6, Min 1, Max 1200, Step 1,
                         Name "3_NumSub/numsubs x"} ];

DefineConstant[ numsubs_y = {6, Min 1, Max 1200, Step 1,
                         Name "3_NumSub/numsubs y"} ];

DefineConstant[ tag_pattern1 = {4, Min 1, Max 9999, Step 1,
                         Name "4_Tags/tag_pattern1"} ];

DefineConstant[ tag_pattern2 = {5, Min 1, Max 9999, Step 1,
                         Name "4_Tags/tag_pattern2"} ];

DefineConstant[
  patterntype = {0, Choices{0,1,2},Name "5_Patterntype/Pattern type"}];
  
DefineConstant[
  quadmesh = {0, Choices{0,1},Name "6_Mesh/QuadMesh"}];


width_per_subdomain =total_x/numsubs_x;
height_per_subdomain=total_y/numsubs_y;

lineright = {};
lineleft  = {};
linebottom= {};
linetop   = {};


// grid_size = width_per_subdomain/numele_x_per_sub;
grid_size = (total_x/numsubs_x)/numele_x_per_sub;
Point(1) = {0,0,0,grid_size};
frontpoint=1;

//create bottom line
For i In {1:numsubs_x}
  pointextrude~{i}[] = Extrude{width_per_subdomain,0,0}{Point{frontpoint}; Layers{numele_x_per_sub}; Recombine;};
  frontpoint=pointextrude~{i}[0];
EndFor

//Create Surfaces
For i In {1:numsubs_x}
 frontline=pointextrude~{i}[1];
 For j In {1:numsubs_y}
   If (quadmesh == 1)
     surface~{i}~{j}[] = Extrude{0,height_per_subdomain,0}{Line{frontline}; Layers{numele_x_per_sub}; Recombine;};
   EndIf
   If (quadmesh == 0)
    surface~{i}~{j}[] = Extrude{0,height_per_subdomain,0}{Line{frontline};};
   EndIf
   frontline=surface~{i}~{j}[0];
 EndFor
EndFor


allsurface = {};
pattern1   = {};
pattern2   = {};

//create surface lists
For i In {1:numsubs_x}
 For j In {1:numsubs_y}
  allsurface += surface~{i}~{j}[1];
  
   //horizontal stripes
   If (patterntype == 1)
     If (i%2 == 0)
       pattern1 += {surface~{i}~{j}[1]};
     EndIf
     If (i%2 == 1)
       pattern2 += {surface~{i}~{j}[1]};
     EndIf
   EndIf
   
   //vertical stripes
   If (patterntype == 2)
     If (j%2 == 1)
       pattern1 += {surface~{i}~{j}[1]};
     EndIf
     If (j%2 == 0)
       pattern2 += {surface~{i}~{j}[1]};
     EndIf
   EndIf
   
   //checkerboard pattern
   If (patterntype == 0)
     If ((i+j)%2 == 0)
       pattern1 += {surface~{i}~{j}[1]};
     EndIf
     If ((i+j)%2 == 1)
       pattern2 += {surface~{i}~{j}[1]};
     EndIf
   EndIf
 EndFor
EndFor


//create top and bottom lines
For i In {1:numsubs_x}
  linebottom += pointextrude~{i}[1];
  linetop    += surface~{i}~{numsubs_y}[0];
EndFor

//create left and right line
For j In {1:numsubs_y}
  lineleft    += surface~{1}~{j}[3];
  lineright    += surface~{numsubs_x}~{j}[2];
EndFor


Geometry.LabelType=2;
Geometry.SurfaceNumbers=1;
Geometry.LineNumbers=1;
Geometry.PointNumbers=1;
Mesh.SurfaceFaces=1;
Solver.ShowInvisibleParameters=1;

Physical Point("xy-dirichlet point",1) = {1};
Physical Line("x dirichlet line",2) = lineleft[];
Physical Surface("y neumann ",3) = allsurface[];
Physical Surface("surface material steel",tag_pattern1) = pattern1[];
Physical Surface("surface material rubber",tag_pattern2) = pattern2[];


Physical Surface("sub1",101) = surface~{1}~{1}[];
Physical Surface("sub2",102) = surface~{2}~{1}[];
Physical Surface("sub3",103) = surface~{3}~{1}[];
Physical Surface("sub4",104) = surface~{4}~{1}[];
Physical Surface("sub5",105) = surface~{5}~{1}[];
Physical Surface("sub6",106) = surface~{6}~{1}[];

Physical Surface("sub7",107) = surface~{1}~{2}[];
Physical Surface("sub8",108) = surface~{2}~{2}[];
Physical Surface("sub9",109) = surface~{3}~{2}[];
Physical Surface("sub10",110) = surface~{4}~{2}[];
Physical Surface("sub11",111) = surface~{5}~{2}[];
Physical Surface("sub12",112) = surface~{6}~{2}[];

Physical Surface("sub13",113) = surface~{1}~{3}[];
Physical Surface("sub14",114) = surface~{2}~{3}[];
Physical Surface("sub15",115) = surface~{3}~{3}[];
Physical Surface("sub16",116) = surface~{4}~{3}[];
Physical Surface("sub17",117) = surface~{5}~{3}[];
Physical Surface("sub18",118) = surface~{6}~{3}[];

Physical Surface("sub19",119) = surface~{1}~{4}[];
Physical Surface("sub20",120) = surface~{2}~{4}[];
Physical Surface("sub21",121) = surface~{3}~{4}[];
Physical Surface("sub22",122) = surface~{4}~{4}[];
Physical Surface("sub23",123) = surface~{5}~{4}[];
Physical Surface("sub24",124) = surface~{6}~{4}[];

Physical Surface("sub25",125) = surface~{1}~{5}[];
Physical Surface("sub26",126) = surface~{2}~{5}[];
Physical Surface("sub27",127) = surface~{3}~{5}[];
Physical Surface("sub28",128) = surface~{4}~{5}[];
Physical Surface("sub29",129) = surface~{5}~{5}[];
Physical Surface("sub30",130) = surface~{6}~{5}[];

Physical Surface("sub31",131) = surface~{1}~{6}[];
Physical Surface("sub32",132) = surface~{2}~{6}[];
Physical Surface("sub33",133) = surface~{3}~{6}[];
Physical Surface("sub34",134) = surface~{4}~{6}[];
Physical Surface("sub35",135) = surface~{5}~{6}[];
Physical Surface("sub36",136) = surface~{6}~{6}[];


