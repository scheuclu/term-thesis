DefineConstant[ total_x = {12, Min 0, Max 120, Step 1,
                         Name "1_Total size/size x"} ];

DefineConstant[ total_y = {3, Min 0, Max 120, Step 1,
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
  patterntype = {1, Choices{0,1,2},Name "5_Patterntype/Pattern type"}];
  
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


