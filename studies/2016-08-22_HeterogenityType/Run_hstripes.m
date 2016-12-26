% clear
% clc

femacdir = '../../FEMAC/'
addpath(femacdir)
                  
                  
files.hstripes.eye.feti1={...
                    './hstripes/A_eye/feti1/tau1.dat'
                    './hstripes/A_eye/feti1/tau10.dat'
                    './hstripes/A_eye/feti1/tau100.dat'
                    './hstripes/A_eye/feti1/tau1000.dat'}'
                  
files.hstripes.eye.feti2g={...
                    './hstripes/A_eye/feti2g/tau1.dat'
                    './hstripes/A_eye/feti2g/tau10.dat'
                    './hstripes/A_eye/feti2g/tau100.dat'
                    './hstripes/A_eye/feti2g/tau1000.dat'}'
                  
files.hstripes.eye.fetis={...
                    './hstripes/A_eye/fetis/tau1.dat'
                    './hstripes/A_eye/fetis/tau10.dat'
                    './hstripes/A_eye/fetis/tau100.dat'
                    './hstripes/A_eye/fetis/tau1000.dat'}'

files.hstripes.eye.fetias={...
                    './hstripes/A_eye/fetias/tau1.dat'
                    './hstripes/A_eye/fetias/tau10.dat'
                    './hstripes/A_eye/fetias/tau100.dat'
                    './hstripes/A_eye/fetias/tau1000.dat'}'
                  
files.hstripes.eye.fetifas={...
                    './hstripes/A_eye/fetifas/tau1.dat'
                    './hstripes/A_eye/fetifas/tau10.dat'
                    './hstripes/A_eye/fetifas/tau100.dat'
                    './hstripes/A_eye/fetifas/tau1000.dat'}'
                  
                  
                  
                  
                  
files.hstripes.precond.feti1={...
                    './hstripes/A_precond/feti1/tau1.dat'
                    './hstripes/A_precond/feti1/tau10.dat'
                    './hstripes/A_precond/feti1/tau100.dat'
                    './hstripes/A_precond/feti1/tau1000.dat'}'
                  
files.hstripes.precond.feti2g={...
                    './hstripes/A_precond/feti2g/tau1.dat'
                    './hstripes/A_precond/feti2g/tau10.dat'
                    './hstripes/A_precond/feti2g/tau100.dat'
                    './hstripes/A_precond/feti2g/tau1000.dat'}'
                  
files.hstripes.precond.fetis={...
                    './hstripes/A_precond/fetis/tau1.dat'
                    './hstripes/A_precond/fetis/tau10.dat'
                    './hstripes/A_precond/fetis/tau100.dat'
                    './hstripes/A_precond/fetis/tau1000.dat'}'
                  
files.hstripes.precond.fetias={...
                    './hstripes/A_precond/fetias/tau1.dat'
                    './hstripes/A_precond/fetias/tau10.dat'
                    './hstripes/A_precond/fetias/tau100.dat'
                    './hstripes/A_precond/fetias/tau1000.dat'}'
                  
files.hstripes.precond.fetifas={...
                    './hstripes/A_precond/fetifas/tau1.dat'
                    './hstripes/A_precond/fetifas/tau10.dat'
                    './hstripes/A_precond/fetifas/tau100.dat'
                    './hstripes/A_precond/fetifas/tau1000.dat'}'


%% Perform calculations

% feti1
numiter.hstripes.eye.feti1=[];
res.hstripes.eye.feti1={};
femac_pre(files.hstripes.eye.feti1{1})
for iter=files.hstripes.eye.feti1
  prob=femac_main(iter{:})
  numiter.hstripes.eye.feti1=[numiter.hstripes.eye.feti1,prob.solver_.numiter_];
  res.hstripes.eye.feti1{end+1}=prob.solver_.res_;
end

