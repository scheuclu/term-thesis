function globvec = AssembleVec(globvec,elevec, dofs)
  %vector assemble function @scheucher 05/16
  validateattributes(globvec,{'double'},{'vector','nonempty'},'AssembleVec','globvec',1);
  validateattributes(elevec, {'double'},{'vector','nonempty'},'AssembleVec','elevec', 2);
  validateattributes(dofs,   {'numeric'},{'vector','numel',length(elevec)},'AssembleVec','dofs',3);

  globvec(dofs)=globvec(dofs)+elevec;
end
