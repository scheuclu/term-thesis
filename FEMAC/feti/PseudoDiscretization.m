classdef PseudoDiscretization < handle
  % PseudoDiscretization is needed for the separated output of FETI
  % substructures. One PseudoDiscretization is created for every
  % substructure that shall be written out

  properties(Access=public)%protected
    
    dim_              %pproblem dimension
    nodes_@NodeBase   %node array
    
    stiffele_   ={}   %cell object that contains all stiffness elements
    neumannele_ ={}   %cell object that contains all neumann elements
    dirichele_  ={}   %cell object that contains all dirichlet elements
    
    numdof_=0         %total dof number
    
    conditions_= {}   %list of conditions
    
    outbuffer_@OutputBuffer %buffer for all data that shall be written to a file
    
  end

  methods(Access=public)

    function this = PseudoDiscretization(dim)
      %constructor for class Discretization  @scheucher 07/16
      validateattributes(dim,{'numeric'},{'scalar','>=',2,'<=',3},'ctor Discretization','dim',1);

      this.dim_=dim;
    end
    
    function [] = sOuputBuffer(this,buffer)
      %setter for output buffer
      validateattributes(buffer,{'OutputBuffer'},{'nonempty'},'sOuputBuffer','buffer',1);
      
      this.outbuffer_=buffer;
    end
    
    
    function [] = AddNode(this,newnode)
      %adds node to this.nodes_  @scheucher 07/16
      validateattributes(newnode,{'NodeBase'},{'scalar'},'AddNode','newnode',1);

      this.nodes_(end+1)=newnode;
      this.numdof_=this.numdof_+newnode.Dim();
    end


    function [] = AddElement(this,listtype,newelement)
      %add element to this.stiffele_, this.dirichele_ or this.neumannele_
      %@scheucher 07/16
      validatestring(listtype,validelelists(),'AddElement','listtype',1);
      validateattributes(newelement,valideletypes(listtype),{'scalar'},'AddNode','newelement',2);

      switch listtype
        case 'stiff'
          this.stiffele_{end+1}=newelement;
        case 'dirich'
          this.neumannele_{end+1}=newelement;
        case 'neumann'
          this.dirichele_{end+1}=newelement;
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end



    function result = gNodes(this,ids)
      %getter for nodes, use ':' for all nodes  @scheucher 07/16
      
      result=this.nodes_(ids);
    end
    

    function result = gElement(this,listtype,id)
      %getter for element  @scheucher 07/16
      validatestring(listtype,validelelists(),                  'gElement','listtype',1);
      validateattributes(id,{'numeric'},{'nonempty','positive'},'gElement','id',      2);
      
      switch listtype
        case 'stiff'
          result=this.stiffele_{id};
        case 'dirich'
          result=this.neumannele_{id};
        case 'neumann'
          result=this.dirichele_{id};
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end
    
    
    function result = gEleList(this,listtype)
      %getter for this.stiffele_, this.dirichele_ or this.neumannele_
      %@scheucher 05/16
      validatestring(listtype,validelelists(),'gEleList','listtype',1);

      switch listtype
        case 'stiff'
          result=this.stiffele_;
        case 'dirich'
          result=this.neumannele_;
        case 'neumann'
          result=this.dirichele_;
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end
    
    
    function result = gElements(this,listtype,id)
      %returns array of elements specified by id
      validatestring(listtype,validelelists(),'gElements','listtype',2);
      validateattributes(id,{'numeric'},{'nonempty','row'},'gElements','id',2);

      switch listtype
        case 'stiff'
          result=this.stiffele_(id);
        case 'dirich'
          result=this.neumannele_(id);
        case 'neumann'
          result=this.dirichele_(id);
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end


    function result = gDofIDs(this,nodeids,onoff)
      %get dof IDs of nodes  @scheucher 07/16
      validateattributes(nodeids,{'numeric'},{'nonempty','row'},'gDofIDs','nodeids',1);
      validateattributes(onoff,{'numeric'},{'nonempty','nonnegative','integer'},'gDofIDs','onoff',2);

      [~,index]=find(onoff==1);
      result=[];
      for iter=this.gNodes(nodeids)
         dofs=iter.gDofs();
         result=[result,dofs(index)];
      end
      
    end


    function result = gNumNode(this)
      %get the number of nodes  @scheucher 07/16
      
      result=length(this.nodes_);
    end


    function result = gNumEle(this,listtype)
      % get the number of elements  @scheucher 07/16
      validatestring(listtype,validelelists(),'NumEle','listtype',1);
      
      switch listtype
        case 'stiff'
          result=length(this.stiffele_);
        case 'dirich'
          result=length(this.neumannele_);
        case 'neumann'
          result=length(this.dirichele_);
        otherwise
          error(['listtype not recognized: ', listtype])
      end
      
    end


    function result = gNumDof(this)
      %get the number of dofs  @scheucher 07/16
      
      result=this.numdof_;
    end
 
    
    function result= Center(this)
      %get the coordinates of the PseudoDiscretization's center
      %@scheucher 07/16
      
      result=[0;0;0];
      for iter=this.stiffele_
        result=result+iter{:}.Center();
      end
      result=result/length(this.stiffele_);
    end
    

    function [] = ComputeEleStresses(this,sol)
      %Recover stresses from displacement solution  @scheucher 07/16
      validateattributes(sol,{'double'},{'column'},'ComputeEleStresses','sol',1);
      
      fulltensors=[];  
        for iter = this.stiffele_

          uele=sol(iter{:}.gDofIDs());
          fulltensors=[fulltensors;iter{:}.ComputeEleStresses(uele)'];%TODO bring it to Vtk format now
        end

      this.outbuffer_.WriteElementTensor('element_stresses',fulltensors);
    end

  end

end
