classdef CondEleQuad4 < ElementBase

  properties(Access = private)
    val_
    onoff_
    
    %mshtag_
  end

  methods(Access=public)
    function this=CondEleQuad4(ID,node1,node2,node3,node4,tags)% {{{ctor
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
    
    function [] = sVal(this,val)
      this.val_=val;
    end
    
    function [] = sOnOff(this,onoff)
      this.onoff_=onoff;
    end
    
    function result = gVal(this,val)
      result=this.val_;
    end
    
    function result = gOnOff(this,onoff)
      result=this.onoff_;
    end
  
  function result = Evaluate(this)% {{{stiffness evaluation
%       result=0;
%       error('not yet implemented');
      
      
      
      
      
%       [gpx,gpw]=gaussrule('line2',2);
%       
%       vec1=zeros(2,1);
%       vec2=zeros(2,1);
% 
%       for k=1:length(gpx)%begin gausspoint loop
% 
%         %jacobi of a line elemnt is h/2
%         deltax=this.nodes_(2).X()-this.nodes_(1).X();
%         deltay=this.nodes_(2).Y()-this.nodes_(1).Y();
%         deltaz=this.nodes_(2).Z()-this.nodes_(1).Z();
%         h=sqrt(deltax^2+deltay^2+deltaz^2);
%         J=h*0.25;
%         N_xi=shapefunctions('line2',gpx(k));
%         
%         vec1=vec1+N_xi*this.val_(1)*gpw*J;
%         vec2=vec2+N_xi*this.val_(2)*gpw*J;
% 
%       end%end gausspoint loop
%       
%       vec1=vec1*this.onoff_(1);
%       vec2=vec2*this.onoff_(2);
%       
%       result=[vec1(1);vec2(1); vec1(2); vec2(2)];
      
      %%%%%%%%%%%%%%%% quad4 condition
      [gpx,gpw]=gaussrule('quad4',4);

      vec1=zeros(4,1);
      vec2=zeros(4,1);
      
      for k=1:length(gpx)%begin gausspoint loop

        [ J,detJ,invJ ] = getJacobian('quad4',this.nodes_, gpx(k,:) );

        %dN_dxi=derivshapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        N_xi=shapefunctions('quad4',[gpx(k,1), gpx(k,2)]);
        %dN_dx=dN_dxi*invJ;

%         Nmat=[...
%           N_xi(1) 0         N_xi(2)  0         N_xi(3) 0         N_xi(4) 0
%           0       N_xi(1)   0        N_xi(2)   0       N_xi(3)   0       N_xi(4)];

        vec1=vec1+N_xi*this.val_(1).*gpw*det(J);
        vec2=vec2+N_xi*this.val_(2).*gpw*det(J);

      end%end gausspoint loop
      
      vec1=vec1*this.onoff_(1);
      vec2=vec2*this.onoff_(2);
      
%       result=[...
%               vec1(1) vec2(1)
%               vec1(2) vec2(2)
%               vec1(3) vec2(3)
%               vec1(4) vec2(4)];
            
      result=[...
        vec1(1)
        vec2(1)
        vec1(2)
        vec2(2)
        vec1(3)
        vec2(3)
        vec1(4)
        vec2(4)];
      

    end% }}}

  end

end
