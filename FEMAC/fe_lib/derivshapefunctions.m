function [ N] = derivshapefunctions(eletype,pos)
%returns shape-function value @scheucher 04/16
%validatestring(eletype,valideletypes('all'),'derivshapefunctions','eletype',1);
validateattributes(pos,{'double'},{'vector','nonempty'},'derivshapefunctions','pos',  2);

switch (eletype)
    case 'line2'
      r=pos(1);
      N=[-0.5;0.5]'
    case 'tri3'
      r=pos(1);
      s=pos(2);
      N=[...
        -1 -1
         1  0
         0  1];
    case 'quad4'
      r=pos(1);
      s=pos(2);
      N=[...
        -1+s -1+r
         1-s -1-r
         1+s +1+r
        -1-s +1-r]*0.25;
otherwise
        error('unsupported element type');
end

end