function Kmat = AssembleMat(Kmat,elemat, dofs)
  %matrix assemble function @scheucher 05/16
  validateattributes(Kmat,  {'double'}, {'square','nonempty'},   'AssembleMat','Kmat',  1);
  validateattributes(elemat,{'double'}, {'square','nonempty'},   'AssembleMat','elemat',2);
  validateattributes(dofs,  {'numeric'},{'vector','numel',size(elemat,1)},'AssembleMat','dofs',  3);

  Kmat(dofs,dofs)=Kmat(dofs,dofs)+elemat;
end
