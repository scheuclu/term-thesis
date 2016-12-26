classdef EleQuad4 < ElementBase

  properties(Access = private)
  end

  methods(Access=public)
    function this=EleQuad4(ID,node1,node2,node3,node4,tags)% {{{ctor
      %constructor for EleQuad4 @scheucher 05/16
      validateattributes(ID,   {'numeric'}, {'scalar'},  'EleQuad4','ID',   1);
      validateattributes(node1,{'NodeBase'},{'nonempty'},'EleQuad4','node1',2);
      validateattributes(node2,{'NodeBase'},{'nonempty'},'EleQuad4','node2',3);
      validateattributes(node3,{'NodeBase'},{'nonempty'},'EleQuad4','node3',4);
      validateattributes(node4,{'NodeBase'},{'nonempty'},'EleQuad4','node4',5);
      validateattributes(tags, {'numeric'}, {'vector','nonempty'},'EleTri3','tags',6);
      
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.nodes_(3)=node3;
      this.nodes_(4)=node4;
      this.numnode_=4;
      this.tags_=tags;
      
      this.edges_=[1 2;2 3;3 4;4 1];
      this.polygons_=[1 2 3 4];
      
    end% }}}

    function [] = temp(this)
      [gpx,gpw]=gaussrule('quad4',4);

      numDOF=size(4,1);
      elemat=zeros(8,8);
      elevec=zeros(8,1);


      for k=1:length(gpx)%begin gausspoint loop

        [ J,detJ,invJ ] = getJacobian(this.nodes_, gpx(k,1), gpx(k,2) );

        dN_dxi=derivshapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        N_xi=shapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        dN_dx=dN_dxi*invJ;

        Bmat=[...
          dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0  dN_dx(4,1)          0
                   0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)          0 dN_dx(4,2)
          dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1) dN_dx(4,2) dN_dx(4,1)];
      end
        
    end
    
    
    function elemat = Evaluate(this)% {{{stiffness evaluation
      [gpx,gpw]=gaussrule('quad4',4);

      numDOF=size(4,1);
      elemat=zeros(8,8);
      elevec=zeros(8,1);


      for k=1:length(gpx)%begin gausspoint loop

        [ J,detJ,invJ ] = getJacobian('quad4',this.nodes_, gpx(k,:) );

        dN_dxi=derivshapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        N_xi=shapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        dN_dx=dN_dxi*invJ;

        Bmat=[...
          dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0  dN_dx(4,1)          0
                   0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)          0 dN_dx(4,2)
          dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1) dN_dx(4,2) dN_dx(4,1)];
        Cmat=[...
              1        this.nu_ 0
              this.nu_ 1        0
              0        0        1-this.nu_]*this.E_/(1-this.nu_^2);

        elemat=elemat+Bmat'*Cmat*Bmat*detJ*gpw(k);

      end%end gausspoint loop


    end% }}}
    
    function result = IntegrateScalar(this,nodevalues)
      %comment
      validateattributes(nodevalues,{'double'},{'vector','column','numel',this.numnode_},'IntegrateScalar','nodevalues',1);
      
      
      [gpx,gpw]=gaussrule('quad4',2);
      
      result=0;

      for k=1:length(gpx)%begin gausspoint loop
        [ ~,detJ,~ ] = getJacobian('quad4',this.nodes_, [gpx(k,1), gpx(k,2)] );
        N_xi=shapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        
        result=result+rowvec(N_xi)*nodevalues*detJ*gpw(k);

      end%end gausspoint loop

      %pause()
    end
    
    
    function stressvec = ComputeEleStresses(this,u)
      %compute stresses from displacement solution u @scheucher 05/16
      validateattributes(u,{'numeric'},{'vector','nonempty'},'funcname','u',1);
        
%         [gpx,gpw]=gaussrule('quad4',4);
%         
%         stressvec=zeros(3,1);
%         
%        for k=1:length(gpx)%begin gausspoint loop
%         
%         %weights=derivshapefunctions('tri3',xi,eta);
%         weights=[-1 -1;1 0;0 1];
%         %J=nodes'*weights;
%         J=[...
%           this.nodes_(1).X() this.nodes_(2).X() this.nodes_(3).X()
%           this.nodes_(1).Y() this.nodes_(2).Y() this.nodes_(3).Y()]*weights;
%         detJ=det(J);
%         invJ=inv(J);
% 
%         %[J,detJ,invJ] = getJacobian(this.nodes_, gpx(k,1), gpx(k,2));
% 
%         dN_dxi=derivshapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
%         N_xi=shapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
%         dN_dx=dN_dxi*invJ;
% 
%         Bmat=[...
%           dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0   dN_dx(4,1)         0
%                    0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)           0 dN_dx(4,2)
%           dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1)  dN_dx(4,2) dN_dx(4,1) ];
%         Cmat=[...
%               1        this.nu_ 0
%               this.nu_ 1        0
%               0        0        1-this.nu_]*this.E_/(1-this.nu_^2);
% 
%         stressvec=stressvec+Cmat*Bmat*u/4;%*detJ*gpw(k);%TODO not sure wheter I need detJ and gpw here
%       end%end gausspoint loop    
      

        [J,detJ,invJ] = getJacobian('quad4',this.nodes_,[0 0]);

        dN_dxi=derivshapefunctions('quad4',[0, 0]);
        N_xi=shapefunctions('quad4',[0, 0]);
        dN_dx=dN_dxi*invJ;

        dN_dxi=derivshapefunctions('quad4',[0,0]);
        dN_dx=dN_dxi*invJ;

        Bmat=[...
          dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0   dN_dx(4,1)         0
                   0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)           0 dN_dx(4,2)
          dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1)  dN_dx(4,2) dN_dx(4,1) ];
        Cmat=[...
              1        this.nu_ 0
              this.nu_ 1        0
              0        0        1-this.nu_]*this.E_/(1-this.nu_^2);

        stressvec=Cmat*Bmat*u;%
 
     
    end%end ComputeEleStresses
    


  end

end
