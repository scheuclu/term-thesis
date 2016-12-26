classdef ConditionNeumann < ConditionBase
  %ConditionNeumann Class
  %inherits from ConditionBase
  
  properties

  end
  
  methods
    function this = ConditionNeumann(condid,dim,onoff,val,mshtag)
      %constructor for ConditionNeumann @scheucher 05/16
      validateattributes(condid,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionNeumann','condid',1);
      validateattributes(dim,   {'numeric'},{'scalar','nonnegative','nonempty','>=',2,'<=',3},'ConditionNeumann','dim',  2);
      validateattributes(onoff, {'numeric'},{'vector','numel',dim},             'ConditionNeumann','onoff', 3);
      validateattributes(val,   {'numeric'},{'vector','numel',dim},             'ConditionNeumann','val',   4);
      validateattributes(mshtag,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionNeumann','mshtag',5);
      
      this.id_=condid;
      this.dim_=dim;
      this.onoff_ = onoff;
      this.val_=val;
      this.mshtag_=mshtag;
    end
    
    function [LHS,RHS] = Apply(this,LHS,RHS,dis)
       %apply the condition to LHS and RHS @scheucher 05/16
      validateattributes(LHS,{'double'},{'square'},'Apply','LHS',1);
      validateattributes(RHS,{'double'},{'column'},'Apply','RHS',2);
      validateattributes(dis,{'Discretization'},{'scalar','nonempty'},'Apply','dis',3);
      
      %every neumann condition put an additional vector to the right hand
      %side
      dRHS=zeros(dis.gNumDof(),1);
      for iter=this.elementids_
          curele=dis.gElement('neumann',iter);
          dRHS=AssembleVec(dRHS,curele.Evaluate(),curele.gDofIDs());
          this.nodeids_=[this.nodeids_,curele.gNodeIDs];
      end
      this.nodeids_=unique(this.nodeids_);
      
      RHS=RHS+dRHS;
    end
    
    
   function [] = Write(this,outbuff)
      %write an indicator for this condition to output @scheucher 05/16
      validateattributes(outbuff,{'OutputBuffer'},{'scalar','nonempty'},'Write','dis',1);
      
      outvec=zeros(outbuff.gNumNode(),1);
      outvec(this.nodeids_)=1;
      outbuff.WriteNodalScalar(['CONDID_',num2str(this.id_) ],outvec);
    end
    
  end
  
  
  
end