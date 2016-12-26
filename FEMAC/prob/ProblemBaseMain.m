classdef ProblemBaseMain < handle
  
  properties
    
    dis_     @Discretization    %Discretization object, stores all geometric entities
    params_  @struct            %Parmeters, as specified in the dat-file
    filepath_  @char
    
    disreader_@DISReader
    
    materials_
    condlist_ @struct           %Struct containing kinematic and material condition objects
    condman_  @ConditionManager %Object that handles the resolving and application of conditions
    outbuffer_@OutputBuffer     %Temporary storage for all information that is written to the oputput at the end
    plotter_  @MatlabPlot       %FEMAC Plotter
    
  end
  
  methods
    
    %% ProblemBaseMain
    function this = ProblemBaseMain(params,datpath,materials,condlist,datdir)
      %constructor for ProblemBase @scheucher 07/16
      validateattributes(params,   {'struct'},{'nonempty'},'ProblemBase','params',   1);
      validateattributes(datpath,  {'char'},  {'nonempty'},'ProblemBase','datpath',  2);
      validateattributes(materials,{'cell'},  {'nonempty'},'ProblemBase','materials',3);
      validateattributes(condlist, {'struct'},{'nonempty'},'ProblemBase','condlist', 4);
      validateattributes(datdir,   {'char'},  {'nonempty'},'ProblemBase','datdir',   5);
      
      this.params_   =params;
      this.filepath_ =datpath;
      this.condlist_ =condlist;
      this.materials_=materials;
      
      this.outbuffer_=OutputBuffer();
      this.outbuffer_.sTimeIndex(1);
       
      this.params_.GENERAL.MESHPATH  = strrep(this.params_.GENERAL.MESHPATH,  '<thisdir>', datdir);
      this.params_.GENERAL.DISPATH   = strrep(this.params_.GENERAL.DISPATH,   '<thisdir>', datdir);
      this.params_.GENERAL.RESPATH   = strrep(this.params_.GENERAL.RESPATH,   '<thisdir>', datdir);
      
      %The logfile stores all information that is printed to the
      %matlab-console. Its generation can be triggered in the .dat-file
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
      
      
      %Create discretization object
      switch this.params_.GENERAL.PROBLEMTYPE
        case 'structure'
          this.dis_ = Discretization(this.params_.GENERAL.PROBLEMDIM);
        case 'feti'
          this.dis_ = Discretization(this.params_.GENERAL.PROBLEMDIM);
        otherwise
          error(['unknown problem type: ',this.params_.GENERAL.PROBLEMTYPE]);
      end
      
      %Create dis-reader object
      this.disreader_=DISReader(this.dis_,this.params_.GENERAL.DISPATH);         
     
      %Create matlab plotter
      if isfield(this.params_,'MATLABOUT')
        this.plotter_=MatlabPlot(this.dis_);
      end
      
      %Create condition manager
      this.condman_ = ConditionManager(this.dis_,this.outbuffer_,this.condlist_,this.materials_);
      
       
    end
    
    %% Work
    function [sol] = Work(this)
      %calls all necessary routines for the main part of a FEMAC run
      % @scheucher07/16
      
      %Read the mesh in
      this.disreader_.ReadMesh();
      
      this.dis_.outbuffer_=this.outbuffer_;
      
      %Initialize the output buffer
      this.outbuffer_.Init(this.dis_.gNumNode(),this.dis_.gNumEle('stiff'),this.dis_.gNumDof());
      
      %Resolve all conditions
      this.condman_.ResolveAll();
      
      %Plot setup if required
      if ~isempty(this.plotter_)
        if isfield(this.params_.MATLABOUT,'PLOTSETUP')
             this.plotter_.SetParams(this.params_.MATLABOUT.PLOTSETUP);
             this.plotter_.PlotAll(figure());
        end
      end
     
      %Solve the system
      this.solver_.Solve();
      sol=this.solver_.Solution();
      this.outbuffer_.WriteNodalVector('displacement',reshape(full(this.solver_.Solution()),2,this.dis_.gNumNode() )');
 
    end
    
    
  end
  
end

