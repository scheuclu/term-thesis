classdef FETIASSolver < FETIBaseSolver
%FETIS-S Solver class

  properties
    Fs_
    numdir_
    tau_=NaN
    
%     %temporary variables; their purpose is post analysis of the algorithm
%     %only
%     res_
%     numsdir_
%     ts_

  end

  
  methods
  
    %% ctor FETISSolver
    function this = FETIASSolver(dis,outbuffer,params,condlist)
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
      
      consoleline('START FETI-AS SETUP',false);
      tic;
      
      
      %TODO: put in FETIBaseSolver
      for s = 1:this.fetiman_.gNumSub()
        Fs=this.fetiman_.ts_{s}*this.Ksp_{s}*this.fetiman_.ts_{s}';
        this.Fs_{s} = this.fetiman_.Bs_{s}*Fs*this.fetiman_.Bs_{s}';
      end

      if this.params_.ASSEMBLEDOPS
        
        for s = 1:this.fetiman_.gNumSub()
            this.St_ = this.St_ +this.Sts_{s};
        end
        
      end
      
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
      this.numsdir_ = 0;

      % r is the projected (coarse-grid fulfilling) but unpreconditioned residual
      r(:,1) = this.P_'*(this.Pc_'*( (this.d_ - this.F_*(lambdaN0(:,1))) ));
      
      
      if this.params_.CHECKS && ~isempty(this.C_)
        consoleinfo(['Check: r projected into C coarse-space: ' num2str( norm(this.C_'*r(:,1)) )]);
      end
      if this.params_.CHECKS consoleinfo(['Check: r projected into N coarse-space: ' num2str( norm(this.G_'*r(:,1),'fro') )]); end
      
      Z{1} = this.St_*r(:,1);
      
      % w is the projected and preconditioned residual,
      % it is the new search direction.
      % because this is the first one, it is not orthogonalized against former
      W{1} = this.P_*(Z{1});

      % test
      if this.params_.CHECKS consoleinfo(['Check: W projected into N coarse-space: ' num2str( norm(this.G_'*W{1},'fro') )]); end

      % the scalar "residual" that is used to check convergence
      this.res_(k) = sqrt(abs( r(:,1)'* sum(Z{1},2) ));


      consoleline('START FETI-AS ITERATIONS',false);
      tic;
      
      
      %% Determination of tau-threshold
      if (this.params_.CONTRACTFAC~=Inf && this.params_.TAU~=Inf)
        error('Can`t prescribe both: contraction factor AND Tau')
      elseif this.params_.CONTRACTFAC==Inf && this.params_.TAU==Inf
        error('Neiter contraction factor nor tau prescribed');
      end
      
      
      % TODO check if it would be better to use a subtructure local tau
      % criterion
      
      %tau directly specified by user
      if this.params_.TAU~=Inf
        this.tau_=this.params_.TAU;
      end
      
      %TODO bad implementation
      %contraction factor specified by user
      if this.params_.CONTRACTFAC~=Inf
         fulleig=abs(eig(full(this.F_)));
         fulleig=fulleig(fulleig>1e-10);
         mineig=min(fulleig);
         this.tau_=(1-this.params_.CONTRACTFAC^2)/(mineig*this.params_.CONTRACTFAC^2);
         consoleinfo(['tau has been determined as:',num2str(this.tau_),' through a contraction factor of ',num2str(this.params_.CONTRACTFAC)]);
         
      end
      
      
      
      
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

        pDelta{k} = pseudoinverse(Delta);
        
        alpha{k}=pDelta{k}*Gamma;
        %pDelta{k} = pinv(full(Delta));

        % and adapt the solution vector lambda
        lambda(:,k+1) = lambda(:,k) + W{k}*alpha{k};
        lambdafull(:,k+1) = lambdaN0 + lambdaC0 + this.Pc_*(lambda(:,k+1));
        
        

        % adapt the residual
        % you can adapt the residual in such a way it remains
        % "being projected" (just project the newly added part)
        r(:,k+1) = r(:,k) - this.P_'*(Q{k}*alpha{k});
        
        % test
        if this.params_.CHECKS consoleinfo(['Check: Error of substructure equilibrium: ' num2str( norm(this.G_'*lambdafull(:,k+1)-this.e_) )]); end
        
        if this.params_.CHECKS && ~isempty(this.C_)
          consoleinfo(['Check: r projected into C coarse-space: ' num2str( norm(this.C_'*r(:,k+1)) )]);
        end
        if this.params_.CHECKS consoleinfo(['Check: r projected into N coarse-space: ' num2str( norm(this.G_'*r(:,k+1)) )]); end
        
        
        
        % precondition the new residual
        Z{k+1} = this.St_*r(:,k+1);
        
        
        this.numsdir_(k)=1;

        
        switch this.params_.ADAPTIVITY
          case 'standard'
            
            for s = 1:this.fetiman_.gNumSub()
              ts=( (W{k}*alpha{k})'*(this.Fs_{s}*W{k}*alpha{k})  )/...
                   ( r(:,k+1)'*this.Sts_{s}*r(:,k+1) );

              this.ts_(s,k)=ts; %TODO temorary output

              if ts<this.tau_              
                Z{k+1} = [Z{k+1},this.Sts_{s}*r(:,k+1)]; %Concatenation
                this.numsdir_(k)=this.numsdir_(k)+1;
              else
                %do nothing
              end
            end
            
          case 'lowest'
            
            for s = 1:this.fetiman_.gNumSub()
              ts=( (W{k}*alpha{k})'*(this.Fs_{s}*W{k}*alpha{k})  )/...
                   ( r(:,k+1)'*this.Sts_{s}*r(:,k+1) );

              this.ts_(s,k)=ts;
            end
            [~, index] = sort(this.ts_(:,k),'ascend');
            for s = index(1:4)'            
                Z{k+1} = [Z{k+1},this.Sts_{s}*r(:,k+1)]; %Concatenation
                this.numsdir_(k)=this.numsdir_(k)+1;
            end
            
          case 'block'
            
            for s = 1:this.fetiman_.gNumSub()
              ts=( (W{k}*alpha{k})'*(this.Fs_{s}*W{k}*alpha{k})  )/...
                   ( r(:,k+1)'*this.Sts_{s}*r(:,k+1) );

              this.ts_(s,k)=ts; %TODO temorary output
            end
            [~, index] = sort(this.ts_(:,k),'ascend');
            
            
            
            for s = index(1:floor(length(index)/2))'
                zlow=sparse(this.fetiman_.numlag_,1);
                zlow = zlow+this.Sts_{s}*r(:,k+1);
            end
            this.numsdir_(k)=this.numsdir_(k)+1;
            
            for s = index(floor(length(index)/2)+1:end)'
                zhigh=sparse(this.fetiman_.numlag_,1);
                zhigh = zhigh+this.Sts_{s}*r(:,k+1); 
            end
            this.numsdir_(k)=this.numsdir_(k)+1;
            
            Z{k+1}=[Z{k+1},zlow,zhigh];
            
            
            
            
% % %             for s = index(1:12)'
% % %               zlow=sparse(this.fetiman_.numlag_,1);
% % %               zlow = zlow+this.Sts_{s}*r(:,k+1);
% % %             end
% % %             this.numsdir_(k)=this.numsdir_(k)+1;
% % %             
% % %             for s = index(13:24)'
% % %               zmed=sparse(this.fetiman_.numlag_,1);
% % %               zmed = zmed+this.Sts_{s}*r(:,k+1);
% % %             end
% % %             this.numsdir_(k)=this.numsdir_(k)+1;
% % %             
% % %             for s = index(25:36)'
% % %                 zhigh=sparse(this.fetiman_.numlag_,1);
% % %                 zhigh = zhigh+this.Sts_{s}*r(:,k+1); 
% % %             end
% % %             this.numsdir_(k)=this.numsdir_(k)+1;
% % %             
% % %             Z{k+1}=[Z{k+1},zlow,zmed,zhigh];
            
            
          case 'fast'

            if (k<4)
                    for s = 1:this.fetiman_.gNumSub()

                      ts=( (W{k}*alpha{k})'*(this.Fs_{s}*W{k}*alpha{k})  )/...
                           ( r(:,k+1)'*this.Sts_{s}*r(:,k+1) );

                      this.ts_(s,k)=ts; %TODO temorary output
                    end

                    for s = 1:this.fetiman_.gNumSub()          
                        Z{k+1} = [Z{k+1},this.Sts_{s}*r(:,k+1)]; %Concatenation
                        this.numsdir_(k)=this.numsdir_(k)+1;
                   end 
            else
                    for s = 1:this.fetiman_.gNumSub()

                      ts=( (W{k}*alpha{k})'*(this.Fs_{s}*W{k}*alpha{k})  )/...
                           ( r(:,k+1)'*this.Sts_{s}*r(:,k+1) );

                      this.ts_(s,k)=ts; %TODO temorary output
                    end

                    [sorted_x, index] = sort(this.ts_(:,k),'ascend');

                    for s = 1:this.fetiman_.gNumSub()
                      %take only those, where ts did not increase in the previous step
                      if ((this.ts_(s,k)<this.ts_(s,k-1)) &&  (this.ts_(s,k)/this.ts_(s,1)<5000))         
                        Z{k+1} = [Z{k+1},this.Sts_{s}*r(:,k+1)]; %Concatenation
                        this.numsdir_(k)=this.numsdir_(k)+1;
                      else
                        %do nothing
                      end
                    end

            end       
          otherwise
            error(['unknown adaptivity type',this.params_.ADAPTIVITY])
        end


        W{k+1} = this.P_*(Z{k+1});
        for j = 1:k
          Theta = Q{j}'*W{k+1};
          W{k+1} = W{k+1} - W{j}*pDelta{j}*Theta;
        end
        

        if this.params_.CHECKS consoleinfo(['Check: W projected into N coarse-space: ' num2str( norm(this.G_'*W{k+1},'fro') )]); end

        % orthogonalise the new search direction against all former ones
        % theoretically, orthogonalisation only against the last search
        % direction (means j = k) is sufficient


        % increase iteration counter
        k = k + 1;

        % check convergence
        this.res_(k) = sqrt(abs(  r(:,k)' * sum(Z{k},2)  ));
        consoleinfo(['current residuum: ',num2str(this.res_(k))]);
        
      
      %% temporary substructure residuum     
      for isub=1:this.fetiman_.gNumSub()
        this.rsub_{k}(:,isub)=sparse(this.fetiman_.numlag_,1);
        this.rsub_{k}(this.fetiman_.ifacedofslids_{isub},isub)=r(this.fetiman_.ifacedofslids_{isub},k);
        this.ressub_(isub,k) = sqrt(abs(  this.rsub_{k}(:,isub)' * sum(Z{k},2)  ));
      end
      %% end temporary substructure residuum        
        
        

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
      consoleinfo(['after ' num2str(k-1) ' FETI-AS iterations with ' num2str(this.numsdir_) ' search directions']);

      this.lambda_ = lambdafull(:,k);
      
      this.numiter_=k-1;
      this.residual_=this.res_(k);
      
      this.gap_=r;

      consoleinfo(timestring(toc));
      consoleline('',true);
    end

  end

end

