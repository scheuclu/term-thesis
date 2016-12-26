classdef MatlabPlot < handle
  %visualizes geometry and BCs with matlab
  
  properties
    dis_
    
    % default parameters
    params_
  end
  
  methods
    
    function this = MatlabPlot(dis)
      this.dis_=dis;
      this.Reset();
    end
    
    function [] = Reset(this)
      this.params_=struct('PLOTEVERY',   1,...
                         'PLOTGEO',     true,...
                         'PLOTBC',      true,...
                         'LABNODES',    true,...
                         'LABELE',      true,...
                         'GRID',        'off',...
                         'AXIS',        'off',...
                         'EDGECOLOR',   [0 0 0],...
                         'NODECOLOR',   [0 0 0],...
                         'SURFCOLOR',   [0.8 0.8 0.8],...
                         'DIRICHCOLOR', [0 1 0],...
                         'NEUMANNCOLOR',[1 0 0],...
                         'FACEALPHA',    1.0           );
    end
    
    
    function [] = SetParams(this,plotparams)

      for curfieldname=fieldnames(plotparams)'
        this.params_=setfield(this.params_, curfieldname{:}, getfield(plotparams,curfieldname{:}));
      end

    end
    
    function [] = Set(this, field, value)
      
      if isfield(this.params_,field)==0
        error(['<',field,'> is not a valid Parmaeter for MatlabPlot']);
      else
        this.params_=setfield(this.params_,field,value);
        %this.params_.field=value;
      end
      
    end
    
    function [f] = PlotAll(this,f)
      
      geoelelist={};
      dirichelelist={};
      neumannelelist={};
      
      if this.params_.PLOTGEO==true
       geoelelist=this.dis_.gEleList('stiff');
      end
      
      if this.params_.PLOTBC==true
        dirichelelist=this.dis_.gEleList('dirich');
        neumannelelist=this.dis_.gEleList('neumann');
      end
      
      this.PlotPart(f,geoelelist,dirichelelist,neumannelelist);
      
      
    end
    
    
    function [f] = PlotPart(this,f,geoelelist,dirichelelist,neumannelelist)
        
      consoleline('MATLAB PLOT',false);
      tic;
      consoleinfo(['Number of geometry elements:  ',num2str(length(geoelelist))]);
      consoleinfo(['Number of dirichlet elements: ',num2str(length(dirichelelist))]);
      consoleinfo(['Number of neumann elements:   ',num2str(length(neumannelelist))]);
      figure(f);
      hold on
      grid(gca,this.params_.GRID);
      axis(gca,this.params_.AXIS);
      axis equal

% %       geoelelist={};
% %       dirichelelist={};
% %       neumannelelist={};
% %       
% %       if this.params_.PLOTGEO==true
% %        geoelelist=this.dis_.gEleList('stiff');
% %       end
% %       
% %       if this.params_.PLOTBC==true
% %         dirichelelist=this.dis_.gEleList('dirich');
% %         neumannelelist=this.dis_.gEleList('neumann');
% %       end
      
      %% plot geometric elements
      for iter=1:length(geoelelist)
        
        %get element information
        curele=geoelelist{iter};
        curedges=curele.gEdges();
        curpolys=curele.gPolygons();
        curnodes=curele.gNodes();

        if this.params_.PLOTGEO
          
          for iter2=1:size(curpolys,1)
            % plotting the surface
            xvec=zeros(1,length(curpolys(iter2,:)));
            yvec=zeros(1,length(curpolys(iter2,:)));
            zvec=zeros(1,length(curpolys(iter2,:)));
            for iter3=1:length(curpolys(iter2,:))
              xvec(iter3)=curnodes( curpolys(iter2,iter3) ).X();
              yvec(iter3)=curnodes( curpolys(iter2,iter3) ).Y();
              zvec(iter3)=curnodes( curpolys(iter2,iter3) ).Z();
            end
            fill3(xvec,yvec,zvec,this.params_.SURFCOLOR,'FaceAlpha',this.params_.FACEALPHA);
          end

           
            
          % plotting the edges
          for iter2=1:size(curedges,1)
            curedges(iter2,1);
            curele.gNode(curedges(iter2,1));
            plot3([curele.gNode(curedges(iter2,1)).X(),curele.gNode(curedges(iter2,2)).X()],...
                  [curele.gNode(curedges(iter2,1)).Y(),curele.gNode(curedges(iter2,2)).Y()],...
                  [curele.gNode(curedges(iter2,1)).Z(),curele.gNode(curedges(iter2,2)).Z()],'-','color',this.params_.EDGECOLOR);
          end
        end
        
        if this.params_.LABELE
          xpos=0;
          ypos=0;
          zpos=0;
          for iter2=curnodes
            xpos=xpos+iter2.X();
            ypos=ypos+iter2.Y();
            zpos=zpos+iter2.Z();
          end
          xpos=xpos/curele.NumNode();
          ypos=ypos/curele.NumNode();
          zpos=zpos/curele.NumNode();

          text(xpos,ypos,zpos,num2str(curele.gID()),'Color',this.params_.SURFCOLOR,'Backgroundcolor',[1 1 1],'EdgeColor',this.params_.SURFCOLOR,'LineStyle','--');     
        end
        
       %error('asdasd') 
      end      
 
      %plot nodes
      for iter=this.dis_.gNodes( 1:this.dis_.gNumNode() )
