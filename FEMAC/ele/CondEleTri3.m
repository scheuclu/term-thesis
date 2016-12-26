classdef CondEleTri3 < ElementBase

  properties(Access = private)
    val_
    onoff_
    
    %mshtag_
  end

  methods(Access=public)
    function this=CondEleTri3(ID,node1,node2,node3,tags)% {{{ctor
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.nodes_(3)=node3;
      this.numnode_=3;
      this.tags_=tags;
      this.edges_=[1 2;2 3;3 1];
      this.polygons_=[1 2 3];
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

      
      
      
%       end%end gausspoint loop
%       
%       vec1=vec1*this.onoff_(1);
%       vec2=vec2*this.onoff_(2);
%       
%       result=[vec1(1);vec2(1); vec1(2); vec2(2)];
      
      %%%%%%%%%%%%%%%% quad4 condition
      [gpx,gpw]=gaussrule('tri3',3);

      vec1=zeros(3,1);
      vec2=zeros(3,1);
      
      for k=1:length(gpx)%begin gausspoint loop

        [ J,detJ,invJ ] = getJacobian('tri3',this.nodes_, gpx(k,:) );

        N_xi=shapefunctions('tri3',[gpx(k,1), gpx(k,2)]);
        
        vec1=vec1+N_xi*this.val_(1).*gpw*det(J);
        vec2=vec2+N_xi*this.val_(2).*gpw*det(J);

      end
      
      vec1=vec1*this.onoff_(1);
      vec2=vec2*this.onoff_(2);
            
      result=[...
        vec1(1)
        vec2(1)
        vec1(2)
        vec2(2)
        vec1(3)
        vec2(3)];
      
      
    end% }}}

  end

end
