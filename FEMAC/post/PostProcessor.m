classdef PostProcessor < handle
  %UNTITLED6 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    dis_
    params_=struct(...
                        'ELESTRESSES',   false,...
                        'NODESTRESSES' , false,...
                        'ELESTRAIN',     false,...
                        'NODESTRAIN',    false)
  end
  
  methods
    function this = PostProcessor(dis)
      this.dis_=dis;
    end
    
    function [] = SetParams(this,postparams)
            
      for curfieldname=fieldnames(postparams)'
        this.params_=setfield(this.params_, curfieldname{:}, getfield(postparams,curfieldname{:}));
      end
    end
    
    function [] = Process(this,sol)
      
      
      consoleline('START POSTPROCESSING',false);
      tic
      
      if this.params_.ELESTRESSES == true
        this.dis_.ComputeEleStresses(sol);
        consoleinfo('element stresses processed');
      end
      
      if this.params_.NODESTRESSES == true
        error('post-processing of node stresses not yet implemented');
        consoleinfo('node stresses processed');
      end
      
      if this.params_.ELESTRAIN == true
        error('post-processing of element strain not yet implemented');
        consoleinfo('element strains processed');
      end
      
      if this.params_.NODESTRAIN == true
        error('post-processing of node strain not yet implemented');
        consoleinfo('node strains processed');
      end
      
      consoleinfo(timestring(toc))
      consoleline('',true);
      
      
    end
    
  end
  
end

