classdef CondElePoint1 < ElementBase

  properties(Access = private)
    val_
    onoff_
    
    %mshtag_
  end

  methods(Access=public)
    function this=CondElePoint1(ID,node1,tags)% {{{ctor
      this.id_=ID;
      this.nodes_(1)=node1;
      this.numnode_=1;
      this.tags_=tags;
      this.edges_=[];
      this.polygons_=[];
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
      [gpx,gpw]=gaussrule('line2',2);
      
      [~,index]=find(this.onoff_==1);
      result=this.val_(index);


    end% }}}

  end

end
