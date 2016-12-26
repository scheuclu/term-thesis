classdef FETISubStructure < handle
  %holds all relevant information about the a substructurte in an FETI
  %algorithm
  
  properties(Access=public)%private
    ID_          @double %global substructure ID
    alldofgids_  @double %global IDs of all substructure dofs
    ifacedofgids_@cell   %global IDs of substructure interface dofs
    allnodegids_ @double %global IDs of all substructure nodes
    allelegids_  @double %global IDs of all substructure elements
    numdof_      @double %total number of substructure dofs
    ifacenodegids_= {};  %global IDs of substructure interface nodes
    ifacenodegidmat_ = sparse(0,0);
    dis_    @Discretization %Discretization object
    center_ @double      %coordinates of substructure center in reference configuration
    numsubs_@double      %total number of FETI substructures
    
    lagmultgids_@double
    
    subitersol_@cell={};
  end
  
  methods(Access=public)
    
    function this = FETISubStructure(id,numsubs,dis)
      this.ID_ =id;
      this.dis_=dis;
      this.numsubs_=numsubs;
    end
    
    %% getters
    function result = gID(this)
      result=this.ID_;
    end
    
    function result = gDofs(this,loc)
      result=this.alldofgids_(loc);
    end
    
    function result = gNumDof(this)
      result = this.numdof_;
    end
    
    function result = gNumNode(this)
      result = length(this.allnodegids_);
    end
    
    function result = gNumEle(this)
      result = length(this.allelegids_);
    end
    
    function result = gNumIDof(this)
      result=length(unique(abs(cell2mat(this.ifacedofgids_))));%TODO pretty ugly
    end
    
    function result = gEleGIDs(this,loc)%gEleIDs(this,loc)
      result=this.allelegids_(loc);
    end
    
    function result = gNodeGIDs(this,loc)%gNodeIDs(this,loc)
      result=this.allnodegids_(loc);
    end
    
    function result = gIfaceNodeGIDs(this,loc)%gINodeIDs(this,loc)
      result=this.ifacenodegids_(loc);
    end
    
    function result = gIfaceDofGIDs(this,loc)%gIDofs(this,loc)
      result=this.ifacedofgids_(loc);
    end
    
    function result = gCenter(this)
      result=this.center_;
    end
    
   
    
    %% add functions
    
    
    function [] = addEleGIDs(this,ids)
      this.allelegids_(end+1)=ids;
    end
    
    
    function [] = addINodeIDs(this,countersubid,inodeid)
      if length(this.ifacenodegids_)<countersubid
        this.ifacenodegids_{countersubid}=inodeid;
      else
        this.ifacenodegids_{countersubid}=[this.ifacenodegids_{countersubid},inodeid];
      end
       
      this.ifacenodegidmat_(countersubid,abs(inodeid))=sign(inodeid);
    end
    
    
    %% public working methods
    
    
    function nodeslids = Gid2slid_Node(this,nodegids)
      [~,nodeslids]=ismember(nodegids,this.allnodegids_);
    end
    
    function eleslids = Gid2slid_Ele(this,elegids)
      [~,eleslids]=ismember(elegids,this.allelegids_);
      error('Please check this method for correct output once');
    end
    
    function dofslids = Gid2slid_Dof(this,dofgids)
      [~,dofslids]=ismember(dofgids,this.alldofgids_);
      %error('Please check this method for correct output once');
    end
    
    
    function nodegids = Slid2gid_Node(this,nodeslids)
      nodegids=this.allnodegids_(nodeslids);
      error('Please check this method for correct output once');
    end
    
    function elegids = Slid2gid_Ele(this,eleslids)
      elegids=this.allelegids_(eleslids);
      error('Please check this method for correct output once');
    end
    
    function dofgids = Slid2gid_Dof(this,dofslids)
      dofgids=this.alldofgids_(dofslids);
      error('Please check this method for correct output once');
    end
    
    
    
    function [] = Resolve(this)
      for iter=this.allelegids_
        this.allnodegids_=[this.allnodegids_,this.dis_.gElement('stiff',iter).gNodeIDs()];
      end
      this.allnodegids_=unique(this.allnodegids_);
      
      for iter=this.allnodegids_
        this.alldofgids_=[this.alldofgids_,this.dis_.gNodes(iter).gDofs()];
      end
      this.alldofgids_=unique(this.alldofgids_);
      this.numdof_=length(this.alldofgids_);
    end
    
    
    function [] = ResolveIDofs(this)

      this.ifacedofgids_=cell(1,this.numsubs_);
      
      for counterid=1:length(this.ifacenodegids_)
        if counterid==this.ID_
          continue
        end
        %error('tempx exit')
        for nodeid=rowvec(this.ifacenodegids_{counterid})
          if isempty(nodeid)
            continue;
          end
          %TODO the following if-else construct can be programmed more
          %efficeinetly by using a temppray array and assigning it
          %afterwards
          if length(this.ifacedofgids_)<counterid
            this.ifacedofgids_{counterid}=sign(nodeid).*this.dis_.gNodes(abs(nodeid)).gDofs();
          else
            this.ifacedofgids_{counterid}=[this.ifacedofgids_{counterid},sign(nodeid).*this.dis_.gNodes(abs(nodeid)).gDofs()];
          end
        
        end
      end
      
    end
    
    
    function [] =CalcCenter(this)
    %returns the geometric center of the substructure: [x;y;z]
    
      result=[0;0;0];
      for iter=this.allelegids_
        result=result+this.dis_.gElement('stiff',iter).Center();
      end
      result=result/length(this.allelegids_);
      this.center_=result;
    end
    
    
    function [] = Move(this,dx,dy,dz)
    %moves the substructure
  
      for iter=this.allnodegids_
        this.dis_.gNodes(iter).Move(dx,dy,dz);
      end
    end
    
    
    function [] =WriteIterSol(this,timestep,subsolution)
      this.subitersol_{timestep}=subsolution;
    end
   
  end % end methods public
  
  
  methods(Access=private)

    function [] = AddNodeIDs(this,nodeIds)
      this.allnodegids_(end+1)=nodeIds;
    end
        
    function [] = AddElementIDs(this,elementIds)
      this.elementids_(end+1)=elementIds;
    end
      

    function result = Center(this)
      result=[0;0;0];
      for iter=this.allelegids_
        result=result+this.dis_.gElement('stiff',iter).Center();
      end
      result=result/length(this.allelegids_);
    end
  
  end% end methods private
end