%feti2
numiter.hstripes.eye.feti2g=[];
res.hstripes.eye.feti2g={};
for iter=files.hstripes.eye.feti2g
  prob=femac_main(iter{:})
  numiter.hstripes.eye.feti2g=[numiter.hstripes.eye.feti2g,prob.solver_.numiter_];
  res.hstripes.eye.feti2g{end+1}=prob.solver_.res_;
end

%fetis
numiter.hstripes.eye.fetis=[];
res.hstripes.eye.fetis={};
numsdir.hstripes.eye.fetis={};
for iter=files.hstripes.eye.fetis
  prob=femac_main(iter{:})
  numiter.hstripes.eye.fetis=[numiter.hstripes.eye.fetis,prob.solver_.numiter_];
  res.hstripes.eye.fetis{end+1}=prob.solver_.res_;
  numsdir.hstripes.eye.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
end

% fetias
numiter.hstripes.eye.fetias=[];
res.hstripes.eye.fetias={};
numsdir.hstripes.eye.fetias={};
for iter=files.hstripes.eye.fetias
  prob=femac_main(iter{:})
  numiter.hstripes.eye.fetias=[numiter.hstripes.eye.fetias,prob.solver_.numiter_];
  res.hstripes.eye.fetias{end+1}=prob.solver_.res_;
  numsdir.hstripes.eye.fetias{end+1}=prob.solver_.numsdir_;
end

%fetifas
numiter.hstripes.eye.fetifas=[];
res.hstripes.eye.fetifas={};
numsdir.hstripes.eye.fetifas={};
for iter=files.hstripes.eye.fetifas
  prob=femac_main(iter{:})
  numiter.hstripes.eye.fetifas=[numiter.hstripes.eye.fetifas,prob.solver_.numiter_];
  res.hstripes.eye.fetifas{end+1}=prob.solver_.res_;
  numsdir.hstripes.eye.fetifas{end+1}=prob.solver_.numsdir_;
end






%feti1
numiter.hstripes.precond.feti1=[];
res.hstripes.precond.feti1={};
for iter=files.hstripes.precond.feti1
  prob=femac_main(iter{:})
  numiter.hstripes.precond.feti1=[numiter.hstripes.precond.feti1,prob.solver_.numiter_];
  res.hstripes.precond.feti1{end+1}=prob.solver_.res_;
end

%feti2g
numiter.hstripes.precond.feti2g=[];
res.hstripes.precond.feti2g={};
for iter=files.hstripes.precond.feti2g
  prob=femac_main(iter{:})
  numiter.hstripes.precond.feti2g=[numiter.hstripes.precond.feti2g,prob.solver_.numiter_];
  res.hstripes.precond.feti2g{end+1}=prob.solver_.res_;
end

%fetis
numiter.hstripes.precond.fetis=[];
res.hstripes.precond.fetis={};
numsdir.hstripes.precond.fetis={};
for iter=files.hstripes.precond.fetis
  prob=femac_main(iter{:})
  numiter.hstripes.precond.fetis=[numiter.hstripes.precond.fetis,prob.solver_.numiter_];
  res.hstripes.precond.fetis{end+1}=prob.solver_.res_;
  numsdir.hstripes.precond.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
end

% fetias
numiter.hstripes.precond.fetias=[];
res.hstripes.precond.fetias={};
numsdir.hstripes.precond.fetias={};
for iter=files.hstripes.precond.fetias
  prob=femac_main(iter{:})
  numiter.hstripes.precond.fetias=[numiter.hstripes.precond.fetias,prob.solver_.numiter_];
  res.hstripes.precond.fetias{end+1}=prob.solver_.res_;
  numsdir.hstripes.precond.fetias{end+1}=prob.solver_.numsdir_;
end

% fetifas
numiter.hstripes.precond.fetifas=[];
res.hstripes.precond.fetifas={};
numsdir.hstripes.precond.fetifas={};
for iter=files.hstripes.precond.fetifas
  prob=femac_main(iter{:})
  numiter.hstripes.precond.fetifas=[numiter.hstripes.precond.fetifas,prob.solver_.numiter_];
  res.hstripes.precond.fetifas{end+1}=prob.solver_.res_;
  numsdir.hstripes.precond.fetifas{end+1}=prob.solver_.numsdir_;
