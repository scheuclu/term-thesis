classdef MSHPartitioner < handle
 %readas information from msh-file to femac
  
  properties(Access=private)
    filepath_ = ''
    stifftags_
    subtags_
    
  end
  
  methods(Access=public)
    function this = MSHPartitioner(filepath,stifftags,subtags)
     
      this.filepath_ =filepath;
      this.stifftags_=stifftags;
      this.subtags_  =subtags;
      
      this.Work();
    end
     
    function [] = Work(this)
      %reads the mesh, creates all element objects and links them to the
      %Discretization object @scheucher 05/16
      
      if strcmp(this.filepath_,'<choose>')
        [filename, pathname] = uigetfile('*.msh', 'Choose appropriate msh file');
        if isequal(filename,0)
           error('User selected Cancel');
        else
           this.filepath_=fullfile(pathname, filename);
           consoleinfo(['User selected ', this.filepath_]);
        end
      end
      
      
      this.filepath_ = regexprep(this.filepath_, '(/|\\)', filesep);
      fullstring=fileread(this.filepath_);

      remainstring=regexp(fullstring,'\$Elements','split');
      remainstring=remainstring{1};

      elementstring=regexp(fullstring,'\$Elements.*\$EndElements','match');
      elementstring=elementstring{1};
      
      elelementlineslist=regexp(elementstring,'(\r\n|\n|\r)','split');
      elelementlineslistr=elelementlineslist(3:end-1);
      
      %nodestring=fullstring(startindex1:endindex1)
  
      %% standard read elements
      %TODO I have to drastically change this to improve the code
      %performance
      realelelist=regexp(elelementlineslistr,'^\w(\w)*\s(1|2|3|4|5|15).*','match');%TODO change this here
      realelelist=realelelist(~cellfun('isempty',realelelist));%remove emty matches
      
      
      [realelelist]=this.DoPartitionLogic(realelelist);
           
      fhandle = fopen([this.filepath_,'.part'],'w');
      fprintf(fhandle,remainstring);
      fprintf(fhandle,elelementlineslist{1});
      fprintf(fhandle,'\n');
      fprintf(fhandle,num2str(length(realelelist),'%1d '));
      fprintf(fhandle,'\n');
      
      for iter=realelelist
        t=iter{1};
        fprintf(fhandle,t{1});
        fprintf(fhandle,'\n');
      end
      
           
      fprintf(fhandle,elelementlineslist{end});
      fclose(fhandle);
      
      
    end%end function ReadMesh
    
    
    function [outlist] = DoPartitionLogic(this,inlist)

      condeleid =1;
      stiffeleid=1;
      subeleid  =1;


      numsubs=length(this.subtags_);

      %% Read element information
      for i=1:length(inlist)
        tempvar=inlist{i}; %get current list element
        linenumbers=str2num(tempvar{:});

        tempele.eletype =linenumbers(2);
        tempele.numtag  =linenumbers(3);
        tempele.tag     =linenumbers(4);
        tempele.gmshtag =linenumbers(5);
        tempele.nodes   =linenumbers(end-this.gNumNodes(tempele.eletype)+1:end);

        %enlist element as stiffness element
        if find(ismember(this.stifftags_,tempele.tag))
          %tempele.id=eleid
          tempele.neighbors=[];
          stiffele(stiffeleid)=tempele;
          stiffeleid=stiffeleid+1;
        end

        %enlist element as condition element
        if isempty(find(ismember(this.stifftags_,tempele.tag))) && isempty(find(ismember(this.subtags_,tempele.tag)) )
          %tempele.id=eleid;
          condele(condeleid)=tempele;
          condeleid=condeleid+1;
        end

        %enlist element as substructure condition element
        if find(ismember(this.subtags_,tempele.tag))
          tempele.subid=find(ismember(this.subtags_,tempele.tag));
          subele(subeleid)=tempele;
          subeleid=subeleid+1;
        end  
        clear tempele
      end
        
      %% Write Element IDs
      id=1;
      for i=1:length(condele)
        condele(i).id=id;
        condele(i).numtag=2;
        id=id+1;
      end
      for i=1:length(stiffele)
        stiffele(i).id=id;
        id=id+1;
      end      
      
      %% Determine substructure ID for all elements
      %loop over all stiffness elements
      for i=1:length(stiffele)
        %loop over substructure elements and find a match
        for counterele=subele
          if isequal(stiffele(i).nodes,counterele.nodes)
            stiffele(i).subid=counterele.subid;
          end
        end
      end


      %loop over all stiffness elements
      for i=1:length(condele)
        condele(i).subid=0;
        %loop over substructure elements and find a match
        for counterele=subele

          if sum(ismember(counterele.nodes,condele(i).nodes))==length(condele(i).nodes)
            condele(i).subid=counterele.subid;
            break
          end
        end
      end


      %% Determine neighbors for stiffness elements
      %loop over all stiffness elements
      for i=1:length(stiffele)
        %loop over all other stiffness elements
        for j=1:length(stiffele)
          if i==j
            continue
          end
          if stiffele(i).subid==stiffele(j).subid
            continue
          end
          if ~isempty(find(ismember(stiffele(i).nodes,stiffele(j).nodes)))
            stiffele(i).neighbors=[stiffele(i).neighbors,stiffele(j).id];
          end

        end
      end


      %% Write Number of neighbors
      for i=1:length(stiffele)
        stiffele(i).numtag=2+2+length(stiffele(i).neighbors)
      end  


      %% Write outputlist
      outlist={};
      for i=1:length(condele)

        filler=[];
        if condele(i).eletype~=15
          filler=[1 condele(i).subid];
          condele(i).numtag=4;
        end

        outlist{end+1}=...
           {num2str([condele(i).id condele(i).eletype condele(i).numtag,...
           condele(i).tag condele(i).gmshtag filler condele(i).nodes])};
      end
      %  ID  Eletype numtag phytag  gmshtag   numsubs   cursub   neigbors        nodes
      for i=1:length(stiffele)
         outlist{end+1}=...
           {num2str([stiffele(i).id stiffele(i).eletype stiffele(i).numtag,...
           stiffele(i).tag stiffele(i).gmshtag  numsubs stiffele(i).subid,...
           -stiffele(i).neighbors stiffele(i).nodes])};
      end
    
    end
    

    function [numnodes] = gNumNodes(this,type)

      numnodes=NaN;
      switch type
        case 15
          numnodes =1;
        case 1
          numnodes =2;
        case 2
          numnodes =3;
        case 3
          numnodes =4;
        otherwise
          error(['Type unnown: ',num2str(type)])
      end
    end
    
    
  end%end methods

end

