function prob = femac(varargin)
%main femac routine
%reads the discretization from binary file and calcukates the primary
%solution

  close all
  clc
  prepare
%   WelcomeMsg()
  
  
  datpath = '';
  if length(varargin)==0
    [filename, pathname] = uigetfile('*.dat', 'Select a FEMAC dat-file');
    if isequal(filename,0)
       disp('User selected Cancel');
       return;
    else
       datpath=fullfile(pathname, filename);
       disp(['User selected ', datpath]);
       disp(' ');
    end
  else
    datpath=varargin{1};
  end
  

  datpath
  prob.pre =femac_pre(datpath);
  prob.main=femac_main(datpath);
  prob.post=femac_post(datpath);
  
  
  diary off
 

end