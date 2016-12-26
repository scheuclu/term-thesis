function [ N] = shapefunctions(eletype,pos)
%returns shape-function value
%validatestring(eletype,valideletypes('all'),'derivshapefunctions','eletype',1);
validateattributes(pos,{'double'},{'vector','nonempty'},'derivshapefunctions','pos',  2);

switch (eletype)
    case 'line2'
      r=pos(1);
      N=[0.5*(1-r);0.5*(1+r)]';
    case 'tri3'
      r=pos(1);
      s=pos(2);
      N=[1-r-s;r;s];
    case 'quad4'
      r=pos(1);
      s=pos(2);
      N=[...
         1-r-s+r*s
         1+r-s-r*s
         1+r+s+r*s
         1-r+s-r*s]*0.25;
otherwise
        error('unsupported element type');
end

end