classdef FETIBaseSolver < handle
% Base class for FETI solvers
% all solvers try to solve the following base-system:

% |F   G|   |lambda|     |d|
% |     | * |      |  =  | |
% |G'  0|   |alpha |     |e|

  properties
    fetiman_ @FETIManager    %FETI manager object
    dis_     @Discretization %Discretization object
    condlist_@struct         %kinematic conditions
    Nlm_     @double %number of lagrange multipliers
    RsK_     @cell   %basis of rigid body modes
    Ksp_     @cell   %pseudo inverses of substructure matrices Ks
    G_       @double %FETI constraint matrix
    NCoarseOp_ @double %TODO this variable is never set
    CCoarseOp_ @double %TODO this variable is never set

    C_       @double %coarse subspace
    A_       @double %TODO
    F_       @double %TODO
    P_       @double %projector to natural coarse grid
    Pc_      @double %projector to auxilary coarse grid
    Sts_     @cell   %substructure preconditioners
    Ds_      @cell   %substructure local scaling matrices
    D_       @double %scaling matrix
    B_       @double %connectivity matrix
    Bts_     @cell   %substructure local scaled assembling operators
    St_      @double %full preconditioner
    SKs_     @cell   %schurcomplement with Ks
    Ksii_    @cell
    Ksib_    @cell   % compute (b)oundary DOF parts and (i)nternal DOF parts
    Ksbi_    @cell   % (b)oundary = interface, NOT boundaries without neighbours
    Ksbb_    @cell
    d_       @double %interface forces
    e_       @double %interface constraint error
    lambda_  @double %lagrange multipliers

    alphasIndices_   %indices of rigid body modes for all substructures
    Nrbm_    @double %total number of rigid-body modes
    Nrbms_   @cell   %number of rigid body modes for all substructures

    params_=struct( 'NUMSUBSTRUCTS'   ,0,...
                    'ASSEMBLEDOPS'    ,true,...
                    'AMATRIX'         ,'eye',...
                    'VERBOSE'         ,false,...
                    'REASSEMBLESYS'   ,false,...
                    'CHECKS'          ,false,...
                    'PRECONDITIONER', 'Lumped',...
                    'SCALING'         ,'kscaling',...
                    'COARSEGRID'      ,'none',...
                    'GENEOTHRESHOLD'  ,0,...
                    'NUMGENEOMODES'   ,6,...
                    'TERMINATIONTYPE', 'relative',...
                    'TERMINATIONVAL'  ,1e-6,...
                    'ADAPTIVITY'        ,'standard',...
                    'CONTRACTFAC'     ,0.999,...
                    'TAU'             ,Inf,...
                    'WRITEITER'       ,false)
                  
    numiter_@double=NaN;
    residual_@double=NaN;

    subsol_={}; %solutions for all substructures
    
    
    %temporary variables; their purpose is post analysis of the algorithm
    %only
    res_
    numsdir_
    ts_
    tauiter_
    rsub_@cell
    ressub_
    gap_

  end

  methods(Access = public)

    %% ctor FETIBaseSolver_Test
    function this = FETIBaseSolver(dis,outbuffer,params,condlist)
      %constructor for FETI2Solver @leistner 05/16
      validateattributes(dis,{'Discretization'},{'nonempty'},'FETI2Solver','dis',1);
      validateattributes(params,{'struct'},{'nonempty'},'FETI2Solver','params',2);
      validateattributes(condlist,{'struct'},{'nonempty'},'FETI2Solver','condlist',3);

      this.fetiman_ = FETIManager(dis,outbuffer,params.NUMSUBSTRUCTS,condlist);
      this.dis_     = dis;
      this.condlist_= condlist;
      this.Settings(params);

    end
    
    function [] = CalcA(this)
      if isempty(this.St_)
        error('St_ has to be calculated first');
      end
      
      switch this.params_.AMATRIX
        case 'precond'
          this.A_=this.St_;
          consoleinfo('A-matrix taken as preconditioner');
        case 'eye'
          this.A_=speye(this.Nlm_,this.Nlm_);
          consoleinfo('A-matrix taken as unity matrix');
        case 'scaling'
          this.A_=this.D_;  
          consoleinfo('A-matrix taken as scaling matrix');
        otherwise
          error(['Unknown parameter for "AMATRIX": ',this.params_.AMATRIX]);
      end
      
    end


    %% Settings
    function [] = Settings(this,params)
      %set solver parameters as specified in input @scheucher 06/16
      validateattributes(params,{'struct'},{'nonempty'},'Settings','params',1);

      for iter=fieldnames(this.params_)'
        if isfield(params,iter{:})
          this.params_=setfield(this.params_,iter{:},getfield(params,iter{:}));
        end
      end
    end

    %% SetupBase
    function [] = SetupBase(this)

    consoleline('FETI Base Setup',false);
    tic;

    % calculate local bDOF and iDOF indices
    % (here: bDOF = boundary dof, means those with Lagr.Mult. on
    % them)
    % (iDOF = all others)
    for iter=1:this.fetiman_.gNumSub()
        alldofs = this.fetiman_.gSubs(iter).gDofs(':')';
        bdofs = unique(abs(cell2mat(this.fetiman_.gSubs(iter).gIfaceDofGIDs(':')')));
        loc = find(ones(1,length(alldofs))-ismember(alldofs,bdofs));
        idofs = alldofs(loc);
        this.fetiman_.ifacedofslids_{iter}=find(ismember(this.fetiman_.gSubs(iter).gDofs(':')',bdofs));
        this.fetiman_.nonifacedofslids_{iter}=find(ismember(this.fetiman_.gSubs(iter).gDofs(':')',idofs));
    end

    % count number of Lagr. Mult.
    this.Nlm_ = size(this.fetiman_.Bs_{1},1);

    % initialise variables
    this.Nrbm_ = 0;
    this.G_ = [];%%TODO shouldn't one be able to initialize this better?
    this.d_ = sparse(this.Nlm_,1);
    this.e_ = [];
    this.St_ = sparse(this.Nlm_,this.Nlm_);
    this.D_ = sparse(2*this.Nlm_,2*this.Nlm_);
    this.B_ = sparse(this.Nlm_,2*this.Nlm_);    

    if this.params_.ASSEMBLEDOPS
        this.F_ = sparse(this.Nlm_,this.Nlm_);
    end

    % setup FETI variables
    for s = 1:this.fetiman_.gNumSub()

        %TODO this should probably all be done via matrix decomposition
        this.RsK_{s} = sparse(null(full(this.fetiman_.Ks_{s})));%%TODO change this to sparse implementation
        %this.Ksp_{s} = pinv(full(this.fetiman_.Ks_{s}));
        this.Ksp_{s} = pseudoinverse(this.fetiman_.Ks_{s});
        this.Nrbms_{s} = size(this.RsK_{s},2);

        this.alphasIndices_{s} = this.Nrbm_+1 : (this.Nrbm_ + this.Nrbms_{s});
        this.Nrbm_ = this.Nrbm_ + this.Nrbms_{s};

        this.G_ = [this.G_, this.fetiman_.Bs_{s}*this.fetiman_.ts_{s}*this.RsK_{s}];
        this.d_ = this.d_ + this.fetiman_.Bs_{s}*this.fetiman_.ts_{s}*this.Ksp_{s}*this.fetiman_.fs_{s};
        this.e_ = [this.e_; this.RsK_{s}'*this.fetiman_.fs_{s}];%TODO wrong order?
    
    end
    
    if ~strcmp('none',this.params_.SCALING)
      %calculate substructure local scaling matrices Ds
      for s = 1:this.fetiman_.gNumSub()
       switch this.params_.SCALING
          case 'kscaling'
            this.Ksbb_{s} = this.fetiman_.Ks_{s}(this.fetiman_.ifacedofslids_{s},this.fetiman_.ifacedofslids_{s});
            this.Ds_{s} = diag(diag(this.Ksbb_{s}));
          case 'multiplicity'
            this.Ds_{s} = speye(length(this.fetiman_.ifacedofslids_{s}));
          otherwise
            error(['Unknown Scaling: ' this.params_.PRECONDITIONER]);
       end
      end
      %assemble global scaling matrix D
      this.AssembleD();
      %assemble global connectivity matrix B
      this.AssembleB();
      %calculate substructure local, scaled assembling operators Bts
      temp = pseudoinverse(this.B_*((this.D_)\this.B_'));
      %temp = sparse( pinv( full(this.B_*((this.D_)\this.B_') )) );
      for s = 1:this.fetiman_.gNumSub()
        this.Bts_{s} = (this.Ds_{s}\this.fetiman_.Bs_{s}'*temp)';
      end
    else
      %use the unscaled assembling operators
      for s = 1:this.fetiman_.gNumSub() 
        this.Bts_{s} = this.fetiman_.Bs_{s};
      end
    end
    
    %calculate substructure local preconditioners Sts    
    for s = 1:this.fetiman_.gNumSub()
        this.Sts_{s}=sparse(this.Nlm_,this.Nlm_);
        switch this.params_.PRECONDITIONER 
          case 'Lumped'
            %calculate (b)oundary dof parts
            this.Ksbb_{s} = this.fetiman_.Ks_{s}(this.fetiman_.ifacedofslids_{s},this.fetiman_.ifacedofslids_{s});
            %calculate Lumped preconditioners Sts
            this.Sts_{s} = this.Bts_{s}*this.Ksbb_{s}*this.Bts_{s}';
          case 'Dirichlet'
            % calculate substructure local schur complement with K
            this.Ksii_{s} = this.fetiman_.Ks_{s}(this.fetiman_.nonifacedofslids_{s},this.fetiman_.nonifacedofslids_{s});
            this.Ksib_{s} = this.fetiman_.Ks_{s}(this.fetiman_.nonifacedofslids_{s},this.fetiman_.ifacedofslids_{s});
            this.Ksbi_{s} = this.fetiman_.Ks_{s}(this.fetiman_.ifacedofslids_{s},this.fetiman_.nonifacedofslids_{s});
            this.Ksbb_{s} = this.fetiman_.Ks_{s}(this.fetiman_.ifacedofslids_{s},this.fetiman_.ifacedofslids_{s});
            this.SKs_{s} = (this.Ksbb_{s} - this.Ksbi_{s}*(this.Ksii_{s}\this.Ksib_{s}));
            %calculate Dirichlet preconditioners Sts
            this.Sts_{s} = this.Bts_{s}*this.SKs_{s}*this.Bts_{s}';
          otherwise
            error(['Unknown Preconditioner: ' this.params_.PRECONDITIONER]);
        end

        if this.params_.ASSEMBLEDOPS
            Fs=this.fetiman_.ts_{s}*this.Ksp_{s}*this.fetiman_.ts_{s}';
            this.F_ = this.F_ + this.fetiman_.Bs_{s}*Fs*this.fetiman_.Bs_{s}';
            %this.F_ = this.F_ + this.fetiman_.Bs_{s}*(this.Ksp_{s}\this.fetiman_.Bs_{s}');
        end

%          TOL=1e-15;
%         [~, SpRight] = spspaces(this.fetiman_.Ks_{s},2,TOL);
%         this.RsK_{s}=SpRight{1}(:,SpRight{3});
%         this.RsK_{s}=this.RsK_{s}/normest(this.RsK_{s});
%
%         this.Ksp_{s} = pinv(full(this.fetiman_.Ks_{s}));
%         this.Nrbms_{s} = size(this.RsK_{s},2);
%
%         this.alphasIndices_{s} = this.Nrbm_+1 : (this.Nrbm_ + this.Nrbms_{s});
%         this.Nrbm_ = this.Nrbm_ + this.Nrbms_{s};
%
%         this.G_ = [this.G_, this.fetiman_.Bs_{s}*this.RsK_{s}];
%         this.d_ = this.d_ + this.fetiman_.Bs_{s}*this.Ksp_{s}*this.fetiman_.fs_{s};
%         this.e_ = [this.e_; this.RsK_{s}'*this.fetiman_.fs_{s}];
%
%         if this.params_.ASSEMBLEDOPS
%             this.F_ = this.F_ + this.fetiman_.Bs_{s}*this.Ksp_{s}*this.fetiman_.Bs_{s}';
%         end

    end
    consoleinfo(['Scaling: ' this.params_.SCALING]);
    consoleinfo(['Preconditioner: ' this.params_.PRECONDITIONER]);
    if this.params_.VERBOSE
        consoleinfo(['FETISSolver.FETISSolver: rigid body modes of substructures: ' num2str(cell2mat(this.Nrbms_))]);
    end

    consoleinfo(timestring(toc));
    consoleline('',true);

    end
    
    function[] = AssembleD(this)
      ni = 1;
      mi = 1;
      for s = 1:this.fetiman_.gNumSub()
        niend = ni+size(this.Ds_{s},1) - 1;
        miend = mi+size(this.Ds_{s},2) - 1;
        this.D_(ni:niend,mi:miend) = this.Ds_{s};
        ni = niend + 1;
        mi = miend + 1;
      end
    end
    
    function[] = AssembleB(this)
      li = 1;
      for s = 1:this.fetiman_.gNumSub()
        liend = li+size(this.fetiman_.Bs_{s},2) - 1;
        this.B_(:,li:liend) = this.fetiman_.Bs_{s};
        li = liend + 1;
      end
    end

    %% InitSolve
    function [lambda,lambdafull,lambdaN0,lambdaC0] = InitSolve(this)

      this.fetiman_.Resolve();
      %this.fetiman_.WriteSubs();
      %this.fetiman_.ApplyKinConditions(this.condlist_.kin);
      this.fetiman_.ApplyKinConditions();

      for iter=1:this.params_.NUMSUBSTRUCTS
        this.subsol_{iter}=[];
      end

      %call setup
      this.Setup();

      consoleline('INITIALIZE SOLVER', false);
      tic;



      % test TODO
% % %       if this.params_.CHECKS
% % %         consoleinfo(['Check: Conditionnumber of unpreconditioned operator: ' num2str( condest(this.F_) )]);
% % %         consoleinfo(['Check: Conditionnumber of preconditioned operator: ' num2str( condest(this.St_*this.F_) )]);
% % %       end

      this.calcF();
      %this.calcSt();
      this.calcP();

      %calculate the auxilary coarse grid
      AuxCoarseGrid(this);

      this.calcPc();
      
      % calculate the values for the CG algorithm needs to start with
      % it needs
      % - a start value for lambda, fulfilling the conditions the natural and
      % the auxiliary coarse grid impose
      % - the first residual that you obtain by using the start value for
      % lambda
      % - a first search direction that is obtained by projecting,
      % preconditioning and reprojecting the residual (remember that later in
      % the CG algorithm, the search directions also have to be
      % orthogonalized before they can be used)


      lambdaN0 = this.A_*this.G_*((this.G_'*this.A_*this.G_)\this.e_);
      lambdaC0 = sparse(this.Nlm_,1);
      if ~isempty(this.C_)
        lambdaC0 = this.C_*(   (this.C_'*this.F_*(this.C_)) \ (  this.C_'*(this.d_-this.F_*(lambdaN0))  )   );
      end
      lambda(:,1) = sparse(this.Nlm_,1);% TODO Resize of lambda in every iteration
      lambdafull(:,1) = lambdaN0 + lambdaC0;

      % test
      if this.params_.CHECKS
        consoleinfo(['Check: Error of substructure equilibrium: ' num2str(norm(this.G_'*(lambdaN0)-this.e_))]);
      end

      consoleinfo(timestring(toc));
      consoleline('',true);
    end
    
    
    function isconverged = CheckConvergence(this,resk,res0)

      switch this.params_.TERMINATIONTYPE
        case 'relative'
          isconverged=(abs(resk/res0)<this.params_.TERMINATIONVAL);
        case 'absolute'
          isconverged=abs(resk)<this.params_.TERMINATIONVAL;
        otherwise
          error(['unknown termination type: ',this.params_.TERMINATIONTYPE]);
      end
    end


    %% Solution
    function sol = Solution(this)

      consoleline('RECOVER DOMAIN SOLUTION',false);
      tic;
      % compute amplitudes of rigid body modes
      alpha = (this.G_'*this.G_) \ (  this.G_'*( this.d_ - this.F_*(this.lambda_) )  );
      % compute the solution per substructure
      sol = sparse(this.dis_.gNumDof(),1);%TODO this could also be full
      displ_error = zeros(this.Nlm_,1);

      for s = 1:this.fetiman_.gNumSub()
        %us = this.Ksp_{s}*(this.fetiman_.fs_{s}-this.fetiman_.Bs_{s}'*this.lambda_) - this.RsK_{s}*alpha(this.alphasIndices_{s});
        us = this.SubSolution(s,alpha,this.lambda_);
        sol(this.fetiman_.gSubs(s).gDofs(':')') = us;
        displ_error = displ_error + this.fetiman_.Bs_{s}*this.fetiman_.ts_{s}*us;
      end
      consoleinfo(timestring(toc));
      consoleline('',true);

    end


    % ReAssembleFullSystem
    function [Kfull, ffull] = ReAssembleFullSystem(this)
      % reassemble the full K matrix and the full f vector from the
      % information the FETI solver used
      % (for checking purposes)
      Kfull = sparse(this.dis_.gNumDof());
      ffull = sparse(this.dis_.gNumDof(),1);
      for s = 1:this.fetiman_.gNumSub()
        Kfull = Assemble(Kfull,this.fetiman_.Ks_{s},this.fetiman_.gSubs(s).gDofs(':')');
        ffull(this.fetiman_.gSubs(s).gDofs(':')',1) = ffull(this.fetiman_.gSubs(s).gDofs(':')',1) + this.fetiman_.fs_{s};
      end
    end


    % AccumulateSubSol
    function [] = AccumulateSubSol(this,iternum,lambda)
      alpha = (this.G_'*this.G_) \ (  this.G_'*( this.d_ - this.F_*(lambda) )  );

      for s = 1:this.fetiman_.gNumSub()
            this.subsol_{s}=[this.subsol_{s},this.SubSolution(s,alpha,lambda)];
      end

    end


    % WriteSubSolFullBased
    function [] = WriteSubSolFullBased(this,outputbuffer)

      if this.params_.WRITEITER%%TODO HACK

        for iter=this.fetiman_.gSubs(1:this.fetiman_.gNumSub())
          subid=iter.gID();
          cursubsolutions=this.subsol_{subid};
          for iterstep=1:size(cursubsolutions,2)
            curvec=zeros(this.dis_.gNumDof(),1);
            curvec(iter.alldofgids_)=cursubsolutions(:,iterstep);
            curvec=reshape(curvec,2,this.dis_.NumNode())';
            outputbuffer.WriteNodalVector(['displacement_SUBID',num2str(subid),'_ITER',num2str(iterstep)],curvec)
          end
        end

      end

    end


    %% SubSolution
    function us = SubSolution(this,s,alpha,lambda)
      % compute the solution per substructure
      %TODO check if ts is needed here
      us = this.Ksp_{s}*(this.fetiman_.fs_{s}-this.fetiman_.ts_{s}'*this.fetiman_.Bs_{s}'*lambda) - this.RsK_{s}*alpha(this.alphasIndices_{s});
    end


    %% calcF
    function y = calcF(this)
      %create the F matrix @scheucher 07/16

      if this.params_.ASSEMBLEDOPS
        this.F_ = this.F_;
        if this.params_.VERBOSE
          consoleinfo('Using assembled FI operator!');
        end
      else
          this.F_ = sparse(this.Nlm_);
          for s=this.fetiman_.numsubstructs_
          this.F_ = this.F_ + this.fetiman_.Bs_{s}*this.fetiman_.ts_{s}*( (this.fetiman_.Ks_{s}) \ (this.fetiman_.ts_{s}'*this.fetiman_.Bs_{s}') );
          end
      end
    end


    %% calcPC
    function y = calcPc(this)
      %create projector to auxilary coarse grid @scheucher 07/16

      if isempty(this.C_)
        this.Pc_ = speye(this.Nlm_);
        if this.params_.VERBOSE
          consoleinfo('Coarse Grid C_ IS empty!');
        end
        return;
      end

      if this.params_.VERBOSE
        consoleinfo('Coarse Grid C_ IS NOT empty!');
      end

% % %       if isempty(this.CCoarseOp_)
        this.CCoarseOp_ = this.C_'*this.F_*(this.C_);
% % %       else
% % %         error('temporary exit, please look what the code uses instead for CCoarseOp');
% % %       end
      this.Pc_ = speye(this.Nlm_);
      if ~isempty(this.C_)
       this.Pc_ = this.Pc_ - this.C_*(  this.CCoarseOp_ \ ( this.C_'*this.F_ )  );
      end

    end


    %% CalcP
    function y = calcP(this)
      %calculates the projector to natural body modes coarse grid
      %@scheucher 07/16
      
      %TODO temporary hack
      %this.A_=this.St_;

      if isempty(this.G_)
        this.P_ = speye(this.Nlm_);
        return;
      end

      if isempty(this.NCoarseOp_)
        this.NCoarseOp_ = this.G_'*this.A_*this.G_;
      end

      this.P_ = speye(this.Nlm_) - this.A_*(this.G_*(this.NCoarseOp_\(this.G_')));
    end


  end


end