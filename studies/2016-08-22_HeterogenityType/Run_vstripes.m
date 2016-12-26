% clear
% clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare
                  
                  
files.vstripes.eye.feti1={...
                    './vstripes/A_eye/feti1/tau1.dat'
                    './vstripes/A_eye/feti1/tau10.dat'
                    './vstripes/A_eye/feti1/tau100.dat'
                    './vstripes/A_eye/feti1/tau1000.dat'}'
                  
files.vstripes.eye.feti2g={...
                    './vstripes/A_eye/feti2g/tau1.dat'
                    './vstripes/A_eye/feti2g/tau10.dat'
                    './vstripes/A_eye/feti2g/tau100.dat'
                    './vstripes/A_eye/feti2g/tau1000.dat'}'
                  
files.vstripes.eye.fetis={...
                    './vstripes/A_eye/fetis/tau1.dat'
                    './vstripes/A_eye/fetis/tau10.dat'
                    './vstripes/A_eye/fetis/tau100.dat'
                    './vstripes/A_eye/fetis/tau1000.dat'}'
                  
files.vstripes.eye.fetias={...
                    './vstripes/A_eye/fetias/tau1.dat'
                    './vstripes/A_eye/fetias/tau10.dat'
                    './vstripes/A_eye/fetias/tau100.dat'
                    './vstripes/A_eye/fetias/tau1000.dat'}'
                  
files.vstripes.eye.fetifas={...
                    './vstripes/A_eye/fetifas/tau1.dat'
                    './vstripes/A_eye/fetifas/tau10.dat'
                    './vstripes/A_eye/fetifas/tau100.dat'
                    './vstripes/A_eye/fetifas/tau1000.dat'}'
                  
                  
                  
                  
                  
files.vstripes.precond.feti1={...
                    './vstripes/A_precond/feti1/tau1.dat'
                    './vstripes/A_precond/feti1/tau10.dat'
                    './vstripes/A_precond/feti1/tau100.dat'
                    './vstripes/A_precond/feti1/tau1000.dat'}'
                  
files.vstripes.precond.feti2g={...
                    './vstripes/A_precond/feti2g/tau1.dat'
                    './vstripes/A_precond/feti2g/tau10.dat'
                    './vstripes/A_precond/feti2g/tau100.dat'
                    './vstripes/A_precond/feti2g/tau1000.dat'}'
                  
files.vstripes.precond.fetis={...
                    './vstripes/A_precond/fetis/tau1.dat'
                    './vstripes/A_precond/fetis/tau10.dat'
                    './vstripes/A_precond/fetis/tau100.dat'
                    './vstripes/A_precond/fetis/tau1000.dat'}'
                  
files.vstripes.precond.fetias={...
                    './vstripes/A_precond/fetias/tau1.dat'
                    './vstripes/A_precond/fetias/tau10.dat'
                    './vstripes/A_precond/fetias/tau100.dat'
                    './vstripes/A_precond/fetias/tau1000.dat'}'
                  
files.vstripes.precond.fetifas={...
                    './vstripes/A_precond/fetifas/tau1.dat'
                    './vstripes/A_precond/fetifas/tau10.dat'
                    './vstripes/A_precond/fetifas/tau100.dat'
                    './vstripes/A_precond/fetifas/tau1000.dat'}'


%% Perform calculations

numiter.vstripes.eye.feti1=[];
res.vstripes.eye.feti1={};
femac_pre(files.vstripes.eye.feti1{1})
for iter=files.vstripes.eye.feti1
  prob=femac_main(iter{:})
  numiter.vstripes.eye.feti1=[numiter.vstripes.eye.feti1,prob.solver_.numiter_];
  res.vstripes.eye.feti1{end+1}=prob.solver_.res_;
end

numiter.vstripes.eye.feti2g=[];
res.vstripes.eye.feti2g={};
for iter=files.vstripes.eye.feti2g
  prob=femac_main(iter{:})
  numiter.vstripes.eye.feti2g=[numiter.vstripes.eye.feti2g,prob.solver_.numiter_];
  res.vstripes.eye.feti2g{end+1}=prob.solver_.res_;
