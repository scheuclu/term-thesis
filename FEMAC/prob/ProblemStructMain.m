classdef ProblemStructMain < ProblemBaseMain
  %manages the main calculation part of struct problems.
  %the .dis-file is read by the base-class
  %after the solver has finished, the solution and the updated
  %discretization are wrtitten to .res-file and the .dis-file respectively
  
  properties
    solver_
  end
  
  methods
    function this = ProblemStructMain(params,dispath,materials,condlist,datdir)    %constructor
             this = this@ProblemBaseMain(params,dispath,materials,condlist,datdir);%constructor of base-class
      
      
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
    
    
    function [] = Work(this)
      
      %call Work() routine of base-class
      sol=Work@ProblemBaseMain(this);

      %Write results to files
      outbuffer=this.outbuffer_;
      save(this.params_.GENERAL.RESPATH,'sol','outbuffer','-mat');
      
      dis=this.dis_; 
      save(this.params_.GENERAL.DISPATH,'dis','-mat');
 
    end


  end
  
end

