%function structgeneral = InputGeneral(generalstring)
%generalsplit=strsplit(generalstring,NewLines(1)) ;

function structgeneral = InputGeneral(generalsplit)
%processes all input file sections that proveide simple parameters
%parameters are stored in a struct, that keeps the
%input files hirarchy

structgeneral=struct();

%generalsplit=strsplit(generalstring,{'\r\n','\r','\n'},'CollapseDelimiters',true);

%iterate over all lines
iter=1;
while iter<=length(generalsplit)
%%%for iter=1:length(generalsplit)
  curline=generalsplit{iter};
  if isempty(curline)
    break
    iter=iter+1;
  end
  temp=strsplit(strtrim(curline),' ');
  switch(temp{2})
    case 'STRING'
      structgeneral=catstruct(structgeneral,...
        struct(temp{1}, temp{3}) );
    case 'NUMERIC'
      structgeneral=catstruct(structgeneral,...
        struct(temp{1}, str2num(temp{3})  ) );
    case 'BOOL'
      
      structgeneral=catstruct(structgeneral,...
        struct(temp{1}, strcmp(temp{3},'true')  ) );
      
    case 'STRUCT'

      length_substruct=str2num(temp{3});

      substruct     =InputGeneral(generalsplit(iter+1:length_substruct+iter));
      structgeneral=catstruct(structgeneral,...
        struct(temp{1}, substruct  ) );
      iter=iter+length_substruct;

    otherwise
      error(['unknown parammeter type: ',temp{2}]);
  end
  iter=iter+1;
end


end