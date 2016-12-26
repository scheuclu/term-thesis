validatestring(varname,{'validstrings'},'funcname','varname',varnum);

validateattributes(varname,{'classnames'},{'attributes'},'funcname','varname',varnum);


      validateattributes(dim,{'numeric'},{'scalar','>=',2,'<=',3},'ctor Discretization','dim',1);
      validateattributes(newnode,{'NodeBase'},{'scalar'},'AddNode','newnode',1);
      validateattributes(ids,{'numeric'},{'nonempty','row','positive'},'gNodes','ids',1);
      validatestring(listtype,validelelists(),'gEleList','listtype',1);
      validateattributes(nodeids,{'numeric'},{'nonempty','row'},'gDofIDs','nodeids',1);
      validateattributes(onoff,{'numeric'},{'nonempty','nonnegative','integer'},'gDofIDs','onoff',2);      validatestring(condtype,  validcondtypes(),                           'AddDofCond','condtype',1);
      validateattributes(dofs,  {'numeric'},  {'nonempty','row','positive'},'AddDofCond','dofs',    2);
      validateattributes(values,{'numeric'},{'nonempty','row'},             'AddDofCond','values',  3);
      validateattributes(tag,{'char'},{'nonempty'},'WriteNodalVector','tag',  1);
      validateattributes(vector,{'numeric'},{'nrows',this.NumNode()},'WriteNodalVector','vector',  2);
      
      
      %comment @scheucher 05/16
      validateattributes(varname,{'classnames'},{'attributes'},'funcname','varname',varnum);
      
disp('-------------------------------------------------------------------------------')