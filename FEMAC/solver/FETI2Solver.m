classdef FETI2Solver < FETIBaseSolver
%FETI2SOLVER Summary of this class goes here
%   Detailed explanation goes here

  properties
      
  end

  methods
    
    %% ctor FETI2Solver
    function this = FETI2Solver(dis,outbuffer,params,condlist)% {{{ctor
            this@FETIBaseSolver(dis,outbuffer,params,condlist);
      %constructor for FETI2Solver @leistner 05/16
      validateattributes(dis,{'Discretization'},{'nonempty'},'FETI2Solver','dis',1);
      validateattributes(params,{'struct'},{'nonempty'},'FETI2Solver','params',2);
      validateattributes(condlist,{'struct'},{'nonempty'},'FETI2Solver','condlist',3);

    end% }}}end ctor


    %% Setup
    function [] = Setup(this)
      %the FETISetup routine initializes variables that are common for all
      %FETI-routines. that are:
      %St_, F, G, d, e, A
      
      this.SetupBase();
      
      consoleline('START FETI2 SETUP',false);
      tic;
      
      if this.params_.ASSEMBLEDOPS
        for s = 1:this.fetiman_.gNumSub()
          this.St_ = this.St_ + this.Sts_{s};
        end
      else
        error('No non-assembled version implemented')
      end
      
      this.CalcA();
      
      consoleinfo(timestring(toc));
      consoleline('',true);

    end


    %% Solve
    function [status] = Solve(this)
  
      % Initiaize the solver
      [lambda,lambdafull,lambdaN0,lambdaC0] = this.InitSolve();
       k = 1;
       
      % r is the projected (coarse-grid fulfilling) but unpreconditioned residual
      r(:,1) = this.P_'*(this.Pc_'*( (this.d_ - this.F_*lambdaN0(:,1)) )); %this.APPL_PNT(this.APPL_PCT( (this.d_ - this.APPL_FI(lambdaN0(:,1))) ));
      % z is the preconditioned residual which could hurt coarse-grid conditions
      z(:,1) = this.St_*r(:,1);                                            %this.APPL_FIpre(r(:,1));
      %norm(z(:,1))
      % w is the projected and preconditioned residual,
      % it is the new search direction.
      % because this is the first one, it is not orthogonalized against former
      w(:,1) = this.P_*z(:,1);

      % the scalar "residual" that is used to check convergence
      this.res_(k) = sqrt(abs(r(:,k)'*z(:,k)));

      
      consoleline('START FETI2 ITERATIONS',false);
      tic;


      % start the CG iterations
      while (true)
        % at this point, remember that a new (orthogonalised) search
        % directions is already available (either from the CG
        % initialisation or from the former loop)
        %
        % now compute the optimal coefficient for that search direction
        q(:,k) = this.Pc_'*this.F_*w(:,k);                                 %this.APPL_PCT( this.APPL_FI(w(:,k)) );
        delta = q(:,k)'*w(:,k);
        deltaj(k)=delta;
        gamma = r(:,k)'*z(:,k);

        % and adapt the solution vector lambda
        lambda(:,k+1) = lambda(:,k) + (gamma/delta).*w(:,k);
        lambdafull(:,k+1) = lambdaN0 + lambdaC0 + this.Pc_*lambda(:,k+1);  %lambdaN0 + lambdaC0 + this.APPL_PC(lambda(:,k+1));

        % adapt the residual
        % you can adapt the residual in such a way it remains
        % "being projected" (just project the newly added part)
        r(:,k+1) = r(:,k) - (gamma/delta).*this.P_'*this.Pc_'*(q(:,k));              %r(:,k) - (gamma/delta).*this.APPL_PNT(q(:,k));
        
        % precondition the new residual
        z(:,k+1) = this.St_*r(:,k+1);                                      %this.APPL_FIpre(r(:,k+1));
        this.numsdir_(k)=1;
        % reproject it
        w(:,k+1) = this.P_*z(:,k+1);                                       %this.APPL_PN(z(:,k+1));

        % orthogonalise the new search direction against all former ones
        % theoretically, orthogonalisation only against the last search
        % direction (means j = k) is sufficient
        phi=[];
        for j = 1:k
          phi(k,j)=q(:,j)'*w(:,k+1);
          %w(:,k+1)=w(:,k+1)-phi(k,j)/(q(:,j)'*w(:,j))*w(:,j);
          %deltaj=
          w(:,k+1)=w(:,k+1)-(phi(k,j)/deltaj(j))*w(:,j);
        end

        % increase iteration counter
        k = k + 1;

        % check convergence
        this.res_(k) = sqrt(abs(r(:,k)'*z(:,k)));

        % and break the loop if tolerance is reached
        
        %Write results iterationwise
        if this.params_.WRITEITER
          this.AccumulateSubSol(k,lambdafull(:,k));
        end
        
        
        if  this.CheckConvergence(this.res_(k),this.res_(1))==true
          break;
        elseif k == this.Nlm_
          error('Max. number of iterations reached!')
          break;
        end
        


      end
      consoleinfo(['Residual = ' num2str(this.res_(k))]);
      consoleinfo(['after ' num2str(k-1) ' iterations']);

      this.lambda_ = lambdafull(:,k);
      
      this.numiter_=k-1;
      this.residual_=this.res_(k);

      status=1;
      
      consoleinfo(timestring(toc));
      consoleline('',true);
      
    end
    
    
    %% calcSt
    function y = calcSt(this)
      % create preconditioner matrix @scheucher 07/16

      if this.params_.ASSEMBLEDOPS
% %         y = this.St_*x;
        this.St_=this.St_;
        if this.params_.VERBOSE
          consoleinfo('FETI2Solver.APPL_FIpre: Using assembled FIpre operator!');
        end
      else
        this.St_ = sparse(this.Nlm_);
        for s=this.fetiman_.numsubstructs_
          % temp: multiplicity scaling
          temp = this.fetiman_.Bs_{s}(:,this.fetiman_.ifacedofslids_{s})*this.fetiman_.Bs_{s}(:,this.fetiman_.ifacedofslids_{s})';
          temp = pinv(temp);
          this.St_ = this.St_ + (temp*(this.fetiman_.Bs_{s}(:,this.fetiman_.ifacedofslids_{s}) * this.fetiman_.Ks_{s}(this.fetiman_.ifacedofslids_{s},this.fetiman_.ifacedofslids_{s}) * this.fetiman_.Bs_{s}(:,this.fetiman_.ifacedofslids_{s})')*temp');
        end
      end
    end
  
    
    
  end

end

