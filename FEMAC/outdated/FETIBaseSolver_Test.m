classdef FETIBaseSolver_Test < handle
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
    St_      @double %preconditioner
    d_       @double %interface forces
    e_       @double %interface constraint error
    lambda_  @double %lagrange multipliers

    alphasIndices_   %indices of rigid body modes for all substructures
    Nrbm_    @double %total number of rigid-body modes
    Nrbms_   @cell   %number of rigid body modes for all substructures

    params_=struct( 'NUMSUBSTRUCTS' ,0,...
                    'ASSEMBLEDOPS'  ,false,...
                    'VERBOSE'       ,false,...
                    'REASSEMBLESYS' ,false,...
                    'CHECKS'        ,false,...
                    'COARSEGRID'    ,'none',...
                    'WRITEITER'     ,false)

    %outbuffer_@OutputBuffer
    subsol_={}; %solutions for all substructures

  end

  methods

    %% ctor FETIBaseSolver_Test
    function this = FETIBaseSolver_Test(dis,outbuffer,params,condlist)% {{{ctor
      %constructor for FETI2Solver @leistner 05/16
      validateattributes(dis,{'Discretization'},{'nonempty'},'FETI2Solver','dis',1);
      validateattributes(params,{'struct'},{'nonempty'},'FETI2Solver','params',2);
      validateattributes(condlist,{'struct'},{'nonempty'},'FETI2Solver','condlist',3);


      this.fetiman_ = FETIManager(dis,outbuffer,params.NUMSUBSTRUCTS,condlist);
      this.dis_     = dis;
      this.condlist_= condlist;
      this.Settings(params);

    end% }}}end ctor


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

    consoleline('START Base SETUP',false);
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
    this.G_ = [];
    this.d_ = zeros(this.Nlm_,1);
    this.e_ = [];
    this.A_ = eye(this.Nlm_); % unused so far
    this.St_=sparse(this.Nlm_);

    if this.params_.ASSEMBLEDOPS
        this.F_ = zeros(this.Nlm_);
    end

    % setup FETI variables
    for s = 1:this.fetiman_.gNumSub()
        this.RsK_{s} = null(full(this.fetiman_.Ks_{s}));
        this.Ksp_{s} = pinv(full(this.fetiman_.Ks_{s}));
        this.Nrbms_{s} = size(this.RsK_{s},2);

        this.alphasIndices_{s} = this.Nrbm_+1 : (this.Nrbm_ + this.Nrbms_{s});
        this.Nrbm_ = this.Nrbm_ + this.Nrbms_{s};

        this.G_ = [this.G_, this.fetiman_.Bs_{s}*this.RsK_{s}];
        this.d_ = this.d_ + this.fetiman_.Bs_{s}*this.Ksp_{s}*this.fetiman_.fs_{s};
        this.e_ = [this.e_; this.RsK_{s}'*this.fetiman_.fs_{s}];

        if this.params_.ASSEMBLEDOPS
            this.F_ = this.F_ + this.fetiman_.Bs_{s}*this.Ksp_{s}*this.fetiman_.Bs_{s}';
        end
    end

    if this.params_.VERBOSE
        consoleinfo(['FETISSolver.FETISSolver: rigid body modes of substructures: ' num2str(cell2mat(this.Nrbms_))]);
    end

    consoleinfo(timestring(toc));
    consoleline('',true);

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
      AuxCoarseGrid(this.fetiman_,this,this.params_.COARSEGRID);

      tol = 1e-5;
      k = 1;

      % test
      if this.params_.CHECKS
        consoleinfo(['Check: Conditionnumber of unpreconditioned operator: ' num2str( rcond(this.F_) )]);
        consoleinfo(['Check: Conditionnumber of preconditioned operator: ' num2str( rcond(this.St_*this.F_) )]);
      end

      this.calcF();
      this.calcSt();
      this.calcP();
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
      lambdaC0 = zeros(this.Nlm_,1);
      if ~isempty(this.C_)
        lambdaC0 = this.C_*(   (this.C_'*this.F_*(this.C_)) \ (  this.C_'*(this.d_-this.F_*(lambdaN0))  )   );
      end
      lambda(:,1) = zeros(this.Nlm_,1);% TODO Resize of lambda in every iteration
      lambdafull(:,1) = lambdaN0 + lambdaC0;

      % test
      if this.params_.CHECKS
        consoleinfo(['Check: Error of substructure equilibrium: ' num2str(norm(this.G_'*(lambdaN0)-this.e_))]);
      end

      consoleinfo(timestring(toc));
      consoleline('',true);

    end


    %% Solution
    function sol = Solution(this)

      consoleline('RECOVER DOMAIN SOLUTION',false);
      tic;
      % compute amplitudes of rigid body modes
      alpha = (this.G_'*this.G_) \ (  this.G_'*( this.d_ - this.F_*(this.lambda_) )  );
      % compute the solution per substructure
      sol = zeros(this.dis_.gNumDof(),1);
      displ_error = zeros(this.Nlm_,1);

      for s = 1:this.fetiman_.gNumSub()
        %us = this.Ksp_{s}*(this.fetiman_.fs_{s}-this.fetiman_.Bs_{s}'*this.lambda_) - this.RsK_{s}*alpha(this.alphasIndices_{s});
        us = this.SubSolution(s,alpha,this.lambda_);
        sol(this.fetiman_.gSubs(s).gDofs(':')') = us;
        displ_error = displ_error + this.fetiman_.Bs_{s}*us;
      end
      consoleinfo(timestring(toc));
      consoleline('',true);

    end


    % ReAssembleFullSystem
    function [Kfull, ffull] = ReAssembleFullSystem(this)
      % reassemble the full K matrix and the full f vector from the
      % information the FETI solver used
      % (for checking purposes)
      Kfull = zeros(this.dis_.gNumDof());
      ffull = zeros(this.dis_.gNumDof(),1);
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


    %% WriteSubSolSubBased
    function [outputbuffers] = WriteSubSolSubBased(this,outputbuffers)
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

         subpostproc=PostProcessor(this.solver_.fetiman_.pseudodis_(i));
         subpostproc.SetParams(this.params_.POSTPROC);
         subsol=this.solver_.subsol_{i};
         subpostproc.Process(subsol(:,end));
       end

      end

    end


    %% WriteSubSolSubBased_Displs
    function [outputbuffers] = WriteSubSolSubBased_Displs(this,outputbuffers)

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

        for i=1:this.fetiman_.numsubstructs_
           subpostproc=PostProcessor(this.fetiman_.pseudodis_(i));
           subpostproc.SetParams(struct(params));
           subsol=this.subsol_{i};
           subpostproc.Process(subsol(:,end));
        end

    end


    %% SubSolution
    function us = SubSolution(this,s,alpha,lambda)
      % compute the solution per substructure
      us = this.Ksp_{s}*(this.fetiman_.fs_{s}-this.fetiman_.Bs_{s}'*lambda) - this.RsK_{s}*alpha(this.alphasIndices_{s});
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
          this.F_ = this.F_ + this.fetiman_.Bs_{s}*( (this.fetiman_.Ks_{s}) \ (this.fetiman_.Bs_{s}') );
          end
      end
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

      if isempty(this.CCoarseOp_)
        this.CCoarseOp_ = this.C_'*this.F_*(this.C_);
      else
        error('temporary exit, please look what the code uses instead for CCoarseOp');
      end

      this.Pc_ = speye(this.Nlm_) - this.C_*(  this.CCoarseOp_ \ ( this.C_'*this.F_ )  );

    end


    %% CalcP
    function y = calcP(this)
      %calculates the projector to natural body modes coarse grid
      %@scheucher 07/16

      if isempty(this.G_)
        y = x;
        return;
      end

      if isempty(this.NCoarseOp_)
        this.NCoarseOp_ = this.G_'*this.A_*this.G_;
      end

      this.P_ = speye(this.Nlm_) - this.A_*(this.G_*(this.NCoarseOp_\(this.G_')));
    end
    
    
  end
  
  
end

