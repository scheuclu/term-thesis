classdef  ElementBase < matlab.mixin.Copyable
  %element base class @scheucher 05/16
  
  properties(Access=public)%protected
    nodes_@NodeBase %array of nodes
    id_     =[]     %element gloabl ID
    numnode_=[]     %number of nodes
    E_      =[]     %E-modulus
    nu_     =[]     %Material parameter
    tags_   =[]     %vector of tags
    edges_  =[]     %geometric edge configuration
    polygons_=[]    %geometric polygon configuration
    type_@char =''
  end
  methods
    %the following function is required in order to build arrays of this object
    function this = ElementBase()
      %constructor for element base class
      
    end
    function [] = sE(this,val)
      %set element E modulus
      validateattributes(val,{'double'},{'scalar','nonempty','nonnegative'},'sE','val',1);
      
      this.E_=val;
    end
    function [] = sNu(this,val)
      %set element parameter nu
      validateattributes(val,{'double'},{'scalar','nonempty','nonnegative'},'sNu','val',1);
      
      this.nu_=val;
    end
    
    function [] = sType(this,type)
      %set element parameter nu
      validateattributes(type,{'char'},{'nonempty'},'sType','type',1);
      
      this.type_=type;
    end
    
    function [] = sID(this,val)
      %set element ID
      validateattributes(val,{'numeric'},{'scalar','nonempty','nonnegative'},'setID','val',1);
      
      this.id_=val;
    end
    
    function [] = sTags(this,tagvec)
      %set element tags
      validateattributes(tagvec,{'numeric'},{'vector','nonempty','nonnegative'},'sTags','tagvec',1);
      
      this.tags_=tagvec;
    end
    
    function result = gTags(this)
      %getter for tags_
      
      result=this.tags_;
    end
    
    function result = getE(this)
      %getter for E_
      
      result=this.E_;
    end
    function result = getnu(this)
      %getter for nu_
      
      result=this.nu_;
    end
    
    function result = gID(this)
      %getter for id_
      
      result=this.id_;
    end
    
    function result = gEdges(this)
      %getter for edges_
      
      result=this.edges_;
    end
    
    function result = gPolygons(this)
      %getter for polygons_
      
      result=this.polygons_;
    end
    
    function result = NumNode(this)
      %getter for NumNode
      
      result=this.numnode_;
    end
     
    function result = gNodes(this)
      %getter for nodes_
      
      result = this.nodes_;
    end
    
    function result = gNode(this,id)
      %getter for nodes_
      validateattributes(id,{'numeric'},{'nonempty','nonnegative'},'gNode','id',1);
      
      result = this.nodes_(id);
    end
    
    
    function result = gNodeIDs(this)
      %getter for node IDs
      
      result=[];
      for curnode=this.nodes_%loop over all nodes
        result=[result,curnode.gID()];
      end
    end
    
    function result = gDofIDs(this)
      %getter for Dof IDs
      
      result=[];
      for curnode=this.nodes_%loop over all nodes
        result=[result,curnode.gDofs()];
      end
    end
    
    function result = Center(this)
      %compute element center
      
      result=[0;0;0];
      for iter=this.nodes_
        result=result+[iter.X();iter.Y();iter.Z()];
      end
      result=result/this.numnode_;
    end
    
    
    function [] = Move(this,dx,dy,dz)
      %move element
      validateattributes(varname,{'classnames'},{'attributes'},'funcname','varname',varnum);
      
      for iter=this.nodes_
        iter.Move(dx,dy,dz);
      end
    end

  end
end