end

numiter.vstripes.eye.fetis=[];
res.vstripes.eye.fetis={};
numsdir.vstripes.eye.fetis={};
for iter=files.vstripes.eye.fetis
  prob=femac_main(iter{:})
  numiter.vstripes.eye.fetis=[numiter.vstripes.eye.fetis,prob.solver_.numiter_];
  res.vstripes.eye.fetis{end+1}=prob.solver_.res_;
  numsdir.vstripes.eye.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
end

numiter.vstripes.eye.fetias=[];
res.vstripes.eye.fetias={};
numsdir.vstripes.eye.fetias={};
for iter=files.vstripes.eye.fetias
  prob=femac_main(iter{:})
  numiter.vstripes.eye.fetias=[numiter.vstripes.eye.fetias,prob.solver_.numiter_];
  res.vstripes.eye.fetias{end+1}=prob.solver_.res_;
  numsdir.vstripes.eye.fetias{end+1}=prob.solver_.numsdir_;
end

numiter.vstripes.eye.fetifas=[];
res.vstripes.eye.fetifas={};
numsdir.vstripes.eye.fetifas={};
for iter=files.vstripes.eye.fetifas
  prob=femac_main(iter{:})
  numiter.vstripes.eye.fetifas=[numiter.vstripes.eye.fetifas,prob.solver_.numiter_];
  res.vstripes.eye.fetifas{end+1}=prob.solver_.res_;
  numsdir.vstripes.eye.fetifas{end+1}=prob.solver_.numsdir_;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

numiter.vstripes.precond.feti1=[];
res.vstripes.precond.feti1={};
for iter=files.vstripes.precond.feti1
  prob=femac_main(iter{:})
  numiter.vstripes.precond.feti1=[numiter.vstripes.precond.feti1,prob.solver_.numiter_];
  res.vstripes.precond.feti1{end+1}=prob.solver_.res_;
end

numiter.vstripes.precond.feti2g=[];
res.vstripes.precond.feti2g={};
for iter=files.vstripes.precond.feti2g
  prob=femac_main(iter{:})
  numiter.vstripes.precond.feti2g=[numiter.vstripes.precond.feti2g,prob.solver_.numiter_];
  res.vstripes.precond.feti2g{end+1}=prob.solver_.res_;
end

numiter.vstripes.precond.fetis=[];
res.vstripes.precond.fetis={};
numsdir.vstripes.precond.fetis={};
for iter=files.vstripes.precond.fetis
  prob=femac_main(iter{:})
  numiter.vstripes.precond.fetis=[numiter.vstripes.precond.fetis,prob.solver_.numiter_];
  res.vstripes.precond.fetis{end+1}=prob.solver_.res_;
  numsdir.vstripes.precond.fetis{end+1}=16*ones(1,prob.solver_.numiter_);
end

numiter.vstripes.precond.fetias=[];
res.vstripes.precond.fetias={};
numsdir.vstripes.precond.fetias={};
for iter=files.vstripes.precond.fetias
  prob=femac_main(iter{:})
  numiter.vstripes.precond.fetias=[numiter.vstripes.precond.fetias,prob.solver_.numiter_];
  res.vstripes.precond.fetias{end+1}=prob.solver_.res_;
  numsdir.vstripes.precond.fetias{end+1}=prob.solver_.numsdir_;
end


numiter.vstripes.precond.fetifas=[];
res.vstripes.precond.fetifas={};
numsdir.vstripes.precond.fetifas={};
for iter=files.vstripes.precond.fetifas
  prob=femac_main(iter{:})
  numiter.vstripes.precond.fetifas=[numiter.vstripes.precond.fetifas,prob.solver_.numiter_];
  res.vstripes.precond.fetifas{end+1}=prob.solver_.res_;
  numsdir.vstripes.precond.fetifas{end+1}=prob.solver_.numsdir_;