%         if this.params_.PLOTGEO
%           plot3(iter.X(),iter.Y(),iter.Z(),'o','color',this.params_.EDGECOLOR);
%         end
        
        if this.params_.LABNODES
          text(iter.X(), iter.Y(), iter.Z(), num2str(iter.gID()),...
          'BackgroundColor',[1 1 1],'EdgeColor',this.params_.EDGECOLOR);
        end
      end
      

      %% plot dirichlet elements
      for iter=1:length(dirichelelist)
        
        %get element information
        curele=dirichelelist{iter};
        curedges=curele.gEdges();
        curpolys=curele.gPolygons();
        curnodes=curele.gNodes();

        if this.params_.PLOTGEO
          
          
          for iter2=1:size(curpolys,1)
            % plotting the surface
            xvec=zeros(1,length(curpolys(iter2,:)));
            yvec=zeros(1,length(curpolys(iter2,:)));
            zvec=zeros(1,length(curpolys(iter2,:)));
            for iter3=1:length(curpolys(iter2,:))
              xvec(iter3)=curnodes( curpolys(iter2,iter3) ).X();
              yvec(iter3)=curnodes( curpolys(iter2,iter3) ).Y();
              zvec(iter3)=curnodes( curpolys(iter2,iter3) ).Z();
            end
            fill3(xvec,yvec,zvec,this.params_.DIRICHCOLOR);
          end

          % plotting the edges
          for iter2=1:size(curedges,1)
            curedges(iter2,1);
            curele.gNode(curedges(iter2,1));
            plot3([curele.gNode(curedges(iter2,1)).X(),curele.gNode(curedges(iter2,2)).X()],...
                  [curele.gNode(curedges(iter2,1)).Y(),curele.gNode(curedges(iter2,2)).Y()],...
                  [curele.gNode(curedges(iter2,1)).Z(),curele.gNode(curedges(iter2,2)).Z()],'-','color',this.params_.DIRICHCOLOR);
          end
        end
       
        %plot nodes
        for iter=curele.gNodes()
          if this.params_.PLOTGEO
            plot3(iter.X(),iter.Y(),iter.Z(),'o','color',this.params_.DIRICHCOLOR);
          end

          if this.params_.LABNODES
          text(iter.X(), iter.Y(), iter.Z(), num2str(iter.gID()),...
            'BackgroundColor',[1 1 1],'EdgeColor',this.params_.DIRICHCOLOR);
          end
        end
       
       
       
      end
      
      
      %% plot neumann elements
      for iter=1:length(neumannelelist)
        
        %get element information
        curele=neumannelelist{iter};
        curedges=curele.gEdges();
        curpolys=curele.gPolygons();
        curnodes=curele.gNodes();

        if this.params_.PLOTGEO

          for iter2=1:size(curpolys,1)
            % plotting the surface
            xvec=zeros(1,length(curpolys(iter2,:)));
            yvec=zeros(1,length(curpolys(iter2,:)));
            zvec=zeros(1,length(curpolys(iter2,:)));
            for iter3=1:length(curpolys(iter2,:))
              xvec(iter3)=curnodes( curpolys(iter2,iter3) ).X();
              yvec(iter3)=curnodes( curpolys(iter2,iter3) ).Y();
              zvec(iter3)=curnodes( curpolys(iter2,iter3) ).Z();
            end
            fill3(xvec,yvec,zvec,this.params_.NEUMANNCOLOR);
          end

          % plotting the edges
          for iter2=1:size(curedges,1)
            curedges(iter2,1);
            curele.gNode(curedges(iter2,1));
            plot3([curele.gNode(curedges(iter2,1)).X(),curele.gNode(curedges(iter2,2)).X()],...
                  [curele.gNode(curedges(iter2,1)).Y(),curele.gNode(curedges(iter2,2)).Y()],...
                  [curele.gNode(curedges(iter2,1)).Z(),curele.gNode(curedges(iter2,2)).Z()],'-','color',this.params_.NEUMANNCOLOR);
          end
        end
       
        %plot nodes
        for iter=curele.gNodes()
%           if this.params_.PLOTGEO
%             plot3(iter.X(),iter.Y(),iter.Z(),'o','color',this.params_.NEUMANNCOLOR);
%           end

          if this.params_.LABNODES
          text(iter.X(), iter.Y(), iter.Z(), num2str(iter.gID()),...
            'BackgroundColor',[1 1 1],'EdgeColor',this.params_.NEUMANNCOLOR);
          end
        end
       
       
       
      end 
      
      consoleinfo(timestring(toc));
      consoleline('',true);
    end
      
  end
   
end

