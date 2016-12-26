classdef ProblemBasePre < handle
  %manages the basic steps of femac pre-processing
  %the completeted discretization object is written to a binary file for
  %later usage
  
  properties
    
    dis_       @Discretization  %Discretization object, stores all geometric entities
    params_    @struct          %Parmeters, as specified in the dat-file
    filepath_  @char
    meshreader_                 %Object that reads in the mesh information, creates the elements and stores them in dis_
    outbuffer_ @OutputBuffer    %Temporary storage for all information that is written to the oputput at the end
    
  end
  
  methods
    
    %% ProblemBasePre
    function this = ProblemBasePre(params,datpath,datdir)
      %constructor for ProblemBase @scheucher 07/16
      validateattributes(params,   {'struct'},{'nonempty'},'ProblemBase','params',   1);
      validateattributes(datpath,  {'char'},  {'nonempty'},'ProblemBase','datpath',  2);
      validateattributes(datdir,   {'char'},  {'nonempty'},'ProblemBase','datdir',   3);
      
      this.params_   =params;
      this.filepath_ =datpath;
      
      
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
% % %         this.params_.GENERAL.LOGFILE   = strrep(this.params_.GENERAL.LOGFILE,   '<thisdir>', datdir);
% % %         fid=fopen(this.params_.GENERAL.LOGFILE,'wt');
% % %         fclose(fid);
% % %         diary(this.params_.GENERAL.LOGFILE);
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
        otherwise
          error('msh-format not supported');
      end
       
       
    end
    
    %% Work
    function [] = Work(this)
      %calls all necessary routines for pre-processing @scheucher 07/16
      
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

