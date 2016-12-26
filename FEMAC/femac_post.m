function prob = femac_post(varargin)
%femac_main routine
%starts the calculation from a pre-genearated binary .dis-file

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
  
  %read .dat-file
  this.datreader_= DATReader(datpath);
  [params,materials,condlist]=this.datreader_.Read();
  temp  = regexp(datpath,'(/|\\)\w*\.dat','split');
  temp  = regexp(datpath,'(/|\\)(\w|_|-)*\.dat','split');
  datdir= temp{1};
  
  %open log-file
  params.GENERAL.LOGFILE   = strrep(params.GENERAL.LOGFILE,   '<thisdir>', datdir);
  diary(params.GENERAL.LOGFILE);
    
  %print welcome-message to screen
  WelcomeMsg('post')
  
  switch params.GENERAL.PROBLEMTYPE
    case 'structure'
      prob=ProblemBasePost(params,datdir);
    case 'feti'
      prob=ProblemFETIPost(params,datdir);
    otherwise
      error(['Problemtype not recognized: ',params.GENERAL.PROBLEMTYPE]);
  end
  
  %do all neccessary work
  prob.Work();
  
  %end log-file output
  diary off 

end