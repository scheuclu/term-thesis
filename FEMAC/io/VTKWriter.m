classdef VTKWriter < handle
  %Writes calculation output to vtk-file
  
  properties
    discrete_ %Discretization object
    params_=struct( 'WRITEEVERY', 0,...
                    'FORMAT',     'vtk',...
                    'PATH',       'nopath',...
                    'NAME',       'noname')
    filepath_=''
  end
  
  methods
    function this = VTKWriter(dis,params)
      %constructor for VTKWriter @scheucher 05/16
      validateattributes(dis,{'Discretization','PseudoDiscretization'},{'nonempty'},'VTKWriter','dis',1);      
      this.discrete_=dis;
      this.SetParams(params);
      %params_=struct('FETIsep', false);
    end
    
    
    function [] = SetParams(this,params)
      %set solver parameters as specified in input @scheucher 06/16
      validateattributes(params,{'struct'},{'nonempty'},'Settings','params',1);
      
      for iter=fieldnames(this.params_)'
        if isfield(params,iter{:})
          this.params_=setfield(this.params_,iter{:},getfield(params,iter{:}));
        end
      end
    end
    
    
    function result = VTKCellType(this,eleclass)
      switch eleclass
        case 'EleLine2'
          result=3;
        case 'EleTri3'
          result=5;
        case 'EleQuad4'
          result=9;
        case 'EleTet4'
          result=10;
        case 'EleHex8'
          result=12;
        otherwise
          error(['unknown element type: ',eletype]);
      end
    end
    
