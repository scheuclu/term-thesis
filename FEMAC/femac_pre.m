function prob = femac_pre(varargin)
%femac_pre routine
%reads the mesh-file, generates all Discretization object and writes the
%results to the .dis-file in binary format

  close all
  clc
  
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
  
  %read the .dat-file
  this.datreader_= DATReader(datpath);
  [params,materials,condlist]=this.datreader_.Read();
  %temp  = regexp(datpath,'(/|\\)\w*\.dat','split');
  temp  = regexp(datpath,'(/|\\)(\w|_|-)*\.dat','split');
  datdir= temp{1};
  
  
  params.GENERAL.LOGFILE   = strrep(params.GENERAL.LOGFILE,   '<thisdir>', datdir);
  
  %delete all entries in the diary file
  fid=fopen(params.GENERAL.LOGFILE,'wt');
  fclose(fid);
  
  %open diary
  diary(params.GENERAL.LOGFILE);
  
  %print welcome-message to screen
  WelcomeMsg('pre')
  
  %create preprocessing problem
  %same pre-processing for all problem-types
  prob=ProblemBasePre(params,datpath,datdir);
  
  %do all neccesary work
  prob.Work();
  
  diary off
  
end