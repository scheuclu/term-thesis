classdef NodeBase < matlab.mixin.Copyable
  %node base class @scheucher 05/16
  
  properties(Access=private)
    
    id_=[];            %global ID
    pos_=[0; 0; 0];      %position vector
    scalar1_@double=0  %scalar1
    scalar2_@double=0  %scalar2
    scalar3_@double=0  %scalar3
    vector1_@double=[] %vector1
    vector2_@double=[] %vector2
    dofs_=[]           %dof IDs
    dim_ =0            %dimension
    tags_=[]           %tag-vector
    
  end

  methods(Access=public)
    
    function this=NodeBase()% {{{ctor
      %constructor for NodeBase @scheucher 05/16

    end% }}}
     
    function [] = Init(this,id,dim,dofs,x,y,z)
      %Initialize NodeBase parameters
      
      this.id_=id;
      this.pos_(1,1)=x;
      this.pos_(2,1)=y;
      this.pos_(3,1)=z;
      this.dim_     =dim;
      if(dim==2 && length(dofs)~=2)
        error('node with dim=2 reqires 2 dofs');
      elseif(dim==3 && length(dofs)~=3)
        error('node with dim=3 requires 3 dofs');
      end
      this.dofs_ =rowvec(dofs);
    end

    function result = gPos(this)% {{{ getter for pos vector
      %getter for pos_ @scheucher 05/16
      
      result=this.pos_;
    end% }}}

    function result = X(this)% {{{ getter for X
      %getter for pos(1) @scheucher 05/16
      
      result=this.pos_(1);
    end% }}}

    function result =Y(this)% {{{ getter for Y
      %getter for pos(2) @scheucher 05/16
      
      result=this.pos_(2);
    end% }}}

    function Z = Z(this)% {{{ getter for Z
      %getter for pos(3) @scheucher 05/16
      
      Z=this.pos_(3);
    end% }}}
    
    
    function [] = Move(this,dx,dy,dz)
      %move node @scheucher 05/16
      validateattributes(dx,{'double'},{'scalar','nonempty'},'Move','dx',1);
      validateattributes(dy,{'double'},{'scalar','nonempty'},'Move','dy',1);
      validateattributes(dz,{'double'},{'scalar','nonempty'},'Move','dz',1);
      
      this.pos_=this.pos_+[dx;dy;dz];
    end

    function result = gDofs(this)% {{{getter for dofs_
      %getter for dof IDs @scheucher 05/16
      %this
      result=this.dofs_;
    end% }}}

    function result = Dim(this)% {{{getter for Dim
      %getter for dim_ @scheucher 05/16
      
      result=this.dim_;
    end% }}}

    function result = gID(this)% {{{getter for ID
      %getter for id_ @scheucher 05/16
      
      result=this.id_;
    end% }}}
    
    function [] = sTags(this,tags)
      %setter for tags_ @scheucher 05/16
      validateattributes(tags,{'numeric'},{'vector','nonempty'},'sTags','tags',1);
      
      this.tags_=tags;
    end
    
    function result = gTags(this)
      %getter for tags_ @scheucher 05/16
      
      result=this.tags_;
    end
    
    function [] = sID(this,id)
      this.id_=id;
    end
    
    function [] = sDofs(this,dofs)
      this.dofs_=dofs;
    end
    
  end
end

