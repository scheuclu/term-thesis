classdef ErrorCalculator < handle
  %Error caculation class @scheucher 06/16
  
  properties(Access=private)
    primarysol_@function_handle  %analytic function
    dis_    @Discretization      %Discretization object
    sol_    @double              %displacement solution
    eval_=struct(...
                 'l2',    false,...
                 'h1',    false,...
                 'energy',false)
  end
  
  methods(Access=public)
    
    function this = ErrorCalculator(dis,params)
      %constructor for error calculator @scheucher 06/16
      validateattributes(params,{'struct'},{'nonempty'},'ErrorCalculator','params',1);
      
      this.dis_=dis;
      this.eval_.l2    =params.EVAL_L2;
      this.eval_.h1    =params.EVAL_H1;
      this.eval_.energy=params.EVAL_ENERGY;
      
      this.primarysol_=str2func(['@(x,y,z,t)',params.PRIMARYSOL]);
      
    end
    
    function [] = Eval(this,sol)
      %evaluate all required errors
      validateattributes(sol,{'double'},{'vector','numel',this.dis_.gNumDof()},'Eval','sol',1);
      
      consoleline('START ERROR EVALUATION',false);
      tic;
      
      if this.eval_.l2
        l2error=this.EvalL2(sol);
        consoleinfo(['total L2-Error:     ',num2str(rowvec(l2error))]);
      end
      
      if this.eval_.h1
        error('not yet implemented');
      end
      
       if this.eval_.energy
        error('note yet implemented');
       end
       
       consoleinfo(timestring(toc));
       consoleline('',true);
      
    end
       
  end%end methods public
  
  methods(Access=private)
        
    function result = EvalL2(this,sol)
      %computes the L2-error over the whole domain
      %error is computed for every node and written to this.dis_
      %returns one scalar value for every dimension @scheucher 06/16
      validateattributes(sol,{'double'},{'nonempty','vector','numel',this.dis_.gNumDof()},'EvalL2','sol',1);

      
      l2error=zeros(this.dis_.gNumNode(),3);
      
      %loop over all nodes
      for iter = 1:this.dis_.gNumNode()

        curnode=this.dis_.gNodes(iter);
        cursol=sol(curnode.gDofs());
        
        if length(cursol)<3
          cursol(3)=0;
        end

        anasol=this.primarysol_(curnode.X(),curnode.Y(),curnode.Z(),0);
        
        error=abs(cursol-anasol);
        l2error(iter,:)=error;

      end
      this.dis_.outbuffer_.WriteNodalVector('l2_error',l2error);
      result=this.IntegrateScalar(l2error);
      
    end
    
    function result = IntegrateScalar(this,nodeerror)
      %integrates node-based scalars over the whole domain
      %returns one integral value for every dimension @scheucher 06/16
      validateattributes(nodeerror,{'double'},{'nonempty','nrows',this.dis_.gNumNode()},'IntegrateScalar','nodeerror',1);
         
      totalerror=[0;0;0];
      for iter=1:this.dis_.gNumEle('stiff')
        curele=this.dis_.gElement('stiff',iter);
        curnodes=curele.gNodeIDs();
        xval=nodeerror(curnodes,1);
        yval=nodeerror(curnodes,2);
        
        totalerror(1)=totalerror(1)+curele.IntegrateScalar(xval);
        totalerror(2)=totalerror(2)+curele.IntegrateScalar(yval);
      end

      result=totalerror;% 3 components, one for every direction
      
    end
      
  end%end methods private
  
end

