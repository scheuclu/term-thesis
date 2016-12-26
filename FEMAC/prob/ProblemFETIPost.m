classdef ProblemFETIPost < ProblemBasePost
  %manages the post-processing of FETI-problems.
  %the results of the FETI main routines are read from the disk.
  %in addition to the postprocessing routines of the base class, some
  %FETI-specific postprocessing functions are called
  
  properties
    
    outbufferssub_@OutputBuffer  %Output buffers for all substructures
    fetiman_@FETIManager
    subsol_

  end
  
  methods
    function this = ProblemFETIPost(params,datdir) %constructor
               this@ProblemBasePost(params,datdir) %constructor of base-class
       %constructor for ProblemFETIPost @scheucher07/16
       validateattributes(params,{'struct'},{'nonempty'},'ProblemFETIPost','params',1);
       validateattributes(datdir,{'char'},  {'nonempty'},'ProblemFETIPost','datdir',2);
       
    end
    
    
    function [sol] = Work(this)
      %calls all necessery routines for FETI postprocessing
      %@scheucher 07/16

      %read results from FETI main routine
      inp=load(this.params_.GENERAL.RESPATH,'-mat');
      this.outbufferssub_=inp.outbufferssub;
      this.fetiman_=inp.fetiman;
      this.subsol_=inp.subsol;

      % Plot exploded view with Lagrange multipliers
      if isfield(this.params_,'MATLABOUT')
          if isfield(this.params_.MATLABOUT,'PLOTLAG')
              flag=figure();
              hold on
              this.fetiman_.Visualize(flag,this.params_.MATLABOUT.PLOTLAG);
              this.fetiman_.VisualizeLag(flag);
          end
      end
      
      
      % Simple iteration output
      % this will write just one file per timestep, but will provide
      % substructure-based oputput vectors
      %the phython scripts can be used to visualize the FETI iterations
      if strcmp(this.params_.SOLVER.PARAMS.WRITEITER,'simple')
        %this.solver_.WriteSubSolFullBased(this.outbuffer_);
        this.WriteSubSolFullBased(this.outbuffer_);
      end
      
      
      %% Full iteration output
      % this will write numsub output-files for every timestep.
      % All files are independet vtk-files
      % Iterations are written as multiple solution vectors
      if strcmp(this.params_.SOLVER.PARAMS.WRITEITER,'full')
        
        % create OutputWriter for substructures
        subwriter=FETIVTKWriter(this.fetiman_,this.params_.OUTPUT);
        
        % write substructure solutions to outputtbuffers
        %this.outbufferssub_=this.solver_.WriteSubSolSubBased(this.outbufferssub_);
        this.outbufferssub_=this.WriteSubSolSubBased(this.outbufferssub_);
        
        % posprocess primary solution on substructures
        % triggered by dat-file
        if isfield(this.params_,'POSTPROC')
          %this.outbufferssub_=this.solver_.PostProcSubSol(this.params_.POSTPROC,this.outbufferssub_);
          this.outbufferssub_=this.PostProcSubSol(this.params_.POSTPROC,this.outbufferssub_);
        end
        
        %write all substructures to files
        subwriter.Write(this.outbufferssub_,1);
      end



      %Call base class calculation routine
      Work@ProblemBasePost(this);


    end

    %% WriteSubSolSubBased
    function [outputbuffers] = WriteSubSolSubBased(this,outputbuffers)
      %writes substructure-based step-wise solutions to the outputbuffers
      %one outputbuffer for each substructure @scheucher 07/16
      %%validateattributes(outputbuffers,{'OutputBuffer'},{'nonempty'},'WriteSubSolSubBased','outputbuffers',1);

      
      %initialize the sub outputbuffers
      this.fetiman_.CreateSubDis();                                        %create pseudo Discretizations

      outputbuffers=this.WriteSubSolSubBased_Displs(outputbuffers);        %write displacement steps of all substructures

      %Posprocess Solution on substructures
      for i=1:this.fetiman_.numsubstructs_                                 %loop over substructures
        outputbuffers(i).Init(this.fetiman_.substructs_(i).gNumNode(),...
                                    this.fetiman_.substructs_(i).gNumEle(),...
                                    this.fetiman_.substructs_(i).gNumDof())%TODO chekc if this inti is redunant, because it has already b been done in the above Method
        this.fetiman_.pseudodis_(i).sOuputBuffer(outputbuffers(i));        %ssociate output buffers with pseudo discretizations


       %post -processing
       if isfield(this.params_,'POSTPROC')

         subpostproc=PostProcessor(this.fetiman_.pseudodis_(i));
         subpostproc.SetParams(this.params_.POSTPROC);
         cursubsol=this.subsol_{i};
         subpostproc.Process(cursubsol(:,end));
       end

      end

    end


    %% WriteSubSolSubBased_Displs
    function [outputbuffers] = WriteSubSolSubBased_Displs(this,outputbuffers)
      %writes substructure-based step-wise displacment-solutions to the outputbuffers
      %one outputbuffer for each substructure @scheucher 07/16
      %%validateattributes(outputbuffers,{'OutputBuffer'},{'nonempty'},'WriteSubSolSubBased_Displs','outputbuffers',1);


        for iter=this.fetiman_.gSubs(1:this.fetiman_.gNumSub())            %loop over all substructures
          curbuf=OutputBuffer();                                           %construct new output buffer
          curbuf.Init(iter.gNumNode(),iter.gNumEle(),iter.gNumDof());      %initialize new output buffer
          subid=iter.gID();
          cursubsolutions=this.subsol_{subid};                             %get all solutions for current substructure
          for iterstep=1:size(cursubsolutions,2)                           %loop over current solutions
            curvec=cursubsolutions(:,iterstep);
            curvec=reshape(curvec,2,iter.gNumNode())';
            curbuf.WriteNodalVector(['displacement_ITER',num2str(iterstep)],curvec); %write current iteration step to output
          end

          outputbuffers(iter.gID())=curbuf;
        end

    end


    %% PostProcSubSol
    function [outputbuffers] = PostProcSubSol(this,params,outputbuffers)
      %posprocesses the substructure-based, step-wise displacement
      %solutions
      %results are written to outbutbuffers. one outputbuffer for each
      %substructure @scheucher 07/16
      validateattributes(params,{'struct'},{'nonempty'},'PostProcSubSol','params',1);

        for i=1:this.fetiman_.numsubstructs_
           subpostproc=PostProcessor(this.fetiman_.pseudodis_(i));
           subpostproc.SetParams(struct(params));
           subsol=this.subsol_{i};
           subpostproc.Process(subsol(:,end));
        end

    end

  end
  
end

