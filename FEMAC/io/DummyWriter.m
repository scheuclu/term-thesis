classdef DummyWriter
  %Writes calculation output to vtk-file
  
  properties
  end
  
  methods
    function this = DummyWriter(dis,filepath)
      
    end
      
    function [] = WriteFile(this,timestep)
      consoleline('START DUMMY WRITER',false);
      tic;
      toc;
      consoleline('DONE DUMMY WRITER',true);  
    end
           
  end
  
end