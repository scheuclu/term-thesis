classdef AuxCoarseGrid < handle

  properties(Access=public)%private
    solver_

    Bbs_
    Ksii_
    Ksib_
    Ksbi_
    Ksbb_
    SKs_
    VqGen_
    DlambdaGen_
    GeneoModeSelection_ %selected Geneo modes of each substructure that build C_
    counter_=0;         %counts through the columns of C_
  end

  methods
    function this = AuxCoarseGrid(solver)
      %constructor of AuxCoarseGrid @wolf 06/16

      this.solver_  = solver;

      switch solver.params_.COARSEGRID
        case 'Geneo'
          display('Auxiliary Coarse Grid: GenEO');
          this.GenEO();
        case 'none'
          display('No Auxiliary Coarse Grid');
        otherwise
          display(['AuxCoarseGrid: Unknown Option "' this.solver_.params_.COARSEGRID_ '"']);
      end

    end

    function [] = GenEO(this)
      %creates the GIC for the solver @wolf 06/16

      for s=1:this.solver_.fetiman_.gNumSub()

        % compute (b)oundary DOF parts and (i)nternal DOF parts
        % (b)oundary = interface, NOT boundaries without neighbours
        this.Ksii_{s} = this.solver_.fetiman_.Ks_{s}(this.solver_.fetiman_.nonifacedofslids_{s},this.solver_.fetiman_.nonifacedofslids_{s});
        this.Ksib_{s} = this.solver_.fetiman_.Ks_{s}(this.solver_.fetiman_.nonifacedofslids_{s},this.solver_.fetiman_.ifacedofslids_{s});
        this.Ksbi_{s} = this.solver_.fetiman_.Ks_{s}(this.solver_.fetiman_.ifacedofslids_{s},this.solver_.fetiman_.nonifacedofslids_{s});
        this.Ksbb_{s} = this.solver_.fetiman_.Ks_{s}(this.solver_.fetiman_.ifacedofslids_{s},this.solver_.fetiman_.ifacedofslids_{s});

        % Schur Complement with K for GenEO:
        this.SKs_{s} = (this.Ksbb_{s} - this.Ksbi_{s}*(this.Ksii_{s}\this.Ksib_{s}));

        % solve generalized eigenvalue problem
        [this.VqGen_{s}, this.DlambdaGen_{s}] = eigs(this.SKs_{s},this.solver_.fetiman_.Bs_{s}'*this.solver_.St_*(this.solver_.fetiman_.Bs_{s}),12,'sm');
        % sort eigenvalues and corresp. eig.vec. in ascending order
        [this.VqGen_{s}, this.DlambdaGen_{s}] = sortem(this.VqGen_{s},this.DlambdaGen_{s});

        % delete rigid body modes (zero eigenvalues)
        this.VqGen_{s}(:,1:this.solver_.Nrbms_{s}) = [];
        this.DlambdaGen_{s}(:,1:this.solver_.Nrbms_{s}) = [];
        this.DlambdaGen_{s}(1:this.solver_.Nrbms_{s},:) = [];
      end
      
      if this.solver_.params_.GENEOTHRESHOLD == 0
        % Standard: 6 modes with smallest eigenvalues for each substructure
        for s = 1:this.solver_.fetiman_.gNumSub()
          this.GeneoModeSelection_{s} = 1:this.solver_.params_.NUMGENEOMODES;
        end
        display(['Selected ',this.solver_.params_.NUMGENEOMODES,' modes with smallest eigenvalue for each substructure']);
      else
        % Selects the Geneo modes with eigenvalues smaller than a threshold
        % add GENEOTHRESHOLD NUMERIC <<threshold>> in SOLVER section in .dat file 
        % @ wolf 07/16
        for s = 1:this.solver_.fetiman_.gNumSub()
          this.GeneoModeSelection_{s} = [];
          for Numlambda = 1:size(this.DlambdaGen_{s},1)
            if this.DlambdaGen_{s}(Numlambda,Numlambda) < this.solver_.params_.GENEOTHRESHOLD
              this.GeneoModeSelection_{s} = [ this.GeneoModeSelection_{s} Numlambda ];
            end
          end
        end 
        display(['Selected modes with eigenvalues smaller then threshold ' num2str(this.solver_.params_.GENEOTHRESHOLD)]); 
      end
      
      for s = 1:this.solver_.fetiman_.gNumSub()
        for GeneoMode = this.GeneoModeSelection_{s}
          this.counter_=this.counter_+1;
          %this.solver_.GIC_(:,this.counter_) = this.solver_.APPL_PN(this.solver_.APPL_FIpre(this.Bs_{s}*this.VqGen_{s}(:,GeneoMode)));
          this.solver_.C_(:,this.counter_) = this.solver_.P_*(this.solver_.St_*(this.solver_.fetiman_.Bs_{s}*this.VqGen_{s}(:,GeneoMode)));
        end
      end

    end
  end
end