classdef ConditionDirichlet < ConditionBase
  %ConditionDirichlet Class
  %inherits from ConditionBase
  
  properties

  end
  
  methods
    function this = ConditionDirichlet(condid,dim,onoff,val,mshtag)
      %constructor for ConditionDirichlet @scheucher 05/16
      validateattributes(condid,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionDirichlet','condid',1);
      validateattributes(dim,   {'numeric'},{'scalar','nonnegative','nonempty','>=',2,'<=',3},'ConditionDirichlet','dim',  2);
      validateattributes(onoff, {'numeric'},{'vector','numel',dim},             'ConditionDirichlet','onoff', 3);
      validateattributes(val,   {'numeric'},{'vector','numel',dim},             'ConditionDirichlet','val',   4);
      validateattributes(mshtag,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionDirichlet','mshtag',5);
      
      this.id_    =condid;   %condition ID
      this.dim_   =dim;      %condition dimension
      this.onoff_ = onoff;   %on of trigger for every dimension
      this.val_   =val;      %value for every dimension
      this.mshtag_=mshtag;   %tag provided in msh-file
    end
        
    function [LHS,RHS] = Apply(this,LHS,RHS,dis)
      %apply the condition to LHS and RHS @scheucher 05/16
      validateattributes(LHS,{'double'},{'square'},'Apply','LHS',1);
      validateattributes(RHS,{'double'},{'column'},'Apply','RHS',2);
      validateattributes(dis,{'Discretization'},{'scalar','nonempty'},'Apply','dis',3);
      
      %% go through all "on" dofs that are subject to the DBC
      % the rows of dofs subject to DBCs are set
      % to zero except the diagonal element (set to one)
      % this means, the stiffness matrices are not symmetric anymore
      dofids=dis.gDofIDs(this.nodeids_,this.onoff_);
      if isempty(dofids)
         return;
      end
      
      %% 
      [~,index]=find(this.onoff_==1);
      % write a column vector
      % this is the dof values for one node
      % if only one dof is "on" it is only a single value
      newval=colvec(this.val_(index));
      % repeat for every node
      % results in as many values as dofs,
      % always repeating xval,yval,xval,yval and so on
      % or xval,xval,xval e.g. if yval is "off"
      newval=repmat(newval,length(this.nodeids_) ,1);

      %please note that right now, contradictary dirichlet conditions are
      %not detected
      for index = 1:length(dofids)
          RHS = RHS - LHS(:,dofids(index)).*newval(index);
      end
      RHS(dofids,1)=newval;
      
      LHS(dofids,:)=0;
      LHS(:,dofids)=0;
      for iter=dofids
         LHS(iter,iter)=1.0;
      end
      
    end
        
    function [] = Write(this,outbuffer)
      %write an indicator for this condition to output @scheucher 05/16
      validateattributes(outbuffer,{'OutputBuffer'},{'scalar','nonempty'},'Write','dis',1);
      
      outvec=zeros(outbuffer.gNumNode(),1);
      outvec(this.nodeids_)=1;
      outbuffer.WriteNodalScalar(['CONDID_',num2str(this.id_) ],outvec);
    end
       
  end
  
end

