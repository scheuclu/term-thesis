classdef Discretization < matlab.mixin.Copyable %handle

  properties(Access=public)%protected
    dim_
    nodes_@NodeBase    %array of objects with type NodeBase
    
    stiffele_          ={} %cell object that contains all stiffness elements
    neumannele_ ={} %cell object that contains all neumann elements
    dirichele_       ={} %cell object that contains all dirichlet elements
    
    numdof_            %total dof number
    dirichcond_        %matrix of size <numdirichdof>x2;  [...; dofindex, dirichvalue; ...]
    neumanncond_       %matrix of size <numneumanndof>x2; [... ;dofindex,neumannvalue; ...]
    
    conditions_= {}
    
    outbuffer_@OutputBuffer%TODO this should be remove from here in the long run
    
  end

  methods(Access=public)

    function this = Discretization(dim)% {{{ctor
      %constructor for class Discretization
      %takes problem dimension as argument
      validateattributes(dim,{'numeric'},{'scalar','>=',2,'<=',3},'ctor Discretization','dim',1);

      this.dim_=dim;
      this.numdof_=0;
    end% }}}
    
    function this = InitNodes(this,numnode)
      this.nodes_(numnode)=NodeBase();
      
    end
    
    function this = IncNumDof(this,numinc)
      this.numdof_=this.numdof_+numinc;
    end
    
    function [] = sOuputBuffer(this,buffer)
      this.outbuffer_=buffer;
    end

