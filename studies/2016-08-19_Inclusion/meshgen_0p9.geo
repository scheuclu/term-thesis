DefineConstant[ total_x = {9, Min 0, Max 120, Step 1,
                         Name "1_Total size/size x"} ];

DefineConstant[ total_y = {9, Min 0, Max 120, Step 1,
                         Name "1_Total size/size y"} ];

DefineConstant[ numele_x_per_sub = {15, Min 1, Max 1200, Step 1,
                         Name "2_NumEle/numele x per sub"} ];

DefineConstant[ numele_y_per_sub = {15, Min 1, Max 1200, Step 1,
                         Name "2_NumEle/numele y per sub"} ];

DefineConstant[ numsubs_x = {3, Min 1, Max 1200, Step 1,
                         Name "3_NumSub/numsubs x"} ];

DefineConstant[ numsubs_y = {3, Min 1, Max 1200, Step 1,
                         Name "3_NumSub/numsubs y"} ];
                         
DefineConstant[ inclusionratio = {0.9, Min 0, Max 1, Step 0.1,
                         Name "5_Inclusion/Ratio y"} ];

DefineConstant[ tag_pattern1 = {4, Min 1, Max 9999, Step 1,
                         Name "4_Tags/tag_pattern1"} ];

DefineConstant[ tag_pattern2 = {5, Min 1, Max 9999, Step 1,
                         Name "4_Tags/tag_pattern2"} ];

DefineConstant[
  patterntype = {0, Choices{0,1,2},Name "5_Patterntype/Pattern type"}];
  
DefineConstant[
  quadmesh = {1, Choices{0,1},Name "6_Mesh/QuadMesh"}];


width_sub =total_x/numsubs_x;
height_sub=total_y/numsubs_y;

lineright = {};
lineleft  = {};
linebottom= {};
linetop   = {};


width_inclusion=width_sub*inclusionratio;
width_lattice=width_sub-width_inclusion;

height_inclusion=height_sub*inclusionratio;
height_lattice=height_sub-height_inclusion;


// grid_size = width_per_subdomain/numele_x_per_sub;
grid_size = (total_x/numsubs_x)/numele_x_per_sub;


Point(1) = {0,0,0,grid_size};
// temp[]=Extrude{total_x,0,0}{Point{1}; };
// temp[]=Extrude{0,width_lattice/2,0}{Line{temp[1]}; };




latticelines={};
inclusionlines={};

latticesurfaces={};
inclusionsurfaces={};




frontpoint=1;
For i In {1:numsubs_x}
pointextrude[] = Extrude{width_lattice/2,0,0}{Point{frontpoint}; };
frontpoint=pointextrude[0];
latticelines+=pointextrude[1];
pointextrude[] = Extrude{width_inclusion,0,0}{Point{frontpoint}; };
frontpoint=pointextrude[0];
inclusionlines+=pointextrude[1];
pointextrude[] = Extrude{width_lattice/2,0,0}{Point{frontpoint}; };
frontpoint=pointextrude[0];
latticelines+=pointextrude[1];
EndFor


For i In {1:numsubs_x}
  For j In {1:numsubs_y}
    substructs~{i}~{j}={};
  EndFor
EndFor

For sy In {1:numsubs_y}

For sx In {1:numsubs_x}
    //Create bottom lattice surfaces
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{latticelines[0+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[0+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==1)
      lineleft+=lineextrude[3];
    EndIf
    
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{latticelines[1+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[1+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==numsubs_x)
      lineright+=lineextrude[2];
    EndIf
    
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{inclusionlines[sx-1]}; };
    latticesurfaces+=lineextrude[1];
    inclusionlines[sx-1]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    
    
    //Create mixed surfaces inbetween
    lineextrude[] = Extrude{0,height_inclusion,0}{Line{latticelines[0+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[0+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==1)
      lineleft+=lineextrude[3];
    EndIf
    
    lineextrude[] = Extrude{0,height_inclusion,0}{Line{latticelines[1+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[1+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==numsubs_x)
      lineright+=lineextrude[2];
    EndIf

    lineextrude[] = Extrude{0,height_inclusion,0}{Line{inclusionlines[sx-1]}; };
    inclusionsurfaces+=lineextrude[1];
    inclusionlines[sx-1]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    
    
    
    
    //Create top lattice surfaces
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{latticelines[0+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[0+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==1)
      lineleft+=lineextrude[3];
    EndIf
    
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{latticelines[1+(sx-1)*2]}; };
    latticesurfaces+=lineextrude[1];
    latticelines[1+(sx-1)*2]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];
    If (sx==numsubs_x)
      lineright+=lineextrude[2];
    EndIf
    
    
    lineextrude[] = Extrude{0,height_lattice/2,0}{Line{inclusionlines[sx-1]}; };
    latticesurfaces+=lineextrude[1];
    inclusionlines[sx-1]=lineextrude[0];
    substructs~{sx}~{sy}+=lineextrude[1];

EndFor



EndFor



Physical Line("line left",1) = lineleft[];
Physical Line("line right",2) = lineright[];

Physical Surface("lattice surfaces",3) = latticesurfaces[];
Physical Surface("inlusion surfaces",4) = inclusionsurfaces[];


Physical Surface("sub 1",101) = substructs~{1}~{1}[];
Physical Surface("sub 2",102) = substructs~{2}~{1}[];
Physical Surface("sub 3",103) = substructs~{3}~{1}[];
Physical Surface("sub 4",104) = substructs~{1}~{2}[];
Physical Surface("sub 5",105) = substructs~{2}~{2}[];
Physical Surface("sub 6",106) = substructs~{3}~{2}[];
Physical Surface("sub 7",107) = substructs~{1}~{3}[];
Physical Surface("sub 8",108) = substructs~{2}~{3}[];
Physical Surface("sub 9",109) = substructs~{3}~{3}[];



Geometry.LabelType=2;
Geometry.SurfaceNumbers=1;
Geometry.LineNumbers=1;
Geometry.PointNumbers=1;
Mesh.SurfaceFaces=1;
Solver.ShowInvisibleParameters=1;
