classdef EleHex8 < ElementBase
  %hex8 class

  properties(Access = private)
  end

  methods(Access=public)
    function this=EleHex8(ID,node1,node2,node3,node4,node5,node6,node7,node8,tags)% {{{ctor
      %constructor for EleHex8 @scheucher 05/16
      validateattributes(ID,   {'numeric'}, {'scalar'},  'EleQuad4','ID',   1);
      validateattributes(node1,{'NodeBase'},{'nonempty'},'EleQuad4','node1',2);
      validateattributes(node2,{'NodeBase'},{'nonempty'},'EleQuad4','node2',3);
      validateattributes(node3,{'NodeBase'},{'nonempty'},'EleQuad4','node3',4);
      validateattributes(node4,{'NodeBase'},{'nonempty'},'EleQuad4','node4',5);
      validateattributes(node5,{'NodeBase'},{'nonempty'},'EleQuad4','node5',6);
      validateattributes(node6,{'NodeBase'},{'nonempty'},'EleQuad4','node6',7);
      validateattributes(node7,{'NodeBase'},{'nonempty'},'EleQuad4','node7',8);
      validateattributes(node8,{'NodeBase'},{'nonempty'},'EleQuad4','node8',9);
      validateattributes(tags, {'numeric'}, {'vector','nonempty'},'EleHex8','tags',10);
      
      this.id_=ID;
      this.nodes_(1)=node1;
      this.nodes_(2)=node2;
      this.nodes_(3)=node3;
      this.nodes_(4)=node4;
      this.nodes_(5)=node5;
      this.nodes_(6)=node6;
      this.nodes_(7)=node7;
      this.nodes_(8)=node8;
      this.numnode_=8;
      this.tags_=tags;
      this.edges_=[...
                   1 2
                   2 3
                   3 4
                   4 1
                   5 6
                   6 7
                   7 8
                   8 5
                   1 5
                   2 6
                   3 7
                   4 8];
      this.polygons_=[...
                      1 2 3 4
                      1 2 6 5
                      2 3 7 6
                      3 4 8 7
                      4 1 5 8
                      5 6 7 8];
                      
      
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
