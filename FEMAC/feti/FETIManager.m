classdef FETIManager < handle
  
  properties(Access=public)
    dis_           @Discretization   %Discretization object
    substructs_    @FETISubStructure %vector of FETISubstructures
    condlist_      @struct           %list of kinematic conditions
    nodeconnect_
    numsubstructs_ @double           %total number of substructures
    ifacenodegids_ @double=[]        %global IDs of all nodes on FETI interfaces
    numlag_        @double           %total number of Lagrange multipliers
    
    outbuffer_@OutputBuffer
    pseudodis_@PseudoDiscretization

  end
  
  properties(Access=public)
    Ks_@cell                    %substructure stiffness matrices
    Bs_@cell                    %substructure connectivity matrices
    ts_@cell                    %trace operators
    fs_@cell                    %substructure force vectors
    ifacedofslids_     @cell    %substructure local IDs of interface dofs
    nonifacedofslids_  @cell    %substructure local IDs of non-interface dofs
    numglobnodeconnect_@double  %vector containig the number of feti connections for every node
    numglobdofconnnect_@double  %vector containig the number of feti connections for every dof
    
    ifacedofgids_     @cell    %substructure local IDs of interface dofs
    nonifacedofgids_  @cell    %substructure local IDs of non-interface dofs
  end
  
  methods(Access=public)
    
    %% FETIManager
    function this = FETIManager(dis,outbuffer,numsubstructs,condlist)
    %constructor for FETIManager
    %takes an Disretization object an input  @scheucher 05/16
      
      this.dis_ = dis;
      this.condlist_=condlist;
      this.numsubstructs_=numsubstructs;
      this.outbuffer_=outbuffer;
    end
    
    %% getter gNumSub
    function result = gNumSub(this)
      result=this.numsubstructs_;
    end
    
    %% getter gNumLag
    function result = gNumLag(this)
      result=this.numlag_;
    end

    %% getter gSubs
    function result = gSubs(this,ids)
      result=this.substructs_(ids);
    end
    
    %% working CreateSubDis
    function [] = CreateSubDis(this)
      %creates PseudoDiscretizations for all substructures
      %involves copying and re-labelling of existing nodes and elements
      %@scheucher 07/16
      
      %loop over all substructures
      for itersub=this.substructs_
        
        %create pseudo discretization
        curdis=PseudoDiscretization(2);
        
        %copy, re-label and add substructure nodes
        for i=1:length(itersub.allnodegids_)%TODO clean this loop
          newnode=copy(this.dis_.gNode(itersub.allnodegids_(i)));
          newnode.sID(i);
          olddofs=newnode.gDofs();
          newdofs=itersub.Gid2slid_Dof(olddofs);
          newnode.sDofs(newdofs);
          curdis.AddNode(newnode);
        end
        
        %copy, re-label and add substructure elements
        for i = 1:length(itersub.allelegids_)%TODO celan this loop
          newele=copy(this.dis_.gElement('stiff',itersub.allelegids_(i)));
          newele.sID(i);
          nodegids=newele.gNodeIDs();
          itersub.Gid2slid_Node(nodegids);
          newnodes=curdis.gNodes( itersub.Gid2slid_Node(nodegids));
          newele.nodes_=newnodes;
          curdis.AddElement('stiff',newele);
        end
        
        this.pseudodis_(itersub.gID())=curdis;  
      end
      
      
    end
 
    %% working Resolve
    function [] = Resolve(this)
    %creates all relevant information ablout substructures and their
    %connectivity  @scheucher 05/16
    
      consoleline('RESOLVE FETI MANAGER',false);
      tic;
    
      this.CreateSubStructs();    
      this.ResolveEle();
       
      for iter = 1:length(this.substructs_)
        this.fs_{iter}=sparse(this.substructs_(iter).gNumDof(),1);
      end
      
      this.EvaluateSubStructs();
      this.ResolveINodes();
      this.ResolveIDofs();
          
      for iter=this.substructs_
        this.ifacenodegids_=[ this.ifacenodegids_, abs(cell2mat(iter.gIfaceNodeGIDs(':')' ) ) ];
      end
      this.ifacenodegids_=unique(this.ifacenodegids_);
      
      this.CreateBMats();
      this.CreateTraceOps();
      this.CreateDofVecs(); %TODO if possible this should be removed in the near future
      this.DetermineNumGlobConnect();
      this.WritePartitionInfo();
      
      consoleinfo(timestring(toc));
      consoleline('',true);
    end
    
    %% working AssembleB    
    function Bglob = AssembleB(this)
    %assembles all B-matrices to a global matrix.
    %result should be all zero (used for checks)  @scheucher 05/17
    
      Bglob=sparse(this.gNumLag(),this.dis_.NumDof());
      for iter = 1:this.numsubstructs_
        Bglob(:,this.substructs_(iter).gDofs(':')')=Bglob(:,this.substructs_(iter).gDofs(':')')+this.Bs_{iter};
      end
    end    
    
    %% working Visualize
    function [] = Visualize(this,f,plotparams)
    %prints an exploded form of the partitioned mesh  @scheucher 05/16
    
      figure(f);
      grid off
      axis off
      axis equal
      hold on
      cmap=colormap('prism');
      
      plotter=MatlabPlot(this.dis_);
      plotter.Reset();
      plotter.SetParams(plotparams);
      
      for iter1=1:this.numsubstructs_
        this.substructs_(iter1).CalcCenter();
      end
      
      for iter1=1:this.numsubstructs_
        elelist=this.dis_.gElements('stiff',this.substructs_(iter1).gEleGIDs(':')'   );
        plotter.Set('SURFCOLOR', cmap(iter1,:));
        vec=this.substructs_(iter1).gCenter()-this.dis_.Center();
        this.substructs_(iter1).Move(vec(1),vec(2),vec(3));
        plotter.PlotPart(f,elelist,{},{});
        this.substructs_(iter1).Move(-vec(1),-vec(2),-vec(3));  
      end
      title('Partitioning');
      
    end
    
    %% working WritePartitionInfo
    function WritePartitionInfo(this)
      %writes the substructure ID and the substructure distance from
      %discretization center as element data to output  @scheucher 06/16
      
      idvec=zeros(this.dis_.gNumEle('stiff'),1);
      centerdiff=zeros(this.dis_.gNumEle('stiff'),3);
      for iter=1:this.gNumSub()
        idvec(this.substructs_(iter).gEleGIDs(':'))=iter;
        
        this.substructs_(iter).CalcCenter();
        subcenter=this.substructs_(iter).gCenter();
        discenter=this.dis_.Center();

        centerdiff(this.substructs_(iter).gEleGIDs(':'),:)=repmat(rowvec(subcenter)-rowvec(discenter),length(this.substructs_(iter).gEleGIDs(':')),1);
      end
      
      this.outbuffer_.WriteElementScalar('SUB_ID',idvec);
      this.outbuffer_.WriteElementVector('SubCenter_Diff',centerdiff);
    end
    
    %% working VisualizeLag
    function [] = VisualizeLag(this,f)
    %prints the lagrange multipliers to figure f  @scheucher 06/16
    
      figure(f);
      grid off
      axis off
      axis equal
      hold on
      cmap=colormap('prism');
      
      lagid=1;
      for iter1=1:this.numsubstructs_
        vec1=this.substructs_(iter1).gCenter()-this.dis_.Center();
        for iter2=iter1+1:this.numsubstructs_
          vec2=this.substructs_(iter2).gCenter()-this.dis_.Center();
          
          ccinodes=rowvec(cell2mat(this.substructs_(iter1).gIfaceNodeGIDs(iter2)) );
          if isempty(ccinodes)
            continue
          end
             
          for iter3=ccinodes
            plot3([this.dis_.gNodes(iter3).X()+vec1(1)  this.dis_.gNodes(iter3).X()+vec2(1)],...
                  [this.dis_.gNodes(iter3).Y()+vec1(2)  this.dis_.gNodes(iter3).Y()+vec2(2)],...
                  [this.dis_.gNodes(iter3).Z()+vec1(3), this.dis_.gNodes(iter3).Z()+vec2(3)],'-k');
            text( 0.5*[this.dis_.gNodes(iter3).X()+vec1(1)+this.dis_.gNodes(iter3).X()+vec2(1)],...
                  0.5*[this.dis_.gNodes(iter3).Y()+vec1(2)+this.dis_.gNodes(iter3).Y()+vec2(2)],...
                  0.5*[this.dis_.gNodes(iter3).Z()+vec1(3)+this.dis_.gNodes(iter3).Z()+vec2(3) ],[num2str(lagid),',',num2str(lagid+1)],...
                  'BackgroundColor',[1 1 1],'EdgeColor',[0 0 0],'FontUnits','centimeters','FontSize',0.25,'Margin',1.5);
            lagid=lagid+2;
          end
        end
      end
      title('Partitioning');
      
    end
    
    %% working ApplyKinConditions
    function []= ApplyKinConditions(this)
      %apply kinmatic conditions on all substructures @scheucher 06/16
      
      consoleline('APPLY KINEMATIC CONDITIONS ON SUBSTRUCTURES',false);
      tic;
      dirichsubs=zeros(1,this.numsubstructs_);
      neumannsubs=zeros(1,this.numsubstructs_);
      for subid=1:this.numsubstructs_
        [dirichsubs(subid),neumannsubs(subid)]=this.ApplyKinCondSub(subid);
      end
      consoleinfo(['Dirichlet conditions detected on substructures: ',num2str(find(dirichsubs))]);
      consoleinfo(['Neumann   conditions detected on substructures: ',num2str(find(neumannsubs))]);
      consoleinfo(timestring(toc));
      consoleline('',true);
    end
    
    %% working ApplyKinCondSub
    function [founddirich,foundneumann] = ApplyKinCondSub(this,subid)
      %apply kinmatic conditions on substructure with ID subid @scheucher 06/16
      founddirich=0;
      foundneumann=0;
      
      cursub=this.substructs_(subid);
      
      
            %% Neumann Conditions
      
      if(1:this.dis_.gNumEle('neumann')~=0)
        neumannelelist=this.dis_.gElements('neumann',1:this.dis_.gNumEle('neumann'));

        dRHS=sparse(cursub.gNumDof(),1);
        for inele=1:length(neumannelelist) %loop over all neumann elements
          curnele=neumannelelist{inele};   %get the next neumann element
          curtags=curnele.gTags();         %get the tags of the current neumann element

          %treat point neumann conditions seperately
          if length(curtags)<4

            if ~isa(curnele,'CondElePoint1')
              error('exeption only supposed for CondElePoint1 elements');
            end

            %-----resolve the neumann condition
            locdof=cursub.Gid2slid_Dof(curnele.gDofIDs());

            if isempty(find(locdof,1))
              continue
            end
            foundneumann=1;

            dRHS=AssembleVec(dRHS,curnele.Evaluate(),locdof);            %Evaluate and assemble neumann element

            continue

          end


          if curtags(4)==subid             %check whether condition applies to this element
            foundneumann=1;
            %locdof=find(ismember(cursub.gDofs(':')',curnele.gDofIDs())); %map neumann element dofs to substructure local dofs
            locdof=cursub.Gid2slid_Dof(curnele.gDofIDs());
            dRHS=AssembleVec(dRHS,curnele.Evaluate(),locdof);            %Evaluate and assemble neumann element
          end
        end
        this.fs_{subid}=this.fs_{subid}+dRHS;
      end
      
      
      
      
      

      %% Dirichlet Conditions       
      % this gets all dirichlet elements
      dirichelelist=this.dis_.gElements('dirich',1:this.dis_.gNumEle('dirich'));

      for idele=1:length(dirichelelist)
        curdele=dirichelelist{idele};

        curtags=curdele.gTags();

        % point elements require an exeption here, since they have less
        % tahn 4 tas
        if length(curtags)<4
          
          if ~isa(curdele,'CondElePoint1')
            error('exeption only supposed for CondElePoint1 elements');
          end
          founddirich=1;
          
          
          nodeids = curdele.gNodeIDs();
          %%%locdof=find(ismember(cursub.gDofs(':')',curdele.gDofIDs()));
          locdof=cursub.Gid2slid_Dof(curdele.gDofIDs());

          if isempty(find(locdof,1))
            continue
          end
          

          newvals = curdele.gVal();
          newvals = repmat(newvals(logical(curdele.gOnOff()))',length(nodeids),1);
          newvals=sparse(newvals);

          %add dirichlet column to right hand side
          for index = 1:length(locdof)
              this.fs_{subid} = this.fs_{subid} - this.Ks_{subid}(:,locdof(index)).*newvals(index);
          end

          %write dirichlet value to right hand side
          this.fs_{subid}(locdof,1) = newvals;

          %clear dircihlet row and column on left hand side
          this.Ks_{subid}(locdof,:)=0;
          this.Ks_{subid}(:,locdof)=0;
          for iter=locdof
              this.Ks_{subid}(iter,iter)=1.0;
          end

          continue %continue is important, so that the same element is not treated by the routines below again

        end
        
        
        %all other dirichlet conditions(all but Point Conditions)
        if curtags(4)==subid
            founddirich=1;
            % returns the indices (=substructure-local dof numbers) of
            % the element dofs in the dof list of the substructure
            % locdofs: substructure-local dof numbers of element dofs
            nodeids = curdele.gNodeIDs();
            dofids=this.dis_.gDofIDs(nodeids,curdele.gOnOff());
            if isempty(dofids)
                continue;
            end
            locdof=find(ismember(cursub.gDofs(':')',dofids));
            
            newvals = curdele.gVal();
            newvals = repmat(newvals(logical(curdele.gOnOff()))',length(nodeids),1);
            
            for index = 1:length(locdof)
                this.fs_{subid} = this.fs_{subid} - this.Ks_{subid}(:,locdof(index)).*newvals(index);
            end
            this.fs_{subid}(locdof,1) = newvals;
            
            this.Ks_{subid}(locdof,:)=0;
            this.Ks_{subid}(:,locdof)=0;
            for iter=locdof
              this.Ks_{subid}(iter,iter)=1.0;
            end

        end
      end
    
    end %end apply kin cond sub
    
    
    %% working Check
    function [] = Check(this)
    %check fetiman variables for plausibility
      
      %check sum of Bs_ matrices
      if ~isempty(find(AssembleB(this),1))
        error('Bmatrices do not some up to zero');
      end
      
      %check wheter Bs_ and fs fit together on subdomains
      for iter = 1:this.numsubstructs_
        
        if isempty(find(this.Ks_{iter},1))
          error(['Ks_ matrix of substructure ',num2str(iter),' should not be empty']);
        end
        
        
        if isempty(find(this.Bs_{iter},1))
          error(['Bs_ matrix of substructure ',num2str(iter),' should not be empty']);
        end
        

        if size(this.Ks_{iter},2)~=size(this.fs_{iter},1)
          error(['length of fs_ verctor and number of columns of Ks_ matrix do not match on substructure ', num2str(iter)])
        end
        
      end
      
      if isempty(this.ifacedofslids_)
        error('ifacedofslids_ should not be empty');
      end
      
      if isempty(this.nonifacedofslids__)
        error('nonifacedofslids__ should not be empty');
      end
      
      
      if isempty(this.numglobnodeconnect_)
        error('numglobnodeconnect_ should not be empty');
      end
      
      if isempty(this.numglobdofconnnect_)
        error('numglobdofconnnect_ should not be empty');
      end
      
    end
   
     
  end%end methods(Access=public)
  
  methods(Access=private)
    
    %% working CreateSubStructs
    function [] = CreateSubStructs(this)
    % create substructures @scheucher 07/16
      for iter=1:this.numsubstructs_
        this.substructs_(iter)=FETISubStructure(iter,this.numsubstructs_,this.dis_);
      end
      consoleinfo([num2str(this.numsubstructs_),' subtructures created']);
    end
    
    
    %% working ResolveINodes
    function [] = ResolveINodes(this)
      %associate interface nodes with substructures @scheucher 07/16
    
      for subid1=1:this.numsubstructs_
        for subid2=subid1+1:this.numsubstructs_ %% TODO check if this is really sufficent
          
          this.substructs_(subid1).addINodeIDs(subid2,intersect( this.substructs_(subid1).gNodeGIDs(':')',this.substructs_(subid2).gNodeGIDs(':')'  ) );
          this.substructs_(subid2).addINodeIDs(subid1,-intersect( this.substructs_(subid1).gNodeGIDs(':')',this.substructs_(subid2).gNodeGIDs(':')'  ) );
        end
      end
    end
    
    
    %% working ResolveIDofs
    function [] = ResolveIDofs(this)
    % associate interface dofs with substructures
      
      for iter=this.substructs_
        iter.ResolveIDofs();
      end
    end   
    
    
    %% working ResolveEle
    function [] = ResolveEle(this)
      %associate elements with substructures
    
      for iter=1:this.dis_.gNumEle('stiff')
        tags=this.dis_.gElement('stiff',iter).gTags();
        curelesubid=tags(4);
        if curelesubid>this.numsubstructs_
          error(['current subid exeeds the specified number of total substructures: ',num2str(curelesubid),'>',num2str(this.numsubstructs_)]);
        else
          this.substructs_(curelesubid).addEleGIDs(iter);
        end
      end
      
      for iter = this.substructs_
        iter.Resolve();
      end
      
      consoleinfo('substructures resolved');
    end
    
    
    %% working EvaluateSubStructs
    function [] = EvaluateSubStructs(this)
     %evaluate stiffnes matrices of all substructures  @scheucher 05/15
     
      for subid=1:this.numsubstructs_

        this.Ks_{subid}=sparse(this.substructs_(subid).gNumDof(),this.substructs_(subid).gNumDof());
        eleids=this.substructs_(subid).gEleGIDs(':')';

        % Calculate stiffnes matrices
        for curid=rowvec(eleids)
          curele=this.dis_.gElement('stiff',curid);
          
          %[~,map]=find(ismember(this.substructs_(subid).gDofs(),curele.gDofIDs()));
          map = zeros(1,6);
          eleDofIDs = curele.gDofIDs();
          for i=1:length(eleDofIDs)
              [~,locindex]=find(ismember(this.substructs_(subid).gDofs(':')',eleDofIDs(i)));
              map(i) = locindex;
          end
          
          this.Ks_{subid}=AssembleMat(this.Ks_{subid},curele.Evaluate(),map);
        end

      end
      
      consoleinfo('substructures evaluated');
      
    end
    
    
    %% working CreateBMats
    function [] = CreateBMats(this)
    % create B-matrices for all substructures
    
      numlag=0;
      for subid=1:this.numsubstructs_
        %numlag=numlag+length(cell2mat(this.substructs_(subid).idofids_(subid+1:end)));
        numlag=numlag+length(cell2mat(this.substructs_(subid).gIfaceDofGIDs(subid+1:this.numsubstructs_) ));
        
      end
      this.numlag_=numlag;
      
      % creating Bmatrices
      for subid=1:this.numsubstructs_
        this.Bs_{subid}=sparse(numlag,this.substructs_(subid).gNumIDof() );
      end
      
      
      lagid=1;
      
      % loop over all matrices
      for subid=1:this.numsubstructs_

        %get the interface dofs of the current substructure
        subidofs=this.substructs_(subid).gIfaceDofGIDs(':')';

        %get all dofids of the current substructure
        %%%dofids=this.substructs_(subid).dofids_; %dofids of the current substructure
        
        %loop over all substructures with a higher ID than the current
        for i_counter= subid+1:length(subidofs)
          
          %get all dofs of substructure subid that are shared with
          %substructure i_counter
          % intersect_dofs_global
          intersect_dofs=subidofs{i_counter};%subidofs111

          [~,dofmapglob2loc]=ismember( abs(intersect_dofs),this.substructs_(subid).gDofs(':')'  );
          dofmap=unique(abs(cell2mat(this.substructs_(subid).ifacedofgids_)));
          dofmap_counter=unique(abs(cell2mat(this.substructs_(i_counter).ifacedofgids_)));



          for iter=1:length(intersect_dofs)
            this.Bs_{subid}(lagid,find(dofmap==abs(intersect_dofs(iter))))=sign(iter);%c4 acts as glob2loc
            this.Bs_{i_counter}(lagid,find(dofmap_counter==abs(intersect_dofs(iter))) )=-1;%set the neagtive counterpart
            lagid=lagid+1;
          end
  
        end
        
        this.substructs_(subid).lagmultgids_=find(sum(this.Bs_{subid}'));

      end
      
      consoleinfo('connectivity matrices created');

    end
    
    
    function [] = CreateTraceOps(this)
      for subid=1:this.numsubstructs_
        allifacedofgids=unique(abs(cell2mat(this.substructs_(subid).ifacedofgids_)));
        cols=this.substructs_(subid).Gid2slid_Dof(unique(abs(cell2mat(this.substructs_(subid).ifacedofgids_))));
        rows=1:length(allifacedofgids);
        vals=ones(1,length(allifacedofgids));
        this.ts_{subid}=sparse(rows,cols,vals,length(allifacedofgids),length(this.substructs_(subid).alldofgids_),length(allifacedofgids));
      end
    end
    
    
    %% working CreateDofVecs
    function [] = CreateDofVecs(this)
      %create interface and non-interface dof vectors  @scheucher 05/15
      
      for iter=1:this.numsubstructs_
        
        alldofs=this.substructs_(iter).gDofs(':')';
        bdofs  =unique(abs(cell2mat(this.substructs_(iter).gIfaceDofGIDs(':')' )  ));
        loc    =find(ones(1,length(alldofs))-ismember(alldofs,bdofs));

        idofs=alldofs(loc);
        this.ifacedofgids_{iter}=bdofs;   
        this.nonifacedofgids_{iter}=idofs;
        
        this.ifacedofslids_{iter}=find(ismember(alldofs,bdofs));   
        this.nonifacedofslids_{iter}=find(ismember(alldofs,idofs));

      end
      
    end
    
    
    %% working DetermineNumGlobConnect
    function [] = DetermineNumGlobConnect(this)
      %determines for each node(dof), to how many other nodes(dofs) it
      %is connected via lagrange multipliers.
      %the result is stopred in numglobnodeconnect_ and numglobdofconnect_
      %@scheucher 05/16
    
      % determine numglobnodeconnect_
      tempN=zeros(1,this.dis_.gNumNode());
      tempD=zeros(1,this.dis_.gNumDof() );
      
      %loop over all substructures
      for iter=1:length(this.substructs_)
        cursub=this.substructs_(iter);
        
        BSubN=sparse(this.numsubstructs_,this.dis_.gNumNode());
        BsubD=sparse(this.numsubstructs_,this.dis_.gNumDof());

        %loop over the interface nodes of all substructures with higher IDs
        %for iter2=iter+1:length(cursub.gINodeIDs(':')')
        for iter2=iter+1:this.numsubstructs_
          BSubN(iter2,cell2mat(cursub.gIfaceNodeGIDs(iter2)))=1;
          BsubD(iter2,cell2mat(cursub.gIfaceDofGIDs(   iter2)))=1;
        end
        
        %loop over all substructures with lower IDs than the current
        for iter2=1:iter-1
          BSubN(iter2,abs(cell2mat(cursub.gIfaceNodeGIDs(iter2))))=-1;
          BsubD(iter2,abs(cell2mat(cursub.gIfaceDofGIDs(   iter2))))=-1;
        end

        %some magic, cannot explain why that works
        tempN=tempN+diag(0.5*transpose(BSubN)*BSubN)';
        tempD=tempD+diag(0.5*transpose(BsubD)*BsubD)';
      end
      
      this.numglobnodeconnect_=tempN;
      this.numglobdofconnnect_=tempD;

     end
    
  end%end private methods
  
end

    