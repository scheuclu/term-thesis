classdef OutputBuffer < handle
  %store all output for one timestep
  
  properties
    numnode_@double=0
    numele_ @double=0
    numdof_ @double=0
    
    tindex_@double
    nodalscalars_ = {}; %list of nodal scalar outputs
    nodalvectors_ = {}; %list of nodal vector outputs
    nodaltensors_ = {}; %list of nodal tensor outputs
    
    elementscalars_ = {}; %list of element scalar outputs
    elementvectors_ = {}; %list of element vetor outputs
    elementtensors_ = {}; %list of element tensor outputs
  end
  
  methods
    function this = OutputBuffer()

    end
    
    function [] = Init(this,numnode,numele,numdof)
      this.numnode_=numnode;
      this.numele_ =numele;
      this.numdof_ =numdof;
    end
    
    function [] = sTimeIndex(this,tindex)
      this.tindex_=tindex;
    end
    
    function val = gNumNode(this)
      val=this.numnode_;
    end
    
    function val = gNumEle(this)
      val=this.numele_;
    end
    
    function val = gNumDof(this)
      val=this.numdof_;
    end
    
   function [] = WriteNodalVector(this,tag,vector)
      %comment to be done
      validateattributes(tag,{'char'},{'nonempty'},'WriteNodalVector','tag',  1);
      validateattributes(vector,{'numeric'},{'nrows',this.gNumNode()},'WriteNodalVector','vector',  2);
      
      if size(vector,2)==2
        vector(:,3)=0;
      end

      this.nodalvectors_{end+1}={tag,vector};
    end
    
    function [] = WriteElementVector(this,tag,vector)
      %comment to be done
      validateattributes(tag,{'char'},{'nonempty'},'WriteNodalVector','tag',  1);
      validateattributes(vector,{'numeric'},{'nrows',this.gNumEle()},'WriteNodalVector','vector',  2);
      
      if size(vector,2)==2
        vector(:,3)=0;
      end

      this.elementvectors_{end+1}={tag,vector};
    end
    
    
    function result = gNodalVectors(this)
      %comment to be done
      
      result=this.nodalvectors_;
    end
    
    function [] = WriteNodalScalar(this,tag,scalars)
      %comment to be done
      validateattributes(tag,{'char'},{'nonempty'},'WriteNodalScalar','tag',  1);
      validateattributes(scalars,{'numeric'},{'vector','numel',this.gNumNode()},'WriteNodalScalar','scalars',  2);
      
      this.nodalscalars_{end+1}={tag,scalars};
    end
    
    
    function [] = WriteElementScalar(this,tag,scalars)
      %comment to be done
      validateattributes(tag,{'char'},{'nonempty'},'WriteElementScalar','tag',  1);
      validateattributes(scalars,{'numeric'},{'vector','numel',this.gNumEle()},'WriteElementScalar','scalars',  2);
      
      this.elementscalars_{end+1}={tag,scalars};
    end
    
    function result = gElementScalars(this)
      %comment to be done
      result=this.elementscalars_;
    end
    
    function result = gElementVectors(this)
      %comment to be done
      result=this.elementvectors_;
    end
    
    function [] = WriteElementTensor(this,tag,vector)
      %comment to be done
      validateattributes(tag,{'char'},{'nonempty'},'WriteElementTensor','tag',  1);
      validateattributes(vector,{'double'},{'nrows',this.gNumEle()},'WriteElementTensor','vector',  2);
      
      this.elementtensors_{end+1}={tag,vector};
    end
    
    
    function result = gElementTensors(this)
      %comment to be done
      
      result=this.elementtensors_;
    end
    
    
    function result = gNodalScalars(this)
      %comment to be done
      
      result=this.nodalscalars_;
    end
    
    
  end
  
end

