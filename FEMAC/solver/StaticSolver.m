classdef StaticSolver < handle
  %UNTITLED2 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    dis_
    condlist_
    sol_
  end
  
  methods
    function this = StaticSolver(dis,condlist)
      this.dis_=dis;
      this.condlist_=condlist;
    end
    
    function [] = Solve(this)

      consoleline('Matrix Assembly',false);
      tic
      numdof=this.dis_.gNumDof();
      numnode=this.dis_.gNumNode();
      numelestiff =this.dis_.gNumEle('stiff');

% % %       tic
      LHS=sparse(numdof,numdof);
      %LHS=spalloc(numdof,numdof,160000);%TODO check, why the
% performance gains are so little
      RHS=sparse(numdof,1);

      %loop over all elements, create element matrices and directly asseble them
      for iterele=1:numelestiff
        dofs=this.dis_.gElement('stiff',iterele).gDofIDs();
        LHS=AssembleMat(LHS, this.dis_.gElement('stiff',iterele).Evaluate() ,dofs);
        %LHS(dofs,dofs)=LHS(dofs,dofs)+this.dis_.gElement('stiff',iterele).Evaluate();
      end
      %nnz(LHS) %give number of nonzero entries
      consoleinfo(timestring(toc));
      consoleline('',true)

      %% Apply all kinematic conditions
      consoleline('START APPLYING CONDITIONS',false);
      tic
      for itercond=this.condlist_.kin
           [LHS,RHS]=itercond{:}.Apply(LHS,RHS,this.dis_);
      end
      consoleinfo(timestring(toc));
      consoleline('',true);

      consoleline('START SYSTEM SOLVE',false);
      tic;
      consoleinfo('using standard solver');
      this.sol_=LHS\RHS;
      this.sol_(isnan(this.sol_))=0;
      consoleinfo(timestring(toc));
      consoleline('',true)
      
    end
    
    function sol = Solution(this)
      sol=this.sol_;
    end
    
  end
  
end

