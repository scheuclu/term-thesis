classdef ConditionManager < handle
  %UNTITLED2 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties(Access=private)
    dis_
    condlist_
    materials_
    outbuffer_
  end
  
  methods
    function this = ConditionManager(dis,outbuffer,condlist,materials)
      this.dis_ = dis;
      this.outbuffer_=outbuffer;
      this.condlist_ = condlist;
      this.materials_=materials;
    end
    
    function this = ResolveAll(this)
      
      consoleline('START RESOLVING CONDITIONS',false);
      tic;
      
     for itercond=this.condlist_.kin
       if     isa(itercond{:},'ConditionNeumann')
         itercond{:}.Resolve(this.dis_,'neumann');
         consoleinfo(['resolving neumann   condition: ID:',num2str(itercond{:}.gID()),' MSHTAG:',num2str(itercond{:}.gTag())]);
       elseif isa(itercond{:},'ConditionDirichlet')
         itercond{:}.Resolve(this.dis_,'dirich');
         consoleinfo(['resolving dirichlet condition: ID:',num2str(itercond{:}.gID()),' MSHTAG:',num2str(itercond{:}.gTag())]);
       else
         error('unknown condition');
       end

       itercond{:}.Write(this.outbuffer_);%write condition indicator to output
     end
     
     
     
      %% Resolve material conditions
      %the purpose of this section is to write the material conditions to the
      %actual elements.
      %links are determined via the msh-tags
      for itercond=this.condlist_.mat
           itercond{:}.Resolve(this.dis_,this.materials_);
           itercond{:}.Write(this.outbuffer_);%write material indicator to output
      end
    
      consoleinfo(timestring(toc));
      consoleline('',true);
    end
  end
  
end

