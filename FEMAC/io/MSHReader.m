classdef MSHReader < handle
 %readas information from msh-file to femac
  
  properties(Access=private)
    discrete_@Discretization  %discretization object
    filepath_ = '<choose>'    %filepath of msh-file
    %            1       2       3       4       5         6           7          8
    msh2femac_={'line2','tri3' ,'quad4','tet4' ,'hex8'   ,'prism6'   ,'pyramid5','line3',...
                'tri6' ,'quad9','tet10','hex27','prism18','pyramid14','point1'}
      %          9       10      11      12      13        14          15
    
    eletypes_=struct(...
                     'dim0',[15],...
                     'dim1',[1,8],...
                     'dim2',[2,3,9,10],...
                     'dim3',[4,5,6,7,12,13,14])

    %eledim_
    tagtypes_ %struct that specifies which tags correspont to stiff, dirich and neumann elements 
    
  end
  
  methods(Access=public)
    function this = MSHReader(dis,filepath,tagtypes)
      %constructor for MSHReader @scheucher 05/16
      validateattributes(filepath,{'char'},{'nonempty'},'MSHReader','filepath',  1);
      %%validateattributes(tagtypes,{'struct'},{isfield(tagtypes,'DIRICH'),isfield(tagtypes,'NEUMANN'),isfield(tagtypes,'MATERIAL')},'MSHReader','tagtypes',  2);
      
      this.discrete_=dis;
      this.filepath_=filepath;
      %this.eledim_={this.eletypes_.dim0,this.eletypes_.dim1,this.eletypes_.dim2,this.eletypes_.dim3};
      this.tagtypes_=tagtypes;
    end
     
    function [] = ReadMesh(this)
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

      nodestring=regexp(fullstring,'\$Nodes.*\$EndNodes','match');
      nodestring=nodestring{1};

      elementstring=regexp(fullstring,'\$Elements.*\$EndElements','match');
      elementstring=elementstring{1};
      %nodestring=fullstring(startindex1:endindex1)


      %% creating the nodes    
      nodestring = regexp(nodestring,'(\r\n|\n|\r)','split');
      numnode=str2double(nodestring(2));
      this.discrete_.InitNodes(numnode);
      nodestring=nodestring(3:end);
      for i=1:length(nodestring)
        nparam=str2num(nodestring{i});
        if ~isempty(nparam)
          this.discrete_.nodes_(nparam(1)).Init(nparam(1),2,[this.discrete_.gNumDof()+1,this.discrete_.gNumDof()+2],nparam(2),nparam(3),nparam(4));
          this.discrete_.IncNumDof(2);%TODO Hack
        end
      end
      consoleinfo([num2str(this.discrete_.gNumNode()),' nodes created']);
      
      
      elelementlineslist=regexp(elementstring,'(\r\n|\n|\r)','split');
      elelementlineslist=elelementlineslist(3:end-1);
      
     %% old point element creation   
      nodeelelist=regexp(elelementlineslist,'^\w(\w)*\s15.*','match');
      nodeelelist=nodeelelist(~cellfun('isempty',nodeelelist));%remove emty matches
      for iter=nodeelelist

        nparam=cellstr(iter{:});
        nparam=str2num( nparam{:} );

        if ~isempty(nparam)
          NODEELEID=nparam(1);
          NODEID=nparam(end);
          NUMTAGS=nparam(3);
          if NUMTAGS ~=2
              error('currently only 2 tags are supported. eleline: ')
          end
          TAGS=nparam(4:3+NUMTAGS);
          
         this.discrete_.gNodes(NODEID).sTags(TAGS);
        end
      end
  
      %% standard read elements
      %TODO I have to drastically change this to improve the code
      %performance
      realelelist=regexp(elelementlineslist,'^\w(\w)*\s*(1|2|3|4|5|15).*','match');%TODO change this here
      realelelist=realelelist(~cellfun('isempty',realelelist));%remove emty matches
      
      
%       save('blabla','realelelist')
%       
%       [realelelist]=ManualPartitioner(realelelist);
      
      %create Elements new
      for iter=realelelist
        temp=iter{:};     
        nparam=str2num(temp{:});
        if ~isempty(nparam)
          ELEID=nparam(1);
          ELETYPE=nparam(2);
          NUMTAGS=nparam(3);
