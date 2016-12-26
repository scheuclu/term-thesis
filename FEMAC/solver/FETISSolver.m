classdef FETISSolver < FETIBaseSolver
%FETIS-S Solver class

  properties
  %FIpres_
  %St_
  end

  methods
  
    %% ctor FETISSolver
    function this = FETISSolver(dis,outbuffer,params,condlist)
      %constructor for FETI2Solver @leistner 05/16
      validateattributes(dis,{'Discretization'},{'nonempty'},'FETI2Solver','dis',1);
      validateattributes(outbuffer,{'OutputBuffer'},{'nonempty'},'FETI2Solver','outbuffer',2);
      validateattributes(params,{'struct'},{'nonempty'},'FETI2Solver','params',3);
      validateattributes(condlist,{'struct'},{'nonempty'},'FETI2Solver','condlist',4);
      this@FETIBaseSolver(dis,outbuffer,params,condlist);

    end


    %% Setup
    function [] = Setup(this)
      
      %call Setup Routine of Base class
      this.SetupBase();
      
      consoleline('START FETIS SETUP',false);
      tic;
      
      if this.params_.VERBOSE
        consoleinfo(['FETISSolver.FETISSolver: rigid body modes of substructures: ' num2str(cell2mat(this.Nrbms_))]);
      end

      
      this.CalcA();

      
      consoleinfo(timestring(toc));
      consoleline('',true);

    end


    %% Solve
    function [] = Solve(this)
      
      %call the InitSolve Routine of BaseClass
      [lambda,lambdafull,lambdaN0,lambdaC0] = this.InitSolve();
      k = 1;
      num_searchdir = 0;

      % r is the projected (coarse-grid fulfilling) but unpreconditioned residual
      r(:,1) = this.P_'*(this.Pc_'*( (this.d_ - this.F_*(lambdaN0(:,1))) ));
      % test
      if this.params_.CHECKS && ~isempty(this.C_)
        consoleinfo(['Check: r projected into C coarse-space: ' num2str( norm(this.C_'*r(:,1)) )]);
      end
      if this.params_.CHECKS consoleinfo(['Check: r projected into N coarse-space: ' num2str( norm(this.G_'*r(:,1),'fro') )]); end
      
      % z is the preconditioned residual which could hurt coarse-grid conditions
      for s = 1:this.fetiman_.gNumSub()
        Z{1}(:,s) = this.Sts_{s}*r(:,1);
      end

      % w is the projected and preconditioned residual,
      % it is the new search direction.
      % because this is the first one, it is not orthogonalized against former
      W{1} = this.P_*(Z{1});

      % test
      if this.params_.CHECKS consoleinfo(['Check: W projected into N coarse-space: ' num2str( norm(this.G_'*W{1},'fro') )]); end

      % the scalar "residual" that is used to check convergence
      this.res_(k) = sqrt(abs( r(:,1)'* sum(Z{1},2) ));


      consoleline('START FETIS ITERATIONS',false);
      tic;

      %% start the CG iterations
      while (true)
        % at this point, remember that a new (orthogonalised) search
        % directions is already available (either from the CG
        % initialisation or from the former loop)
        %
        % now compute the optimal coefficient for that search direction
        Q{k} = this.Pc_'*( this.F_*(W{k}) );
        Delta = Q{k}'*W{k};
        Gamma = Z{k}'*r(:,k);
        %consoleinfo(['FETISSolver Delta: ' num2str(Delta)]);
        pDelta{k} = pseudoinverse(Delta);
        %pDelta{k} = pinv(full(Delta));

        % and adapt the solution vector lambda
        lambda(:,k+1) = lambda(:,k) + W{k}*pDelta{k}*Gamma;
        lambdafull(:,k+1) = lambdaN0 + lambdaC0 + this.Pc_*(lambda(:,k+1));

        num_searchdir(k) = size(Z{k},2);

        % adapt the residual
        % you can adapt the residual in such a way it remains
        % "being projected" (just project the newly added part)
        r(:,k+1) = r(:,k) - this.P_'*(Q{k}*pDelta{k}*Gamma);
        % test
        if this.params_.CHECKS consoleinfo(['Check: Error of substructure equilibrium: ' num2str( norm(this.G_'*lambdafull(:,k+1)-this.e_) )]); end
        
        if this.params_.CHECKS && ~isempty(this.C_)
          consoleinfo(['Check: r projected into C coarse-space: ' num2str( norm(this.C_'*r(:,k+1)) )]);
        end
        if this.params_.CHECKS consoleinfo(['Check: r projected into N coarse-space: ' num2str( norm(this.G_'*r(:,k+1)) )]); end
        
        % precondition the new residual
        for s = 1:this.fetiman_.gNumSub()
          Z{k+1}(:,s) = this.Sts_{s}*r(:,k+1);
        end
        
        %Z{k+1}(:,1) = sum(Z{k+1},2);
        %Z{k+1}(:,2:end) = [];
        %Z{k+1} = this.APPL_FIpre(r(:,k+1));
        %norm(Z{k+1})
        % reproject it
        W{k+1} = this.P_*(Z{k+1});
        % test
        if this.params_.CHECKS consoleinfo(['Check: W projected into N coarse-space: ' num2str( norm(this.G_'*W{k+1},'fro') )]); end

        % orthogonalise the new search direction against all former ones
        % theoretically, orthogonalisation only against the last search
        % direction (means j = k) is sufficient
        for j = 1:k
          Theta = Q{j}'*W{k+1};
          W{k+1} = W{k+1} - W{j}*pDelta{j}*Theta;
        end

        % increase iteration counter
        k = k + 1;

        % check convergence
        this.res_(k) = sqrt(abs(  r(:,k)' * sum(Z{k},2)  ));

        %Write results iterationwise
        if this.params_.WRITEITER
          this.AccumulateSubSol(k,lambdafull(:,k));
        end

        % and break the loop if tolerance is reached
        if  this.CheckConvergence(this.res_(k),this.res_(1))==true
          break;
        elseif k == this.Nlm_
          consoleinfo('Max. number of iterations reached!')
          break;
        end

      end
      consoleinfo(['Residual = ' num2str(this.res_(k))]);
      consoleinfo(['after ' num2str(k-1) ' FETI-S iterations with ' num2str(num_searchdir) ' search directions']);

      this.lambda_ = lambdafull(:,k);
      
      this.numiter_=k-1;
      this.residual_=this.res_(k);

      consoleinfo(timestring(toc));
      consoleline('',true);
    end

  end

end

