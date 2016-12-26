classdef DISReader < handle
 %readas information from msh-file to femac
  
  properties(Access=private)
    dis_@Discretization  %discretization object
    filepath_ = '<choose>'    %filepath of msh-file    
  end
  
  methods(Access=public)
    function this = DISReader(dis,filepath)
      %constructor for MSHReader @scheucher 07/16
      validateattributes(filepath,{'char'},{'nonempty'},'MSHReader','filepath',  1);
      %%validateattributes(tagtypes,{'struct'},{isfield(tagtypes,'DIRICH'),isfield(tagtypes,'NEUMANN'),isfield(tagtypes,'MATERIAL')},'MSHReader','tagtypes',  2);
      
      this.dis_=dis;
      this.filepath_=filepath;
    end
     
    function [] = ReadMesh(this)
      %reads the mesh, creates all element objects and links them to the
      %Discretization object @scheucher 05/16
      
      consoleline('START DIS READING',false);
      tic;
      
      %aaa=load(this.filepath_,'-mat');
      tmp=load(this.filepath_,'-mat');
      tmp=tmp.dis;
      
      
      this.dis_.dim_=tmp.dim_;
      this.dis_.nodes_ =tmp.nodes_;
    
      this.dis_.stiffele_  =tmp.stiffele_;
      this.dis_.neumannele_=tmp.neumannele_;
      this.dis_.dirichele_ =tmp.dirichele_;
      
      this.dis_.numdof_    =tmp.numdof_;
      this.dis_.outbuffer_ =tmp.outbuffer_;
     
      
      consoleinfo(timestring(toc));
      consoleline('',true);
      
    end%end function ReadMesh
    
    function [] = SaveDis(this)
      save(this.dis_.GENERAL.DISPATH,'dis','-mat');
    end
    
  end%end methods

end

