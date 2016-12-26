classdef ProblemFETIPre < ProblemBasePre
  
  properties
    
    solver_=[];                  %FETI solver object
    outbufferssub_@OutputBuffer  %Output buffers for all substructures

  end
  
  methods
    function this = ProblemFETIPre(params,datpath,datdir)
             this = this@ProblemBasePre(params,datpath,datdir);
      %ctor for ProblemFETI @scheucher 06/16
      validateattributes(params,   {'struct'},{'nonempty'},'ProblemFETI','params',   1);
      validateattributes(datpath,  {'char'},  {'nonempty'},'ProblemFETI','datpath',  2);
      validateattributes(datdir,   {'char'},  {'nonempty'},'ProblemFETI','datdir',   3);
      
    end
    
    
    function [] = Calc(this)
      
      %% Read the mesh in
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

