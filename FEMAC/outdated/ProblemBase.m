classdef ProblemBase < handle
  
  properties
    
    dis_     @Discretization    %Discretization object, stores all geometric entities
    params_  @struct            %Parmeters, as specified in the dat-file
    
    filepath_  @char
    meshreader_                %Object that reads in the mesh information, creates the elements and stores them in dis_
    
    materials_
    condlist_ @struct           %Struct containing kinematic and material condition objects
    condman_  @ConditionManager %Object that handles the resolving and application of conditions
    outbuffer_@OutputBuffer     %Temporary storage for all information that is written to the oputput at the end
    
    outwriter_                  %Object that writes information from outbuffer_ to output
    plotter_  @MatlabPlot       %Matlab plotting object
    postproc_ @PostProcessor    %Postprocessor

    errorcalc_
  end
  
  methods
    function this = ProblemBase(params,datpath,materials,condlist,datdir)
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
      
      
      this.params_.GENERAL.MESHPATH   = strrep(this.params_.GENERAL.MESHPATH,   '<thisdir>', datdir);
      this.params_.GENERAL.DISPATH   = strrep(this.params_.GENERAL.DISPATH,   '<thisdir>', datdir);

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
        this.params_.GENERAL.LOGFILE   = strrep(this.params_.GENERAL.LOGFILE,   '<thisdir>', datdir);
        fid=fopen(this.params_.GENERAL.LOGFILE,'wt');
        fclose(fid);
        diary(this.params_.GENERAL.LOGFILE);
      end
      
      
      %% Creating Discretization object
      switch this.params_.GENERAL.PROBLEMTYPE
        case 'structure'
          this.dis_ = Discretization(this.params_.GENERAL.PROBLEMDIM);
        case 'feti'
          this.dis_ = Discretization(this.params_.GENERAL.PROBLEMDIM);
        otherwise
          error(['unknown problem type: ',this.params_.GENERAL.PROBLEMTYPE]);
      end
      this.dis_.sOuputBuffer(this.outbuffer_);
          
      
      %% Creating Mesh-Reader object
      switch this.params_.GENERAL.MESHFORMAT
        case 'msh'
          this.meshreader_=MSHReader(this.dis_,this.params_.GENERAL.MESHPATH,this.params_.TAGTYPES);
        case 'dis'
          this.meshreader_=DISReader(this.dis_,this.params_.GENERAL.MESHPATH);
        otherwise
          error('msh-format not supported');
      end
         
      %% Creating post-processor
      this.postproc_=PostProcessor(this.dis_);
      
      %% Creating error-calculator
      if isfield(this.params_,'ERROR')
        this.errorcalc_=ErrorCalculator(this.dis_,this.params_.ERROR);
      end
      
      %% Creating OutWriter Object
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
     
      %% Creating Matlab Plotter
      if isfield(this.params_,'MATLABOUT')
        this.plotter_=MatlabPlot(this.dis_);
      end
      
      %% Creating Condition Manager
      this.condman_ = ConditionManager(this.dis_,this.outbuffer_,this.condlist_,this.materials_);
      
       
    end
    
    
  end
  
end

