function [J,detJ,invJ] = getJacobian(eletype,nodes,refpos)
  %get the Jacobian matrix @scheucher 05/16
  validateattributes(eletype,{'char'},{'nonempty'},'getJacobian','eletype'         ,1);
  validateattributes(nodes,{'NodeBase'},{'vector','row','nonempty'},'getJacobian','nodes'         ,2);
  validateattributes(refpos,{'double'},{'nonempty','vector','>=',-1,'<=',1},'getJacobian','refpos'  ,3);

  weights=derivshapefunctions(eletype,refpos);
  
  J=[];
  
  switch eletype
    case 'tri3'
      J=[...
        nodes(1).X() nodes(2).X() nodes(3).X()
        nodes(1).Y() nodes(2).Y() nodes(3).Y()]*weights;
    case 'quad4'
     J=[...
        nodes(1).X() nodes(2).X() nodes(3).X() nodes(4).X()
        nodes(1).Y() nodes(2).Y() nodes(3).Y() nodes(4).Y()]*weights;
    case 'hex8'
      J=[...
        nodes(1).X() nodes(2).X() nodes(3).X(), nodes(4).X(), nodes(5).X() nodes(6).X() nodes(7).X(), nodes(8).X()
        nodes(1).Y() nodes(2).Y() nodes(3).Y(), nodes(4).Y(), nodes(5).Y() nodes(6).Y() nodes(7).Y(), nodes(8).Y()
        nodes(1).Z() nodes(2).Z() nodes(3).Z(), nodes(4).Z(), nodes(5).Z() nodes(6).Z() nodes(7).Z(), nodes(8).Z()]*weights;
    otherwise
      error(['unknown element type: ',])
  end

  detJ=det(J);
  invJ=inv(J);

end