%     function Kt = Ktang(this,disp)
% 
%      Kt=sparse(this.numdof_,this.numdof_);
% 
%       %loop over all elements, create element matrices and directly asseble them
%       this.ApplyDisp(disp);
%       for iterele=1:length(this.stiffele_)
%         dofs=this.gElement('stiff',iterele).gDofIDs();
%         Kt=Assemble(Kt, this.gElement('stiff',iterele).Evaluate() ,dofs);
%       end
%        this.ApplyDisp(-disp);
%        
%     end

    function [] = AddNode(this,newnode)% {{{add node
      %adds an object of type NodeBase to the Discretization
      %newnode: type<NodeBase>
      validateattributes(newnode,{'NodeBase'},{'scalar'},'AddNode','newnode',1);

      this.nodes_(end+1)=newnode;
      this.numdof_=this.numdof_+newnode.Dim();
    end% }}}


    function [] = AddElement(this,listtype,newelement)% {{{add element
      %comment to be done      
      validatestring(listtype,validelelists(),'AddElement','listtype',1);
      validateattributes(newelement,valideletypes(listtype),{'scalar'},'AddNode','newelement',2);

      switch listtype
        case 'stiff'
          this.stiffele_{end+1}=newelement;
        case 'neumann'
          this.neumannele_{end+1}=newelement;
        case 'dirich'
          this.dirichele_{end+1}=newelement;
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end% }}}


    function result = gNodes(this,ids)% {{{ gnodes
      %returns handles to the nodes specified with global IDs ids
      validateattributes(ids,{'numeric'},{'nonempty','row','positive'},'gNodes','ids',1);
      %TODO doesnt work with ':'
      
      result=this.nodes_(ids);
    end%}}} end gNodes
    

    function result = gElement(this,listtype,id)% {{{gElements
      %comment to be done
      validatestring(listtype,validelelists(),'AddElement','listtype',1);
      
      switch listtype
        case 'stiff'
          result=this.stiffele_{id};
        case 'neumann'
          result=this.neumannele_{id};
        case 'dirich'
          result=this.dirichele_{id};
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end%}}} end gElements
    
    function result = gNode(this,gid)
      result=this.nodes_(gid);
    end
    
    
    function result = gEleList(this,listtype)% {{{gElements
      %returns array of elements specified by id
      validatestring(listtype,validelelists(),'gEleList','listtype',1);

      switch listtype
        case 'stiff'
          result=this.stiffele_;
        case 'neumann'
          result=this.neumannele_;
        case 'dirich'
          result=this.dirichele_;
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end%}}} end gElements
    
    
    function result = gElements(this,listtype,id)% {{{gElements
      %returns array of elements specified by id
      validatestring(listtype,validelelists(),'gElements','listtype',2);
      validateattributes(id,{'numeric'},{'nonempty','row'},'gElements','id',2);

      switch listtype
        case 'stiff'
          result=this.stiffele_(id);
        case 'neumann'
          result=this.neumannele_(id);
        case 'dirich'
          result=this.dirichele_(id);
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end%}}} end gElements


    function result = gDofIDs(this,nodeids,onoff)% {{{ gDofIds
      %returns array of dofindices that belong to nodes with IDs nodeids
      validateattributes(nodeids,{'numeric'},{'nonempty','row'},'gDofIDs','nodeids',1);
      validateattributes(onoff,{'numeric'},{'nonempty','nonnegative','integer'},'gDofIDs','onoff',2);

      [~,index]=find(onoff==1);
      result=[];
      for iter=this.gNodes(nodeids)
         dofs=iter.gDofs();
         result=[result,dofs(index)];
      end
      
    end%}}} end gDofIDs


    function result = gNumNode(this)% {{{ NumNode
      %returns total number of nodes in discretization
      result=length(this.nodes_);
    end% }}} end NumNode


    function result = gNumEle(this,listtype)% {{{NumEle
      % comment to be done
      validatestring(listtype,validelelists(),'NumEle','listtype',1);
      
      switch listtype
        case 'stiff'
          result=length(this.stiffele_);
        case 'neumann'
          result=length(this.neumannele_);
        case 'dirich'
          result=length(this.dirichele_);
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end% }}} end NumEle


    function result = gNumDof(this)% {{{NumDof
      %returns total number of global Dofs
      result=this.numdof_;
    end% }}} end NumDof


    function result = gDirichCond(this)% {{{gDirichCond
      %returns global dirichcon_ vector
      result=this.dirichcond_;
    end% }}} end gDirichDof

    function result = gNeumannCond(this)% {{{ gNeumannCond
      %returns global neumanncond_ vector
      result=this.neumanncond_;
    end% }}} end gNeumannCond

    function [] = AddDofCond(this,condtype,dofs,values)% {{{ AddDofCond
      %comment to be done
      validatestring(condtype,  validcondtypes(),                           'AddDofCond','condtype',1);
      validateattributes(dofs,  {'numeric'},  {'nonempty','row','positive'},'AddDofCond','dofs',    2);
      validateattributes(values,{'numeric'},{'nonempty','row'},             'AddDofCond','values',  3);

      if length(dofs)~=length(values)
        error('number of dofs does not equal the number of given values');
      end
      if size(dofs,2)>1
        dofs=dofs';
      end
      if size(values,2)>1
        values=values';
      end

      if strcmp(condtype,'dirich')
        this.dirichcond_=[this.dirichcond_; dofs values];
      elseif strcmp(condtype,'neumann')
        this.neumanncond_=[this.neumanncond_; dofs values];
      else
        error('unknown condition type');
      end

    end% }}}end AddDofCond

    %TODO hack, since this is actually a 2D method
    function [] = ApplyDisp(this,sol)% {{{ ApplyDisp
      %moves the mesh according to solution sol
      validateattributes(sol,{'numeric'},{'vector','numel',this.numdof_},'ApplyDisp','sol',  1);
      
      for iter=1:this.gNumNode()
        curdofs=this.nodes_(iter).gDofs();
        this.nodes_(iter).Move(sol(curdofs(1)),sol(curdofs(1)),0);
      end
    end% }}} end Apply Disp
    
    
    function result= Center(this)
      %comment to be done
      
      result=[0;0;0];
      for iter=this.stiffele_
        result=result+iter{:}.Center();
      end
      result=result/length(this.stiffele_);
    end
    

    
    function [] = ComputeEleStresses(this,sol)
      %comment to be done
      validateattributes(sol,{'double'},{'column'},'ComputeEleStresses','sol',1);
      
      fulltensors=[];  
        for iter = this.stiffele_
            uele=sol(iter{:}.gDofIDs());
            fulltensors=[fulltensors;iter{:}.ComputeEleStresses(uele)'];%TODO bring it to Vtk format now
        end

      this.outbuffer_.WriteElementTensor('element_stresses',fulltensors);
    end

%     function [] = printout(this)% {{{ printout
%       %auxilary function
% 
%       for iter=1:length(this.nodes_)
%         this.nodes_(iter).printout();
%       end
%       for iter=1:length(this.elements_)
%         this.elements_{iter}.printout();
%       end
%     end% }}} end printout

  end

end
