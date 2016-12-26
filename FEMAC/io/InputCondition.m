function [condlist]= InputCondition(generalstring)
%Condition Generation
%takes the full string of the condition section and 
%creates appropriate Condition objects

%this is a quick hack, and will be changed in the future
%future conition manager class will provide a method to easily add
%conditions
validcondnames={'DIRICHLET_CONDITION','NEUMANN_CONDITION','MATERIAL_CONDITION'};

%split the section into blocks, that are separeated by empty lines
condblocks=strsplit(generalstring,{'\r\n\r\n','\r\r','\n\n'},'CollapseDelimiters',true);

%kinematic condititions are dirichlet or neumann conditions.
%in general everything which directly manipulates the system matrix
condlist.kin  =cell(0);

%material conditions asociate element IDs with material IDs
condlist.mat =cell(0);

for iter=1:length(condblocks)
  if isempty(condblocks{iter})
    continue
  end

  %check whether the current block matches a valid condition
  [~,b]=regexp(condblocks{iter},CreateOrString(validcondnames),'match');
  if isempty(b) 
    error(sprintf(['unknows material detected: material ',num2str(iter),' in section MATERIALS:\n',condblocks{iter}]))
  end
  
  %split the current block into lines
  blocklines=strsplit(condblocks{iter},{'\r\n','\r','\n'},'CollapseDelimiters',true);
  
  %first line determines the condition type
  switch blocklines{1}
    case 'DIRICHLET_CONDITION'
      [values,count]=sscanf(blocklines{2},'CONDID %d ONOFF %d %d VAL %f %f MSHTAG %d');
      CONDID = values(1);
      ONOFF  = [values(2),values(3)];
      VAL    = [values(4),values(5)];
      MSHTAG = values(6);
      %error('temporary exit');
      newcond=ConditionDirichlet(CONDID,2,ONOFF,VAL,MSHTAG);
      condlist.kin{end+1}=newcond;
    case 'NEUMANN_CONDITION'
      [values,count]=sscanf(blocklines{2},'CONDID %d ONOFF %d %d VAL %f %f MSHTAG %d');
      CONDID = values(1);
      ONOFF  = [values(2),values(3)];
      VAL    = [values(4),values(5)];
      MSHTAG = values(6);
      newcond=ConditionNeumann(CONDID,2,ONOFF,VAL,MSHTAG);
      condlist.kin{end+1}=newcond;
    case 'MATERIAL_CONDITION'
      [values,count]=sscanf(blocklines{2},'CONDID %d MATID %d MSHTAG %d');
      CONDID= values(1);
      MATID = values(2);
      MSHTAG= values(3);
      newcond=ConditionMaterial(CONDID,MATID,MSHTAG);
      condlist.mat{end+1}=newcond;
    otherwise
      error(['unknown condition detected: ',blocklines{1}]);
  end

end






end