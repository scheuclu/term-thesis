classdef FETIVTKWriter < handle
  
  properties
    fetiman_@FETIManager
    %pseudodis_@PseudoDiscretization
    params_=struct( 'WRITEEVERY', 0,...
                    'FORMAT',     'vtk',...
                    'PATH',       'nopath',...
                    'NAME',       'noname')
    
  end
  
  methods
    function this = FETIVTKWriter(fetiman,params)
      this.fetiman_=fetiman;
      this.SetParams(params);
    end
    
    
    function [] = SetParams(this,params)
      %set solver parameters as specified in input @scheucher 06/16
      validateattributes(params,{'struct'},{'nonempty'},'Settings','params',1);
      
      for iter=fieldnames(this.params_)'
        if isfield(params,iter{:})
          this.params_=setfield(this.params_,iter{:},getfield(params,iter{:}));
        end
      end
    end
    
    function [] = Write(this,outputbuffers,timestep)
      
      filename=this.params_.NAME;
      
      fulldis=this.fetiman_.dis_;
      
      
      %loop over all substructures
      for itersub=this.fetiman_.gSubs(1:this.fetiman_.gNumSub())

        
        this.params_.NAME=[filename,'_SUB_',num2str(itersub.gID())];
        
        test=VTKWriter(this.fetiman_.pseudodis_(itersub.gID()),this.params_);
        test.WriteFile(outputbuffers(itersub.gID()),1);
        
      end
      
      
      
    end
  end
end