%     function [] = Settings(this,params)
%       %set solver parameters as specified in input @scheucher 06/16
%       validateattributes(params,{'struct'},{'nonempty'},'Settings','params',1);
%       
%       for iter={'ASSEMBLEDOPS','VERBOSE','REASSEMBLESYS','CHECKS','COARSEGRID'}
%         if isfield(params,iter{:})
%           this.params_=setfield(this.params_,iter{:},getfield(params,iter{:}));
%         end
%       end
%     end
    
    function [] = WriteFile(this,outbuffer,timestep)
      %write the information currently stored in this.dis_ @scheucher 05/16
      validateattributes(timestep,{'numeric'},{'nonempty','nonnegative'},'WriteFile','timestep',1);
      
      consoleline('START VTK-WRITING',false);
      tic;
      
      if strcmp(this.params_.PATH,'<choose>')
        [this.params_.NAME, this.params_.PATH] = uiputfile('*.vtk', 'Choose vtk output file');
        if isequal(filename,0)
           error('User selected Cancel');
        else
           %this.fullfile_=fullfile(this.params_.PATH, this.params_.NAME);
           consoleinfo(['User selected ', this.params_.PATH]);
        end
      end
      
      this.filepath_=fullfile(this.params_.PATH,[this.params_.NAME,'.vtk.',num2str(timestep)]);

      
      this.filepath_ = regexprep(this.filepath_, '(/|\\)', filesep);
      fhandle = fopen(this.filepath_,'w');
      fprintf(fhandle,'# vtk DataFile Version 3.1\nthis is an vtk file created by FEMAC\nASCII\nDATASET UNSTRUCTURED_GRID\n');
      
      %% print node information
      fprintf(fhandle,'POINTS %d FLOAT\n',this.discrete_.gNumNode());
      for inode=1:this.discrete_.gNumNode();
        curnode=this.discrete_.gNodes(inode);
        fprintf(fhandle,'%1.6f %1.6f %1.6f\n',curnode.X(),curnode.Y(),curnode.Z());
      end
      consoleinfo([num2str(this.discrete_.gNumNode()),' nodes written']);
           
      %% print cell information
      cellstring='';
      numentries=0;
      for iele=1:this.discrete_.gNumEle('stiff');
        curele=this.discrete_.gElement('stiff',iele);
        nids=curele.gNodeIDs();
        numnode=curele.NumNode();
        numentries=numentries+1+numnode;
        cellstring=[cellstring,num2str(numnode),' ',num2str(nids-1,'%1d '),'\n'];
      end
      cellstring=[sprintf('CELLS %d %d \n',this.discrete_.gNumEle('stiff'),numentries),cellstring];%%HACK
      fprintf(fhandle,cellstring);
      consoleinfo([num2str(this.discrete_.gNumEle('stiff')),' elements written']);
      
      %% print cell type information
      fprintf(fhandle,'CELL_TYPES %d\n',this.discrete_.gNumEle('stiff'));
      for iele=1:this.discrete_.gNumEle('stiff')
        fprintf(fhandle,'%d ',this.VTKCellType(  class(this.discrete_.gElement('stiff',iele))   ));
      end
      fprintf(fhandle,'\n');
      
           
      %% write point data
      fprintf(fhandle,'POINT_DATA %d\n',this.discrete_.gNumNode() );
      numdof=this.discrete_.gNumDof();
      
           
      %write nodal scalars
      nodalscalars=outbuffer.gNodalScalars();
      for i1=1:length(nodalscalars)
        WriteData(this,fhandle,nodalscalars{i1}{2},'SCALARS','FLOAT',nodalscalars{i1}{1})
      end
          
      %write nodal vectors
      nodalvecs=outbuffer.gNodalVectors();
      for i1=1:length(nodalvecs)
        WriteData(this,fhandle,nodalvecs{i1}{2},'VECTORS','FLOAT',nodalvecs{i1}{1})
      end
      
      %% write cell data
      fprintf(fhandle,'CELL_DATA %d\n',this.discrete_.gNumEle('stiff') );
         
      %write element scalars
      elescalars=outbuffer.gElementScalars();
      for i1=1:length(elescalars)
        WriteData(this,fhandle,elescalars{i1}{2},'SCALARS','FLOAT',elescalars{i1}{1})
      end
      
      %write element vectors
      elevecs=outbuffer.gElementVectors();
      for i1=1:length(elevecs)
        WriteData(this,fhandle,elevecs{i1}{2},'VECTORS','FLOAT',elevecs{i1}{1})
      end
      
      %write element tensors
      elementvecs=outbuffer.gElementTensors();
      for i1=1:length(elementvecs)
        WriteData(this,fhandle,elementvecs{i1}{2},'TENSORS','FLOAT',elementvecs{i1}{1})
      end
           
      fclose(fhandle);
      consoleinfo(timestring(toc));
      consoleline('',true);
      
    end
    
    function [] = WriteData(this,fhandle,data,datatype,dataformat,dataname)
      %writes a specific data array
      validateattributes(data,{'numeric'},{'nonempty'}, 'WriteData','data',      2);
      validatestring(datatype,{'SCALARS','VECTORS','TENSORS'},'WriteData','datatype',  3);
      validatestring(dataformat,{'FLOAT'},              'WriteData','dataformat',4);
      validateattributes(dataname,{'char'},{'nonempty'},'WriteData','dataname',  5);
      
      %print decription line(s)
      fprintf(fhandle,[datatype,' ',dataname,' ',dataformat,'\n']);
      if strcmp(datatype,'SCALARS')
       fprintf(fhandle,'LOOKUP_TABLE default\n' );
      end

      %print data
      if strcmp(datatype,'TENSORS')
        for iter=1:size(data,1)
          matrix=[...
                  data(iter,1) data(iter,3) 0.0000000
                  data(iter,3) data(iter,2) 0
                             0              0 0];
          fprintf(fhandle, [repmat(' %d ', 1, size(matrix,2)) '\n'], full(matrix)');
          fprintf(fhandle,'\n');
        end
      else
        fprintf(fhandle, [repmat(' %d ', 1, size(data,2)) '\n'], full(data)');
      end
      
      consoleinfo(['field ',dataname,' ',datatype,' ',dataformat,' written']);
    end
       
  end
  
end