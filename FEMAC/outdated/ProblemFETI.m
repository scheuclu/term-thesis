classdef ProblemFETI < ProblemBase
  
  properties
    
    solver_=[];                  %FETI solver object
    outbufferssub_@OutputBuffer  %Output buffers for all substructures

  end
  
  methods
    function this = ProblemFETI(params,datpath,materials,condlist,datdir)
             this = this@ProblemBase(params,datpath,materials,condlist,datdir);
      %ctor for ProblemFETI @scheucher 06/16
      validateattributes(params,   {'struct'},{'nonempty'},'ProblemFETI','params',   1);
      validateattributes(datpath,  {'char'},  {'nonempty'},'ProblemFETI','datpath',  2);
      validateattributes(materials,{'cell'},  {'nonempty'},'ProblemFETI','materials',3);
      validateattributes(condlist, {'struct'},{'nonempty'},'ProblemFETI','condlist', 4);
      validateattributes(datdir,   {'char'},  {'nonempty'},'ProblemFETI','datdir',   5);
           
      %% Creating solver object
      % solver is specified in the dat-file
      switch this.params_.SOLVER.NAME
        case 'FETI2Solver'
          this.solver_ = FETI2Solver(this.dis_,this.outbuffer_,this.params_.SOLVER.PARAMS,this.condlist_);
        case 'FETISSolver'
          this.solver_ = FETISSolver(this.dis_,this.outbuffer_,this.params_.SOLVER.PARAMS,this.condlist_);
        otherwise
          error(['unknown solver: ',this.params_.SOLVER.NAME]);
      end
      
    end
    
    
    function [] = Calc(this)
      
      %% Read the mesh in
      this.meshreader_.ReadMesh();
% % %       dis=this.dis_;
% % %       
% % %       save('./examples/feti/ustripe_chaco_fetis_coarsegeneo/ustripe_chaco_fetis_coarsegeneo.dis','dis','-mat')
% % %       aaa=load('./examples/feti/ustripe_chaco_fetis_coarsegeneo/ustripe_chaco_fetis_coarsegeneo.dis','-mat')
      
      
      %% Initialize the output buffer
      this.outbuffer_.Init(this.dis_.gNumNode(),this.dis_.gNumEle('stiff'),this.dis_.gNumDof());
      
      
      %% Resolve all condiitions
      % associates conditions with elements via the tags specified in the
      % dat-file
      this.condman_.ResolveAll();
      
      
      %% Plot setup if required
      % matlab plotting of the setup
      % triggered by dat-file
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTSETUP')
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTSETUP);
             this.plotter_.PlotAll(figure());
        end
      end

      
      %% Solve the system
      this.solver_.Solve();
      sol=this.solver_.Solution();
      this.outbuffer_.WriteNodalVector('displacement',reshape(full(this.solver_.Solution()),2,this.dis_.gNumNode() )');
      
      %% Plot exploded view with Lagrange multipliers
      % matlab plotting of the setup
      % triggered by dat-file
      if isfield(this.params_,'MATLABOUT')
          if isfield(this.params_.MATLABOUT,'PLOTLAG')
              flag=figure();
              hold on
              this.solver_.fetiman_.Visualize(flag,this.params_.MATLABOUT.PLOTLAG);
              this.solver_.fetiman_.VisualizeLag(flag);
          end
      end
      
      
      %% Simple iteration output
      % this will write just one file per timestep, but will provide
      % substructure-based oputput vectors
      %the phython scripts can be used to visualize the FETI iterations
      if strcmp(this.params_.SOLVER.PARAMS.WRITEITER,'simple')
        this.solver_.WriteSubSolFullBased(this.outbuffer_)
      end
      
      
      %% Full iteration output
      % this will write numsub output-files for every timestep.
      % All files are independet vtk-files
      % Iterations are written as multiple solution vectors
      if strcmp(this.params_.SOLVER.PARAMS.WRITEITER,'full')
        
        % create OutputWriter for substructures
        subwriter=FETIVTKWriter(this.solver_.fetiman_,this.params_.OUTPUT);
        
        % write substructure solutions to outputtbuffers
        this.outbufferssub_=this.solver_.WriteSubSolSubBased(this.outbufferssub_);
        
        % posprocess primary solution on substructures
        % triggered by dat-file
        if isfield(this.params_,'POSTPROC')
          this.outbufferssub_=this.solver_.PostProcSubSol(this.params_.POSTPROC,this.outbufferssub_);
        end
        
        %write all substructures to files
        subwriter.Write(this.outbufferssub_,1);
      end
         
      
      %% Postprocess the solution
      % postproccess the primary solution on the main discretization
      if isfield(this.params_,'POSTPROC')
        this.postproc_.SetParams(this.params_.POSTPROC);
      end
      this.postproc_.Process(sol);
      

      %% Write output
      % Writes the combined output to a file
      if isfield(this.params_,'OUTPUT')
        this.outwriter_.WriteFile(this.outbuffer_,1);
      end
      
      
      %% Plot setup
      % matlab plotting of the result
      % triggered by dat-file
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTRESULT')
             this.dis_.ApplyDisp(sol);
             this.plotter_.Reset();
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTRESULT);
             this.plotter_.PlotAll(figure());
        end
      end
      
      
      %% Print Information
      consoleline('INFO',false);
      consoleinfo(['dat   -file: ',this.filepath_]);
      consoleinfo(['mesh  -file: ',this.params_.GENERAL.MESHPATH]);
      consoleinfo(['output-file: ',this.outwriter_.filepath_]);
      consoleinfo(['matlab-version: ',version]);
      
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
        
      consoleinfo(['calculated on : ',date,' by ',user,' on ',system]);
      
      gitinfo=getGitInfo();
      if isstruct(gitinfo)
        consoleinfo(['git-hash: ',gitinfo.hash]);
      else
        consoleinfo(['git-hash: ','unknown']);
      end
      
      consoleline('',true);
        
     
    end
  end
  
end

