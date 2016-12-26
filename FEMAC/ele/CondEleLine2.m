classdef CondEleLine2 < ElementBase

  properties(Access = private)
    val_
    onoff_
    
    %mshtag_
  end

  methods(Access=public)
    function this=CondEleLine2(ID,node1,node2,tags)% {{{ctor
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.numnode_=2;
      this.tags_=tags;
      this.edges_=[1 2];
      this.polygons_=[];
    end% }}}
    
    function [] = sVal(this,val)
      this.val_=val;
    end
    
    function [] = sOnOff(this,onoff)
      this.onoff_=onoff;
    end
    
    function result = gVal(this)
      result=this.val_;
    end
    
    function result = gOnOff(this)
      result=this.onoff_;
    end
  
  function result = Evaluate(this)% {{{stiffness evaluation
      [gpx,gpw]=gaussrule('line2',2);
      
      vec1=zeros(2,1);
      vec2=zeros(2,1);

      for k=1:length(gpx)%begin gausspoint loop

        %jacobi of a line elemnt is h/2
        deltax=this.nodes_(2).X()-this.nodes_(1).X();
        deltay=this.nodes_(2).Y()-this.nodes_(1).Y();
        deltaz=this.nodes_(2).Z()-this.nodes_(1).Z();
        h=sqrt(deltax^2+deltay^2+deltaz^2);
        J=h*0.25;
        N_xi=shapefunctions('line2',gpx(k));
        
        vec1=vec1+N_xi*this.val_(1)*gpw*J;
        vec2=vec2+N_xi*this.val_(2)*gpw*J;

      end%end gausspoint loop
      
      vec1=vec1*this.onoff_(1);
      vec2=vec2*this.onoff_(2);
      
      result=[vec1(1);vec2(1); vec1(2); vec2(2)];

    end% }}}

  end

end