%           if NUMTAGS ~=2
%               error(['currently only 2 tags are supported. eleline: ',iter])
%           end
          TAGS=nparam(4:3+NUMTAGS);
          NODEIDS=nparam(4+NUMTAGS:end);

          %error('temporary exit')
          newele=[];
          
          if ~isempty(find(TAGS(1)==this.tagtypes_.MATERIAL) )%current element must be a stiffness element
            newele=this.CreateStiffEle(ELEID,ELETYPE,NUMTAGS,TAGS,NODEIDS);
            this.discrete_.AddElement('stiff',newele);
          elseif ~isempty(find(TAGS(1)==this.tagtypes_.DIRICH) )%current element must be a stiffness element
            newele=this.CreateCondEle(ELEID,ELETYPE,NUMTAGS,TAGS,NODEIDS,'dirich');
            this.discrete_.AddElement('dirich',newele);
            %error('control: dirichlet element added')
          elseif ~isempty(find(TAGS(1)==this.tagtypes_.NEUMANN) )%current element must be a stiffness element
            newele=this.CreateCondEle(ELEID,ELETYPE,NUMTAGS,TAGS,NODEIDS,'neumann');
            this.discrete_.AddElement('neumann',newele);
          else
            temp
            error(['no match at all for TAG: ',num2str(TAGS(1))]);
             
          end
          
        end
      end
      
      consoleinfo([num2str(this.discrete_.gNumEle('stiff')),' stiffness elements created']);
      consoleinfo([num2str(this.discrete_.gNumEle('dirich')),' dirichlet elements created']);
      consoleinfo([num2str(this.discrete_.gNumEle('neumann')),' neumann elements created']);
      
    end%end function ReadMesh
    
    
    function element = CreateCondEle(this,ELEID,ELETYPE,NUMTAGS,TAGS,NODEIDS,listtype)
      %creates condition elements @scheucher 05/15
      validateattributes(ELEID,  {'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','ELEID',  1);
      validateattributes(ELETYPE,{'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','ELETYPE',2);
      validateattributes(NUMTAGS,{'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','NUMTAGS',3);
      validateattributes(TAGS,   {'numeric'},{'vector','numel',NUMTAGS},         'CreateCondEle','TAGS',   4);
      validateattributes(NODEIDS,{'numeric'},{'vector','nonnegative','nonempty'},'CreateCondEle','NODEIDS',5);
      validatestring(listtype,validelelists(),'CreateCondEle','listtype',6);

      switch(ELETYPE)
        case 1 %line2
          element=CondEleLine2( this.discrete_.gNumEle(listtype)+1,...
                                this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),...
                                TAGS);
        case 2 %tri3
          element=CondEleTri3(  this.discrete_.gNumEle(listtype)+1,...
                                this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),this.discrete_.gNodes(NODEIDS(3)),...
                                TAGS);
        case 3 %quad4
%           NODEIDS
%           error('temp exit')
          element=CondEleQuad4( this.discrete_.gNumEle(listtype)+1,...
                                this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),...
                                this.discrete_.gNodes(NODEIDS(3)),this.discrete_.gNodes(NODEIDS(4)),...
                                TAGS);
        case 15 %point1
          element=CondElePoint1(this.discrete_.gNumEle(listtype)+1,...
                                this.discrete_.gNodes(NODEIDS(1)),...
                               TAGS);
        otherwise
          error(['ELETYPE not recognized: ',num2str(ELETYPE)])
      end
    end%end function CreateCondEle
    
    
    function element = CreateStiffEle(this,ELEID,ELETYPE,NUMTAGS,TAGS,NODEIDS)
      %creates stiffness elements @scheucher 05/15
      validateattributes(ELEID,  {'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','ELEID',  1);
      validateattributes(ELETYPE,{'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','ELETYPE',2);
      validateattributes(NUMTAGS,{'numeric'},{'scalar','nonnegative','nonempty'},'CreateCondEle','NUMTAGS',3);
      validateattributes(TAGS,   {'numeric'},{'vector','numel',NUMTAGS},         'CreateCondEle','TAGS',   4);
      validateattributes(NODEIDS,{'numeric'},{'vector','nonnegative','nonempty'},'CreateCondEle','NODEIDS',5);
      
      switch(ELETYPE)
        case 2 %tri3
          element=EleTri3 (this.discrete_.gNumEle('stiff')+1,...
                           this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),this.discrete_.gNodes(NODEIDS(3)),...
                           TAGS);
        case 3 %quad4
          element=EleQuad4(this.discrete_.gNumEle('stiff')+1,...
                           this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),...
                           this.discrete_.gNodes(NODEIDS(3)),this.discrete_.gNodes(NODEIDS(4)),...
                           TAGS);
        case 4 %tet4
          element=EleTet4(this.discrete_.gNumEle('stiff')+1,...
                           this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),...
                           this.discrete_.gNodes(NODEIDS(3)),this.discrete_.gNodes(NODEIDS(4)),...
                           TAGS);
        case 5 %hex8
          element=EleHex8( this.discrete_.gNumEle('stiff')+1,...
                           this.discrete_.gNodes(NODEIDS(1)),this.discrete_.gNodes(NODEIDS(2)),...
                           this.discrete_.gNodes(NODEIDS(3)),this.discrete_.gNodes(NODEIDS(4)),...
                           this.discrete_.gNodes(NODEIDS(5)),this.discrete_.gNodes(NODEIDS(6)),...
                           this.discrete_.gNodes(NODEIDS(7)),this.discrete_.gNodes(NODEIDS(8)),...
                           TAGS);
        otherwise
          error(['ELETYPE not recognized: ',num2str(ELETYPE)]);
      end
    end%end function CreateCondEle
    
    
  end%end methods

end

