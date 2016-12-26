classdef EleTri3 < ElementBase

  properties(Access = private)
  end

  methods(Access=public)
    function this=EleTri3(ID,node1,node2,node3,tags)% {{{ctor
      %constructor for EleTri3 @scheucher 05/16
      validateattributes(ID,   {'numeric'}, {'scalar'},  'EleTri3','ID',   1);
      validateattributes(node1,{'NodeBase'},{'nonempty'},'EleTri3','node1',2);
      validateattributes(node2,{'NodeBase'},{'nonempty'},'EleTri3','node2',3);
      validateattributes(node3,{'NodeBase'},{'nonempty'},'EleTri3','node3',4);
      validateattributes(tags, {'numeric'}, {'vector','nonempty'},'EleTri3','tags',5);
      
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.nodes_(3)=node3;
      this.numnode_ =3;
      this.tags_=tags;
      this.edges_=[1 2;2 3;3 1];
      this.polygons_=[1 2 3];
      
    end% }}}
    
    function elemat = Evaluate(this)% {{{stiffness evaluation
      %Evaluate the element @scheucher 05/16
      
      [gpx,gpw]=gaussrule('tri3',4);

      elemat=zeros(6,6);
      elevec=zeros(8,1);
      
      
      Cmat=zeros(3,3);
      if strcmp(this.type_,'plane_stress')
        Cmat=[...
              1        this.nu_ 0
              this.nu_ 1        0
              0        0        (1-this.nu_)/2]*this.E_/(1-this.nu_^2);
      elseif strcmp(this.type_,'plane_strain')
        Cmat=[...
              1-this.nu_           this.nu_ 0
              this.nu_   this.nu_  0
              0          0         (1-2*this.nu_)/2]*this.E_/((1+this.nu_)*(1-2*this.nu_));
      else
        error('Element constitutive type undetermined')
      end


      for k=1:length(gpx)%begin gausspoint loop
        
        weights=[-1 -1;1 0;0 1];
        J=[...
          this.nodes_(1).X() this.nodes_(2).X() this.nodes_(3).X()
          this.nodes_(1).Y() this.nodes_(2).Y() this.nodes_(3).Y()]*weights;
        detJ=det(J);
        invJ=inv(J);

        dN_dxi=derivshapefunctions('tri3',[gpx(k,1), gpx(k,2)]);
        N_xi=shapefunctions('tri3',[gpx(k,1), gpx(k,2)]);
        dN_dx=dN_dxi*invJ;
       
        Bmat=[...
          dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0
                   0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)
          dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1)];
        

        elemat=elemat+Bmat'*Cmat*Bmat*detJ*gpw(k);

      end%end gausspoint loop


    end% }}}
    
    function result = IntegrateScalar(this,nodevalues)
      %comment
      validateattributes(nodevalues,{'double'},{'vector','column','numel',this.numnode_},'IntegrateScalar','nodevalues',1);
      
      
      [gpx,gpw]=gaussrule('tri3',3);
      
      result=0;

      for k=1:length(gpx)%begin gausspoint loop
        [ ~,detJ,~ ] = getJacobian('tri3',this.nodes_, gpx(k,:) );
        N_xi=shapefunctions('tri3',gpx(k,:));
        
        result=result+rowvec(N_xi)*nodevalues*detJ*gpw(k);

      end%end gausspoint loop

      %pause()
    end
    
    
    function stressvec = ComputeEleStresses(this,u)
      %compute stresses from displacement solution u @scheucher 05/16
      validateattributes(u,{'numeric'},{'vector','nonempty'},'funcname','u',1);

        weights=[-1 -1;1 0;0 1];
        J=[...
          this.nodes_(1).X() this.nodes_(2).X() this.nodes_(3).X()
          this.nodes_(1).Y() this.nodes_(2).Y() this.nodes_(3).Y()]*weights;
        detJ=det(J);
        invJ=inv(J);
        
        dN_dxi=derivshapefunctions('tri3',[0, 0]);
        N_xi=shapefunctions('tri3',[0, 0]);
        dN_dx=dN_dxi*invJ;

        dN_dxi=derivshapefunctions('tri3',[0,0]);
        dN_dx=dN_dxi*invJ;

        Bmat=[...
          dN_dx(1,1)         0  dN_dx(2,1)          0  dN_dx(3,1)         0   
                   0 dN_dx(1,2)          0 dN_dx(2,2)           0 dN_dx(3,2)
          dN_dx(1,2) dN_dx(1,1) dN_dx(2,2) dN_dx(2,1)  dN_dx(3,2) dN_dx(3,1)];
        Cmat=[...
              1        this.nu_ 0
              this.nu_ 1        0
              0        0        1-this.nu_]*this.E_/(1-this.nu_^2);

        stressvec=Cmat*Bmat*u;%
             
    end%end ComputeEleStresses


  end

end
