% clear
% clc

femacdir = '../../FEMAC/'
addpath(femacdir)
                  
                  
files.cboard.eye.feti1={...
                    './cboard/A_eye/feti1/tau1.dat'
                    './cboard/A_eye/feti1/tau10.dat'
                    './cboard/A_eye/feti1/tau100.dat'
                    './cboard/A_eye/feti1/tau1000.dat'}'
                  
files.cboard.eye.feti2g={...
                    './cboard/A_eye/feti2g/tau1.dat'
                    './cboard/A_eye/feti2g/tau10.dat'
                    './cboard/A_eye/feti2g/tau100.dat'
                    './cboard/A_eye/feti2g/tau1000.dat'}'
                  
files.cboard.eye.fetis={...
                    './cboard/A_eye/fetis/tau1.dat'
                    './cboard/A_eye/fetis/tau10.dat'
                    './cboard/A_eye/fetis/tau100.dat'
                    './cboard/A_eye/fetis/tau1000.dat'}'

files.cboard.eye.fetias={...
                    './cboard/A_eye/fetias/tau1.dat'
                    './cboard/A_eye/fetias/tau10.dat'
                    './cboard/A_eye/fetias/tau100.dat'
                    './cboard/A_eye/fetias/tau1000.dat'}'
                  
files.cboard.eye.fetifas={...
                    './cboard/A_eye/fetifas/tau1.dat'
                    './cboard/A_eye/fetifas/tau10.dat'
                    './cboard/A_eye/fetifas/tau100.dat'
                    './cboard/A_eye/fetifas/tau1000.dat'}'
                  

                  
                  
files.cboard.precond.feti1={...
                    './cboard/A_precond/feti1/tau1.dat'
                    './cboard/A_precond/feti1/tau10.dat'
                    './cboard/A_precond/feti1/tau100.dat'
                    './cboard/A_precond/feti1/tau1000.dat'}'
                  
files.cboard.precond.feti2g={...
                    './cboard/A_precond/feti2g/tau1.dat'
                    './cboard/A_precond/feti2g/tau10.dat'
                    './cboard/A_precond/feti2g/tau100.dat'
                    './cboard/A_precond/feti2g/tau1000.dat'}'
                  
files.cboard.precond.fetis={...
                    './cboard/A_precond/fetis/tau1.dat'
                    './cboard/A_precond/fetis/tau10.dat'
                    './cboard/A_precond/fetis/tau100.dat'
                    './cboard/A_precond/fetis/tau1000.dat'}'
                  
files.cboard.precond.fetias={...
                    './cboard/A_precond/fetias/tau1.dat'
                    './cboard/A_precond/fetias/tau10.dat'
                    './cboard/A_precond/fetias/tau100.dat'
                    './cboard/A_precond/fetias/tau1000.dat'}'
                  
files.cboard.precond.fetifas={...
                    './cboard/A_precond/fetifas/tau1.dat'
                    './cboard/A_precond/fetifas/tau10.dat'
                    './cboard/A_precond/fetifas/tau100.dat'
                    './cboard/A_precond/fetifas/tau1000.dat'}'

%% Perform calculations

% feti1
numiter.cboard.eye.feti1=[];
femac_pre(files.cboard.eye.feti1{1})
res.cboard.eye.feti1={};
for iter=files.cboard.eye.feti1
  prob=femac_main(iter{:})
  numiter.cboard.eye.feti1=[numiter.cboard.eye.feti1,prob.solver_.numiter_];
  res.cboard.eye.feti1{end+1}=prob.solver_.res_;
end

% feti2
numiter.cboard.eye.feti2g=[];
res.cboard.eye.feti2g=[];
for iter=files.cboard.eye.feti2g
  prob=femac_main(iter{:})
  numiter.cboard.eye.feti2g=[numiter.cboard.eye.feti2g,prob.solver_.numiter_];
  res.cboard.eye.feti2g{end+1}=prob.solver_.res_;
end

% fetis
numiter.cboard.eye.fetis=[];
res.cboard.eye.fetis={};
numsdir.cboard.eye.fetis={};
for iter=files.cboard.eye.fetis
  prob=femac_main(iter{:})
  numiter.cboard.eye.fetis=[numiter.cboard.eye.fetis,prob.solver_.numiter_];
  numsdir.cboard.eye.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
  res.cboard.eye.fetis{end+1}=prob.solver_.res_;
end

% fetias
numiter.cboard.eye.fetias=[];
res.cboard.eye.fetias={};
numsdir.cboard.eye.fetias={};
for iter=files.cboard.eye.fetias
  prob=femac_main(iter{:})
  numiter.cboard.eye.fetias=[numiter.cboard.eye.fetias,prob.solver_.numiter_];
  numsdir.cboard.eye.fetias{end+1}=prob.solver_.numsdir_;
  res.cboard.eye.fetias{end+1}=prob.solver_.res_;
end

% fetifas
numiter.cboard.eye.fetifas=[];
res.cboard.eye.fetifas={};
numsdir.cboard.eye.fetifas={};
for iter=files.cboard.eye.fetifas
  prob=femac_main(iter{:})
  numiter.cboard.eye.fetifas=[numiter.cboard.eye.fetifas,prob.solver_.numiter_];
  numsdir.cboard.eye.fetifas{end+1}=prob.solver_.numsdir_;
  res.cboard.eye.fetifas{end+1}=prob.solver_.res_;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% feti1
numiter.cboard.precond.feti1=[];
res.cboard.precond.feti1={};
for iter=files.cboard.precond.feti1
  prob=femac_main(iter{:})
  numiter.cboard.precond.feti1=[numiter.cboard.precond.feti1,prob.solver_.numiter_];
  res.cboard.precond.feti1{end+1}=prob.solver_.res_;
