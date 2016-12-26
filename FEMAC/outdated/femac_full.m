function prob = femac_full(varargin)
%main femac routine

  close all
  clc
  WelcomeMsg()
  
  
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
  
  
  this.datreader_= DATReader(datpath);
  [params,materials,condlist]=this.datreader_.Read();
  temp  = regexp(datpath,'(/|\\)\w*\.dat','split');
  datdir= temp{1};

  
  switch params.GENERAL.PROBLEMTYPE
    case 'structure'
      probpre=ProblemStructPre(params,datpath,datdir);
      probmain=ProblemStructMain(params,datpath,materials,condlist,datdir);
    case 'feti'
      probpre=ProblemFETIPre(params,datpath,datdir);
      probmain=ProblemFETIMain(params,datpath,materials,condlist,datdir);
    otherwise
      error(['Problemtype not recognized: ',params.GENERAL.PROBLEMTYPE]);
  end
  
  probpre.Calc();
  probmain.Calc();
  
  diary off
  

end