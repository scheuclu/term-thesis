classdef ProblemFETIMain < ProblemBaseMain
  %manages the main-part of a FETI simulation
  %discretization object from pre-processing is read from file
  %results are written to binary file
  
  properties
    
    solver_=[];                  %FETI solver object
    outbufferssub_@OutputBuffer  %Output buffers for all substructures

  end
  
  methods
    function this = ProblemFETIMain(params,datpath,materials,condlist,datdir)
             this = this@ProblemBaseMain(params,datpath,materials,condlist,datdir);
      %constructor for ProblemFETI @scheucher 06/16
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
        case 'FETIBSolver'
          this.solver_ = FETIBSolver(this.dis_,this.outbuffer_,this.params_.SOLVER.PARAMS,this.condlist_);
        case 'FETIASSolver'
          this.solver_ = FETIASSolver(this.dis_,this.outbuffer_,this.params_.SOLVER.PARAMS,this.condlist_);
        otherwise
          error(['unknown solver: ',this.params_.SOLVER.NAME]);
      end
      
    end
    
    
    function [] = Work(this)
      %calls all necessary routines for FETI main calculation
      %the results, as well as the updated discretization, are stored to
      %files @scheucher 07/16
      
      %call Work()-routine of base class
      sol=Work@ProblemBaseMain(this);

      %Write solution to file
      outbuffer=this.outbuffer_;
      outbufferssub=this.outbufferssub_;
      fetiman=this.solver_.fetiman_;
      subsol=this.solver_.subsol_;
      save(this.params_.GENERAL.RESPATH,'sol','outbuffer','outbufferssub','fetiman','subsol','-mat');

      %write updated discretization to file
      dis=this.dis_; 
      save(this.params_.GENERAL.DISPATH,'dis','-mat');
           
    end
    
  end
  
end

