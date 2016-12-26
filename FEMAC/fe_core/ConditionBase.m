classdef ConditionBase  < handle
  %Condition base class
  %holds all condition information as speciefied in the dat-file
  %assigns elements, nodes and dofs to the condition
  
  properties(Access=protected)
    dim_        %spacecial dimension
    onoff_      %on or off trigger for every dimension
    val_        %value for every dimension
    nodeids_    %list of affiliated node IDs
    elementids_ %list of affiliated element IDs
    name_       %condition name
    id_         %condition ID
    mshtag_     %condition tag
  end
  
  methods(Access=public)
    function this = ConditionBase()
      %simple constructor @scheucher 05/16
      
    end
    
    function [] = AddElementIDs(this,eleids)
      %adds an array of element IDs to elementids_ @scheucher 05/16
      validateattributes(eleids,{'numeric'},{'row','nonempty','nonnegative'},'AddElementIDs','eleids',1);
      
      this.elemetids=[this.elemetids,eleids];
    end
    
    function [] = AddNodeIDs(this,nodeids)
      %adds an array of node IDs to nodeids_ @scheucher 05/16
      validateattributes(nodeids,{'numeric'},{'row','nonempty','nonnegative'},'AddNodeIDs','nodeids',1);
      
      this.nodeids_=[this.nodeids_,nodeids];
    end
    
    function result = gID(this)
      %getter for id_ @scheucher 06/16
      
      result=this.id_;
    end
    
    function result = gTag(this)
      %getter for mshtag_ @scheucher 06/16
      
      result=this.mshtag_;
    end
    
 
    %basich condition resolve
    function [] = Resolve(this,discrete,listtype)
      %associate the condition with the corresponting elements and nodes
      %this is done via the tags, provided in the msh files @scheucher 05/16
      validateattributes(discrete,{'Discretization'},{'nonempty','scalar'},'Resolve','discrete',1);
      validatestring(listtype,validelelists(),'Resolve','listtype',2);
      
       elelist=discrete.gEleList(listtype);
       numele=length(elelist);     
        
        for iter=1:numele%TODO should work with list here instead
            eletags=elelist{iter}.gTags();
            
            
            if isempty(eletags)
                continue
            end
            
            if eletags(1)==this.mshtag_
                elelist{iter}.sVal(this.val_);
                elelist{iter}.sOnOff(this.onoff_);
                this.elementids_(end+1)=elelist{iter}.gID();
                this.nodeids_=[this.nodeids_,elelist{iter}.gNodeIDs()];
            end
        end
        this.nodeids_=unique(this.nodeids_);     
    end

  end
  
end

