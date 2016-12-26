function [ gpxi, gpw ] = gaussrule(eletype,numgp)
%returns positions and weight for gaussintegration @scheucher 04/16
%validatestring(eletype,valideletypes('all'),'derivshapefunctions','eletype',1);
validateattributes(numgp,{'numeric'},{'scalar','nonempty','nonnegative'},'derivshapefunctions','numgp',2);

gpxi=[];
gpw=[];

switch (eletype)
    case 'line2'
      gpxi=[-0.57735026919,...
             0.57735026919];
      gpw=[1.0;1.0];
    case 'tri3'
      gpxi=[...
        0.166666666666667 0.166666666666667
        0.666666666666667 0.166666666666667
        0.166666666666667 0.666666666666667];
      gpw=[0.166666666666667; 0.166666666666667; 0.166666666666667];
    case 'quad4'
      [agpxi,agpw]=gaussrule('line2',2);
      gpxi=agpxi([ 1 1; 2 1; 2 2; 1 2]);
      gpw=[1; 1; 1; 1];
otherwise
        error('unsupported element type');
end

end

