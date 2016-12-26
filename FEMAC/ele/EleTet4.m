classdef EleTet4 < ElementBase
  %Tet4 element class @scheucher 05/15

  properties(Access = private)
  end

  methods(Access=public)
    function this=EleTet4(ID,node1,node2,node3,node4,tags)% {{{ctor
      %connstructor for Tet4 element @scheucher 05/16
      validateattributes(ID,   {'numeric'}, {'scalar'},  'EleTet4','ID',   1);
      validateattributes(node1,{'NodeBase'},{'nonempty'},'EleTet4','node1',2);
      validateattributes(node2,{'NodeBase'},{'nonempty'},'EleTet4','node2',3);
      validateattributes(node3,{'NodeBase'},{'nonempty'},'EleTet4','node3',4);
      validateattributes(node4,{'NodeBase'},{'nonempty'},'EleTet4','node4',5);
      validateattributes(tags, {'numeric'}, {'vector','nonempty'},'EleTet4','node1',6);
      
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.nodes_(3)=node3;
      this.nodes_(4)=node4;
      this.numnode_=4;
      this.tags_=tags;
      this.edges_=[1,2;2,3;3,1;1,4;2,4;3,4];
      this.polygons_=[...
                      1 2 3
                      1 2 4
                      2 3 4
                      3 1 4];
      
    end% }}}
    
    function elemat = Evaluate(this)% {{{stiffness evaluation
      elemat=0;
      error('not yet implemented')
    end% }}}
    
    
    function stressvec = ComputeEleStresses(this,u)
      %compute stresses from displacement solution u @scheucher 05/16
      validateattributes(u,{'numeric'},{'vector','nonempty'},'funcname','u',1);

      stressvec=0;
      error('not yet implemented')
          
    end%end ComputeEleStresses


  end

end