end


% feti2
numiter.cboard.precond.feti2g=[];
res.cboard.precond.feti2g={};
for iter=files.cboard.precond.feti2g
  prob=femac_main(iter{:})
  numiter.cboard.precond.feti2g=[numiter.cboard.precond.feti2g,prob.solver_.numiter_];
  res.cboard.precond.feti2g{end+1}=prob.solver_.res_;
end


% fetis
numiter.cboard.precond.fetis=[];
res.cboard.precond.fetis={};
numsdir.cboard.precond.fetis={};
for iter=files.cboard.precond.fetis
  prob=femac_main(iter{:})
  numiter.cboard.precond.fetis=[numiter.cboard.precond.fetis,prob.solver_.numiter_];
  numsdir.cboard.precond.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
  res.cboard.precond.fetis{end+1}=prob.solver_.res_;
end


% fetias
numiter.cboard.precond.fetias=[];
res.cboard.precond.fetias={};
numsdir.cboard.precond.fetias={};
for iter=files.cboard.precond.fetias
  prob=femac_main(iter{:})
  numiter.cboard.precond.fetias=[numiter.cboard.precond.fetias,prob.solver_.numiter_];
  numsdir.cboard.precond.fetias{end+1}=prob.solver_.numsdir_;
  res.cboard.precond.fetias{end+1}=prob.solver_.res_;
end


% fetifas
numiter.cboard.precond.fetifas=[];
res.cboard.precond.fetifas={};
numsdir.cboard.precond.fetifas={};
for iter=files.cboard.precond.fetifas
  prob=femac_main(iter{:})
  numiter.cboard.precond.fetifas=[numiter.cboard.precond.fetifas,prob.solver_.numiter_];
  numsdir.cboard.precond.fetifas{end+1}=prob.solver_.numsdir_;
  res.cboard.precond.fetifas{end+1}=prob.solver_.res_;
end


tauvec=[1 10 100 1000];


% 
% figure()
% loglog(tauvec,numiter.cboard.feti1,'-o',...
%      tauvec,numiter.cboard.feti2g,'-o',...
%      tauvec,numiter.cboard.fetis,'-o')
% legend('FETI-1','FETI-2(Geneo)','FETI-S')
% title('cboard')


%% write numiter
csvwrite('./data/numiter_cboard_Aeye_feti1.txt',[tauvec',numiter.cboard.eye.feti1'])
csvwrite('./data/numiter_cboard_Aeye_feti2g.txt',[tauvec',numiter.cboard.eye.feti2g'])
csvwrite('./data/numiter_cboard_Aeye_fetis.txt',[tauvec',numiter.cboard.eye.fetis'])
csvwrite('./data/numiter_cboard_Aeye_fetias.txt',[tauvec',numiter.cboard.eye.fetias'])
csvwrite('./data/numiter_cboard_Aeye_fetifas.txt',[tauvec',numiter.cboard.eye.fetifas'])

csvwrite('./data/numiter_cboard_Aprecond_feti1.txt',[tauvec',numiter.cboard.precond.feti1'])
csvwrite('./data/numiter_cboard_Aprecond_feti2g.txt',[tauvec',numiter.cboard.precond.feti2g'])
csvwrite('./data/numiter_cboard_Aprecond_fetis.txt',[tauvec',numiter.cboard.precond.fetis'])
csvwrite('./data/numiter_cboard_Aprecond_fetias.txt',[tauvec',numiter.cboard.precond.fetias'])
csvwrite('./data/numiter_cboard_Aprecond_fetifas.txt',[tauvec',numiter.cboard.precond.fetifas'])


%% write numsdir
for i=1:4
  csvwrite(['./data/numsdir_cboard_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.eye.fetis{i}')
  csvwrite(['./data/numsdir_cboard_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.eye.fetias{i}')
  csvwrite(['./data/numsdir_cboard_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.eye.fetifas{i}')


  csvwrite(['./data/numsdir_cboard_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.precond.fetis{i}')
  csvwrite(['./data/numsdir_cboard_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.precond.fetias{i}')
  csvwrite(['./data/numsdir_cboard_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.cboard.precond.fetifas{i}')
  
  
csvwrite(['./data/res_cboard_Aeye_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.eye.feti1{i}) )',res.cboard.eye.feti1{i}'])
csvwrite(['./data/res_cboard_Aeye_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.eye.feti2g{i}) )',res.cboard.eye.feti2g{i}'])
csvwrite(['./data/res_cboard_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.eye.fetis{i}) )',res.cboard.eye.fetis{i}'])
csvwrite(['./data/res_cboard_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.eye.fetias{i}))',res.cboard.eye.fetias{i}'])
csvwrite(['./data/res_cboard_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.eye.fetifas{i}) )',res.cboard.eye.fetifas{i}'])

csvwrite(['./data/res_cboard_Aprecond_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.precond.feti1{i}) )',res.cboard.precond.feti1{i}'])
csvwrite(['./data/res_cboard_Aprecond_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.precond.feti2g{i}) )',res.cboard.precond.feti2g{i}'])
csvwrite(['./data/res_cboard_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.precond.fetis{i}) )',res.cboard.precond.fetis{i}'])
csvwrite(['./data/res_cboard_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.precond.fetias{i}) )',res.cboard.precond.fetias{i}'])
csvwrite(['./data/res_cboard_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.cboard.precond.fetifas{i}) )',res.cboard.precond.fetifas{i}'])

end

%write
