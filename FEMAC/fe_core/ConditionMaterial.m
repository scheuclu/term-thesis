classdef ConditionMaterial < ConditionBase
  %ConditionMaterial Class
  %inherits from ConditionBase
  
  properties
    matid_@double = []  %material ID
    E_@double     = -1  %Youngs modulus
    nu_@double    = -1  %nu parameter
  end
  
  
  methods
    function this = ConditionMaterial(condid,matid,mshtag)
      %constructor @scheucher 05/16
      validateattributes(condid,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionNeumann','condid',1);
      validateattributes(matid, {'numeric'},{'scalar','nonnegative','nonempty'},'ConditionNeumann','matid',1);
      validateattributes(mshtag,{'numeric'},{'scalar','nonnegative','nonempty'},'ConditionNeumann','mshtag',3);
      
      this.id_=condid;
      this.matid_ = matid;
      this.mshtag_=mshtag;
    end
    
    function [] = Resolve(this,discrete,materials)
      %associate the condition with the corresponting elements
      %this is done via the tags, provided in the msh files
      %the material properties on the element are then set appropriately @scheucher 05/15
      validateattributes(discrete,{'Discretization'},{'scalar','nonempty'},'Write','discrete',1);
      validateattributes(materials,{'cell'},{'nonempty'},'Resolve','materials',  2);

      
       for iter=1:discrete.gNumEle('stiff')%TODO should work with list here instead
            eletags=discrete.gElement('stiff',iter).gTags();

            if isempty(eletags)
                continue
            end

            if eletags(1)==this.mshtag_
                this.elementids_(end+1)=discrete.gElement('stiff',iter).gID();
                discrete.gElement('stiff',iter).sE(materials{this.matid_}.E);
                discrete.gElement('stiff',iter).sNu(materials{this.matid_}.nu);
                discrete.gElement('stiff',iter).sType(materials{this.matid_}.type);
            end
        end
    end
    
    
    function [] = Write(this,outbuffer)
      %write an indicator for this condition to output @scheucher 05/16
      validateattributes(outbuffer,{'OutputBuffer'},{'scalar','nonempty'},'Write','dis',1);
      
      outvec=zeros(outbuffer.gNumEle(),1);
      outvec(this.elementids_)=1;
      outbuffer.WriteElementScalar(['MATID_',num2str(this.matid_) ],outvec);
    end
    
    
  end
  
end