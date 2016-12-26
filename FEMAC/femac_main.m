function prob = femac_main(varargin)
%femac_main routine
%starts the calculation from a pre-genearated binary .dis-file
%outputs the primary solution to a .res-file

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
  
  %Read .dat-file
  this.datreader_= DATReader(datpath);
  [params,materials,condlist]=this.datreader_.Read();
  temp  = regexp(datpath,'(/|\\)\w*\.dat','split');
  temp  = regexp(datpath,'(/|\\)(\w|_|-)*\.dat','split');
  datdir= temp{1};
  
  %open log-file
  params.GENERAL.LOGFILE   = strrep(params.GENERAL.LOGFILE,   '<thisdir>', datdir);
  diary(params.GENERAL.LOGFILE);
  
  %print welcome-message to screen
  WelcomeMsg('main')
  
  switch params.GENERAL.PROBLEMTYPE
    case 'structure'
      prob=ProblemStructMain(params,datpath,materials,condlist,datdir);
    case 'feti'
      prob=ProblemFETIMain(params,datpath,materials,condlist,datdir);
    otherwise
      error(['Problemtype not recognized: ',params.GENERAL.PROBLEMTYPE]);
  end
  
  %do all necessary work
  prob.Work();
  
  %end logfile output
  diary off
  
end