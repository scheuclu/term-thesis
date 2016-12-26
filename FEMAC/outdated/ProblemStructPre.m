classdef ProblemStructPre < ProblemBasePre
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    solver_
  end
  
  methods
    
    function this = ProblemStructPre(params,datpath,datdir)
             this = this@ProblemBasePre(params,datpath,datdir);
       
    end
    
    
    function [] = Calc(this)
      
      %% read the mesh in
      consoleline('START MESH READING',false);
      tic;
      
      this.meshreader_.ReadMesh();   
      dis=this.dis_; 
      save(this.params_.GENERAL.DISPATH,'dis','-mat');
      consoleinfo(['wrote mesh to file: ',this.params_.GENERAL.DISPATH]);
      
      consoleinfo(timestring(toc));
      consoleline('',true);
    end
    
  end
  
end