end


tauvec=[1 10 100 1000];



% figure()
% loglog(tauvec,numiter.vstripes.feti1,'-o',...
%      tauvec,numiter.vstripes.feti2g,'-o',...
%      tauvec,numiter.vstripes.fetis,'-o')
% legend('FETI-1','FETI-2(Geneo)','FETI-S')
% title('vstripes')


%% numiter
csvwrite('./data/numiter_vstripes_Aeye_feti1.txt',[tauvec',numiter.vstripes.eye.feti1'])
csvwrite('./data/numiter_vstripes_Aeye_feti2g.txt',[tauvec',numiter.vstripes.eye.feti2g'])
csvwrite('./data/numiter_vstripes_Aeye_fetis.txt',[tauvec',numiter.vstripes.eye.fetis'])
csvwrite('./data/numiter_vstripes_Aeye_fetias.txt',[tauvec',numiter.vstripes.eye.fetias'])
csvwrite('./data/numiter_vstripes_Aeye_fetifas.txt',[tauvec',numiter.vstripes.eye.fetifas'])


csvwrite('./data/numiter_vstripes_Aprecond_feti1.txt',[tauvec',numiter.vstripes.precond.feti1'])
csvwrite('./data/numiter_vstripes_Aprecond_feti2g.txt',[tauvec',numiter.vstripes.precond.feti2g'])
csvwrite('./data/numiter_vstripes_Aprecond_fetis.txt',[tauvec',numiter.vstripes.precond.fetis'])
csvwrite('./data/numiter_vstripes_Aprecond_fetias.txt',[tauvec',numiter.vstripes.precond.fetias'])
csvwrite('./data/numiter_vstripes_Aprecond_fetifas.txt',[tauvec',numiter.vstripes.precond.fetifas'])



%% write numsdir
for i=1:4
  csvwrite(['./data/numsdir_vstripes_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.eye.fetis{i}')
  csvwrite(['./data/numsdir_vstripes_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.eye.fetias{i}')
  csvwrite(['./data/numsdir_vstripes_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.eye.fetifas{i}')

  csvwrite(['./data/numsdir_vstripes_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.precond.fetis{i}')
  csvwrite(['./data/numsdir_vstripes_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.precond.fetias{i}')
  csvwrite(['./data/numsdir_vstripes_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],numsdir.vstripes.precond.fetifas{i}')

  
  
  
  csvwrite(['./data/res_vstripes_Aeye_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.eye.feti1{i}) )',res.vstripes.eye.feti1{i}'])
  csvwrite(['./data/res_vstripes_Aeye_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.eye.feti2g{i}) )',res.vstripes.eye.feti2g{i}'])
  csvwrite(['./data/res_vstripes_Aeye_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.eye.fetis{i}) )',res.vstripes.eye.fetis{i}'])
  csvwrite(['./data/res_vstripes_Aeye_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.eye.fetias{i}))',res.vstripes.eye.fetias{i}'])
  csvwrite(['./data/res_vstripes_Aeye_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.eye.fetifas{i}) )',res.vstripes.eye.fetifas{i}'])

  csvwrite(['./data/res_vstripes_Aprecond_feti1_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.precond.feti1{i}) )',res.vstripes.precond.feti1{i}'])
  csvwrite(['./data/res_vstripes_Aprecond_feti2g_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.precond.feti2g{i}) )',res.vstripes.precond.feti2g{i}'])
  csvwrite(['./data/res_vstripes_Aprecond_fetis_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.precond.fetis{i}) )',res.vstripes.precond.fetis{i}'])
  csvwrite(['./data/res_vstripes_Aprecond_fetias_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.precond.fetias{i}) )',res.vstripes.precond.fetias{i}'])
  csvwrite(['./data/res_vstripes_Aprecond_fetifas_tau',num2str(tauvec(i)),'.txt'],[(1:length(res.vstripes.precond.fetifas{i}) )',res.vstripes.precond.fetifas{i}'])

end
