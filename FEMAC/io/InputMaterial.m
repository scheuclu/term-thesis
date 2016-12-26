function materiallist = InputMaterial(generalstring)

validmat          ={'ST_VENANT_KIRCHOFF','NEOHOOKE'};

%split the section into blocks, divided by an empty line
matblocks=strsplit(generalstring,{'\r\n\r\n','\r\r','\n\n'},'CollapseDelimiters',true);

%initialize an empty list
materiallist=cell(1,length(matblocks));

%iterate over all blocks
for iter=1:length(matblocks)
  structmaterial=struct();
  [~,b]=regexp(matblocks{iter},CreateOrString(validmat),'match');
  if isempty(b)
    error(['unknows material detected: material ',num2str(iter),' in section MATERIALS']);
  end
  
  %split the current block into its lines
  curmatlines=strsplit(matblocks{iter},{'\r\n','\r','\n'},'CollapseDelimiters',true);
  
  switch curmatlines{1}
    case 'ST_VENANT_KIRCHOFF'
      [values,count]=sscanf(curmatlines{2},'MATID %d E %d nu %f type %s');
      MATID=values(1);
      E    =values(2);
      nu   =values(3);
      type =char(values(4:end)');
      structmaterial=catstruct(structmaterial,...
                     struct('ID', MATID , 'TYPE', curmatlines{1}, 'E', E, 'nu', nu, 'type', type) );
    case 'NEOHOOKE'
      [values,count]=sscanf(curmatlines{2},'MATID %d p1 %f p2 %f p3 %f');
      MATID=values(1);
      p1   =values(2);
      p2   =values(3);
      p3   =values(4);
      structmaterial=catstruct(structmaterial,...
                     struct('ID', MATID , 'TYPE', curmatlines{1}, 'p1', p1, 'p2', p2, 'p3', p3) );
    otherwise
      error(['unknown material detected ',curmatlines{1}]);
  end
  materiallist{MATID}=structmaterial;

end



end