end



tauvec=[1 10 100 1000];


% figure()
% loglog(tauvec,numiter.hstripes.feti1,'-o',...
%      tauvec,numiter.hstripes.feti2g,'-o',...
%      tauvec,numiter.hstripes.fetis,'-o')
% legend('FETI-1','FETI-2(Geneo)','FETI-S')
% title('hstripes')

%% write numiter
csvwrite('./data/numiter_hstripes_Aeye_feti1.txt',[tauvec',numiter.hstripes.eye.feti1'])
csvwrite('./data/numiter_hstripes_Aeye_feti2g.txt',[tauvec',numiter.hstripes.eye.feti2g'])
csvwrite('./data/numiter_hstripes_Aeye_fetis.txt',[tauvec',numiter.hstripes.eye.fetis'])
csvwrite('./data/numiter_hstripes_Aeye_fetias.txt',[tauvec',numiter.hstripes.eye.fetias'])
csvwrite('./data/numiter_hstripes_Aeye_fetifas.txt',[tauvec',numiter.hstripes.eye.fetifas'])

csvwrite('./data/numiter_hstripes_Aprecond_feti1.txt',[tauvec',numiter.hstripes.precond.feti1'])
csvwrite('./data/numiter_hstripes_Aprecond_feti2g.txt',[tauvec',numiter.hstripes.precond.feti2g'])
csvwrite('./data/numiter_hstripes_Aprecond_fetis.txt',[tauvec',numiter.hstripes.precond.fetis'])
csvwrite('./data/numiter_hstripes_Aprecond_fetias.txt',[tauvec',numiter.hstripes.precond.fetias'])
csvwrite('./data/numiter_hstripes_Aprecond_fetifas.txt',[tauvec',numiter.hstripes.precond.fetifas'])




%% write numsdir
for i=1:4
  csvwrite(['./data/numsdir_hstripes_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.eye.fetis{i}')
  csvwrite(['./data/numsdir_hstripes_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.eye.fetias{i}')
  csvwrite(['./data/numsdir_hstripes_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.eye.fetifas{i}')


  csvwrite(['./data/numsdir_hstripes_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.precond.fetis{i}')
  csvwrite(['./data/numsdir_hstripes_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.precond.fetias{i}')
  csvwrite(['./data/numsdir_hstripes_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.hstripes.precond.fetifas{i}')
  
  csvwrite(['./data/res_hstripes_Aeye_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.eye.feti1{i}) )',res.hstripes.eye.feti1{i}'])
  csvwrite(['./data/res_hstripes_Aeye_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.eye.feti2g{i}) )',res.hstripes.eye.feti2g{i}'])
  csvwrite(['./data/res_hstripes_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.eye.fetis{i}) )',res.hstripes.eye.fetis{i}'])
  csvwrite(['./data/res_hstripes_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.eye.fetias{i}))',res.hstripes.eye.fetias{i}'])
  csvwrite(['./data/res_hstripes_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.eye.fetifas{i}) )',res.hstripes.eye.fetifas{i}'])

  csvwrite(['./data/res_hstripes_Aprecond_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.precond.feti1{i}) )',res.hstripes.precond.feti1{i}'])
  csvwrite(['./data/res_hstripes_Aprecond_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.precond.feti2g{i}) )',res.hstripes.precond.feti2g{i}'])
  csvwrite(['./data/res_hstripes_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.precond.fetis{i}) )',res.hstripes.precond.fetis{i}'])
  csvwrite(['./data/res_hstripes_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.precond.fetias{i}) )',res.hstripes.precond.fetias{i}'])
  csvwrite(['./data/res_hstripes_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.hstripes.precond.fetifas{i}) )',res.hstripes.precond.fetifas{i}'])

end
