%% Line_elements_example
% demonstrates the internal geometry representation
% for an expalantion of the function arguments, e.g. NodeBase(...), the
% reader is referred to the functions implementations


%% Manually creating the mesh

tic

% creating a Discretization object, that stores all geometrical information
dis1=Discretization(2)

%% MSH tags
tagdirichx   = 1
tagneumann   = 2
tagdirichxy  = 3
tagmat1      = 4

%% creating material
mat1=struct('ID',     1,...
                    'TYPE', 'ST_VENANT_KIRCHOFF',...
                    'E',       60,...
                    'nu',     0.3
                    'type',   'plane_strain');
materials={mat1};

%% creating the nodes
node1=NodeBase(1,2,[1 2],0,0,0);
node2=NodeBase(2,2,[3 4],1,0,0);
node3=NodeBase(3,2,[5 6],2,0,0);
node4=NodeBase(4,2,[7 8],0,2/3,0);
node5=NodeBase(5,2,[9 10],1,2/3,0);
node6=NodeBase(6,2,[11 12],2,2/3,0);
node7=NodeBase(7,2,[13 14],0,4/3,0);
node8=NodeBase(8,2,[15 16],1,4/3,0);
node9=NodeBase(9,2,[17 18],2,4/3,0);

dis1.AddNode(node1);
dis1.AddNode(node2);
dis1.AddNode(node3);
dis1.AddNode(node4);
dis1.AddNode(node5);
dis1.AddNode(node6);
dis1.AddNode(node7);
dis1.AddNode(node8);
dis1.AddNode(node9);

%% creating stiffness elements
ele1=EleQuad4(1,node1,node2,node5,node4,tagmat1);
ele2=EleQuad4(2,node2,node3,node6,node5,tagmat1);
ele3=EleQuad4(3,node4,node5,node8,node7,tagmat1);
ele4=EleQuad4(4,node5,node6,node9,node8,tagmat1);

dis1.AddElement('stiff',ele1);
dis1.AddElement('stiff',ele2);
dis1.AddElement('stiff',ele3);
dis1.AddElement('stiff',ele4);

%% creating conditions

cond_dirichx       = ConditionDirichlet  (1,2,[1 0],[0 0],  tagdirichx);%ConditionDirchlet(condid,dim,onoff,val,mshtag)
cond_dirichxy       = ConditionDirichlet(2,2,[1 1],[0 0],  tagdirichxy);%ConditionDirchlet(condid,dim,onoff,val,mshtag)
cond_neumann =     ConditionNeumann (3,2,[1 0],[16 0],tagneumann);
cond_mat1        = ConditionMaterial   (4, 1,                 tagmat1);%(CONDID, MATID, MSHTAG)


%% creating neumann and dirich eleents
nele1=CondEleLine2(1,node3,node6,tagneumann);
nele2=CondEleLine2(2,node6,node9,tagneumann);

dis1.AddElement('neumann',nele1);
dis1.AddElement('neumann',nele2);

dele1=CondEleLine2(1,node1,node4,tagdirichx);
dele2=CondEleLine2(2,node4,node7,tagdirichx);
dele3=CondElePoint1(3,node1,tagdirichxy);

dis1.AddElement('dirich',dele1);
dis1.AddElement('dirich',dele2);
dis1.AddElement('dirich',dele3);

%% resolve conditions
cond_neumann.Resolve(dis1,'neumann');
cond_dirichx.    Resolve(dis1,'dirich');
cond_dirichxy.  Resolve(dis1,'dirich');
cond_mat1.      Resolve(dis1,materials);



%% create system matrix

numdof=dis1.gNumDof();

LHS=zeros(numdof,numdof);
RHS=zeros(numdof,1);

for iter=1:length(dis1.gEleList('stiff'))
  ele=dis1.gElement('stiff',iter);
  dofs=ele.gDofIDs();
  LHS=AssembleMat(LHS,ele.Evaluate(),dofs);
end

%% Apply all kinematic conditions
[LHS,RHS]=cond_dirichx. Apply(LHS,RHS,dis1);
[LHS,RHS]=cond_dirichxy.Apply(LHS,RHS,dis1);
[LHS,RHS]=cond_neumann. Apply(LHS,RHS,dis1);


sol=LHS\RHS;

%% Visualization
tic

plotter=MatlabPlot(dis1)
plotter.PlotAll(figure());

dis1.ApplyDisp(sol)
plotter.Set('LABNODES',false);
plotter.Set('LABELE',false);
plotter.PlotAll(figure());
