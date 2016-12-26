classdef DATReader < handle
 %Manages the Input file parsing
  
  properties(Access=private)
    filepath_  %path to dat-file
  end
  
  methods(Access=public)
    function this = DATReader(filepath)
      %constructor for DATReader
       this.filepath_   = filepath;
    end
    
    
    function [params,materials,conditions] = Read(this)
      %reads the datfile and call subroutines for creation of all reqiured
      %geometry objects @scheucher 05/16
   
      %initialize empty data conainers
      params      = struct();
      materials   = {};
      conditions  = {};


      %read the entire dat-file into a single string
      filestring=fileread(this.filepath_);

      %split the dat file into different sections
      sectionsplit=regexp(filestring,'---*','split');

      %process every section
      for i=2:length(sectionsplit)
        [~,b]=regexp(sectionsplit{i},CreateOrString(validdatsections()),'split');
        if isempty(b)
          error(['unknown section detected: section ',num2str(i-1)])
        end
        
        if ~isempty(regexp(sectionsplit{i},['-IGNORE','(\r\n|\n|\r)']))
          continue
        end
        
        sectionname=regexp(sectionsplit{i},[CreateOrString(validdatsections() )],'match');

        sectioncontent=regexp(sectionsplit{i},[CreateOrString(validdatsections() ),'(\r\n|\n|\r)'],'split');
        sectioncontent=sectioncontent(2:end);

        result = InputSection(sectionname{1},sectioncontent{1});%canm be deleted

        if strcmp(sectionname{1},'CONDITIONS')
          conditions=result;
        elseif strcmp(sectionname{1},'MATERIALS')
          materials=result;
        else
          params=catstruct(params,...
                 struct(sectionname{1},InputSection(sectionname{1},sectioncontent{1}) )    );
        end
      end
     
    end
    
%     function []=AddValidSection(this,sectionname)
%       this.validsections_{end+1}=sectionname;
%     end
    
  end
  
end

