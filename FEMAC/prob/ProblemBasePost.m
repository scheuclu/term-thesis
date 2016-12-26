classdef ProblemBasePost < handle
  %manages all basic post-processing in FEMAC
  %reads the binary solution file cerated by femac_main
  
  properties
    
    dis_      @Discretization   %Discretization object, stores all geometric entities
    params_   @struct           %Parmeters, as specified in the dat-file
    
    filepath_ @char             %path to .dat-file
    disreader_@DISReader        %Reader for binary discretization file
    outbuffer_@OutputBuffer     %Temporary storage for all information that is written to the oputput at the end
    
    plotter_  @MatlabPlot       %Matlab plotter
    postproc_ @PostProcessor    %Post-processor
    errorcalc_@ErrorCalculator  %Error-calculator
    outwriter_

  end
  
  methods
    
    %% ProblemBasePost
    function this = ProblemBasePost(params,datdir)
      %constructor for ProblemBase @scheucher 07/16
      validateattributes(params,   {'struct'},{'nonempty'},'ProblemBase','params',   1);
      validateattributes(datdir,   {'char'},  {'nonempty'},'ProblemBase','datdir',   2);

      this.outbuffer_=OutputBuffer();
      this.outbuffer_.sTimeIndex(1);
      
      this.params_   =params;
      this.params_.GENERAL.MESHPATH  = strrep(this.params_.GENERAL.MESHPATH,  '<thisdir>', datdir);
      this.params_.GENERAL.DISPATH   = strrep(this.params_.GENERAL.DISPATH,   '<thisdir>', datdir);
      this.params_.GENERAL.RESPATH   = strrep(this.params_.GENERAL.RESPATH,   '<thisdir>', datdir);

      %The logfile stores all information that is printed to the
      %matlab-console. Its generation can be triggered in the dat-file
      if isfield(this.params_.GENERAL,'LOGFILE')
        if strcmp(this.params_.GENERAL.LOGFILE,'<choose>')
          
          [logfilename, logpathname] = uiputfile('*.log', 'Select a FEMAC log-file');
          if isequal(logfilename,0)
             disp('User selected Cancel');
             return;
          else
             this.params_.GENERAL.LOGFILE=fullfile(logpathname, logfilename);
             disp(['User selected ', this.params_.GENERAL.LOGFILE]);
             disp(' ');
          end
 
        end
% % %         this.params_.GENERAL.LOGFILE   = strrep(this.params_.GENERAL.LOGFILE,   '<thisdir>', datdir);
% % %         fid=fopen(this.params_.GENERAL.LOGFILE,'wt');
% % %         fclose(fid);
% % %         diary(this.params_.GENERAL.LOGFILE);
      end
      
      
      this.dis_ = Discretization(this.params_.GENERAL.PROBLEMDIM);

      %Creating Dis-Reader object
      this.disreader_=DISReader(this.dis_,this.params_.GENERAL.DISPATH);
      
      %Creating post-processor
      this.postproc_=PostProcessor(this.dis_);
      
      %Creating error-calculator
      if isfield(this.params_,'ERROR')
        this.errorcalc_=ErrorCalculator(this.dis_,this.params_.ERROR);
      end
      
      %Creating OutWriter Object
      this.outwriter_=DummyWriter();
      if isfield(this.params_,'OUTPUT')
        
        if isfield(this.params_.OUTPUT,'PATH')
          this.params_.OUTPUT.PATH = strrep(this.params_.OUTPUT.PATH, '<thisdir>', datdir);
        end
         
        switch this.params_.OUTPUT.FORMAT
          case 'vtk'
            this.outwriter_ = VTKWriter(this.dis_,this.params_.OUTPUT);
            %%%sol    = solver.Solve();
          otherwise
            error(['unknown outputformat: ',this.params_.OUTPUT.FORMAT]);
        end
      end
         
     
      %Creating Matlab Plotter
      if isfield(this.params_,'MATLABOUT')
        this.plotter_=MatlabPlot(this.dis_);
      end
           
    end

    
    %% Work
    function [sol] = Work(this)
      %calls all necessary routines for basic FEMAC post-processing
      %@scheucher 07/16

      %Read the mesh in
      this.disreader_.ReadMesh();

      %read all relevant data
      %TODO clean this pretty nasty implementation
      inp=load(this.params_.GENERAL.RESPATH,'-mat');
      this.outbuffer_=inp.outbuffer;
      sol=inp.sol;
       
      %Postprocess the solution on global discretization
      if isfield(this.params_,'POSTPROC')
        this.postproc_.SetParams(this.params_.POSTPROC);
      end
      this.postproc_.Process(sol);
      

      %Write output
      if isfield(this.params_,'OUTPUT')
        this.outwriter_.WriteFile(this.outbuffer_,1);
      end
      
      
      %Plot result
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTRESULT')
             this.dis_.ApplyDisp(sol);
             this.plotter_.Reset();
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTRESULT);
             this.plotter_.PlotAll(figure());
        end
      end
      
      
      %Print information
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

