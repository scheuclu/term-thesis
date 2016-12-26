classdef ProblemStruct < ProblemBase
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    solver_
  end
  
  methods
    function this = ProblemStruct(params,datpath,materials,condlist,datdir)
             this = this@ProblemBase(params,datpath,materials,condlist,datdir);
      
      
      %% creating Solver object
      switch this.params_.SOLVER.SOLVERNAME
        case 'StaticSolver'
          this.solver_ = StaticSolver(this.dis_,this.condlist_);
        case 'DummySolver'
          this.solver_ = DummySolver(this.dis_,this.condlist_);
        otherwise
          error(['unknown solver: ',this.params_.SOLVER.SOLVERNAME]);
      end
       
    end
    
    
    function [] = Calc(this)
      
      %% read the mesh in
      this.meshreader_.ReadMesh();
      
      %% initialize the output buffer
      this.outbuffer_.Init(this.dis_.gNumNode(),this.dis_.gNumEle('stiff'),this.dis_.gNumDof());
      
      %% resolve all condiitions
      this.condman_.ResolveAll();
      
      %% plot setup if required
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTSETUP')
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTSETUP)
             this.plotter_.PlotAll(figure());
        end
      end

      %% solve the system
      sol=this.solver_.Solve();
      this.outbuffer_.WriteNodalVector('displacement',reshape(full(sol),2,this.dis_.gNumNode() )');
      
      %% postprocess the solution
      
      this.postproc_.SetParams(this.params_.POSTPROC);
      this.postproc_.Process(sol);
      
      %% error calculation
      if ~isempty(this.errorcalc_)
          this.errorcalc_.Eval(sol);
      end
      
      %% write output
      this.outwriter_.WriteFile(this.outbuffer_,0);
      
      
      %% plot result if required
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTRESULT')
             this.dis_.ApplyDisp(sol);
             this.plotter_.Reset();
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTRESULT)
             this.plotter_.PlotAll(figure());
        end
      end
      
      %% print info
      consoleline('INFO',false);
      disp(['dat   -file: ',this.filepath_]);
      disp(['mesh  -file: ',this.params_.GENERAL.MESHPATH]);
      disp(['output-file: ',this.outwriter_.filepath_]);
      disp(['matlab-version: ',version]);
      
      user  ='unknown';
      system='unknown';
      if ispc
        user=getenv('USERNAME');
        system=getenv('OS');
      end
      
      if isunix
        user=getenv('LOGNAME');
        system=getenv('SESSION');
      end
        
      disp(['calculated on : ',date,' by ',user,' on ',system]);
      
      gitinfo=getGitInfo();
      if isstruct(gitinfo)
        disp(['git-hash: ',gitinfo.hash]);
      else
        consoleinfo(['git-hash: ','unknown']);
      end
      %disp(['git-branch: ',gitinfo.branch]);
      %disp(['git-url   : ',gitinfo.url]);
      
      consoleline('',true);
 
    end
  end
  
end

