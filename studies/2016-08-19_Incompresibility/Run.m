%clear
close all
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare


%% Perform calculations



files.planestrain.f1={...
          './plane_strain/feti1_1e1.dat'
          './plane_strain/feti1_1e2.dat'
          './plane_strain/feti1_1e3.dat'
          './plane_strain/feti1_1e4.dat'}'
        
files.planestrain.fs={...
          './plane_strain/fetis_1e1.dat'
          './plane_strain/fetis_1e2.dat'
          './plane_strain/fetis_1e3.dat'
          './plane_strain/fetis_1e4.dat'}'
        
files.planestrain.f2g={...
          './plane_strain/feti2g_1e1.dat'
          './plane_strain/feti2g_1e2.dat'
          './plane_strain/feti2g_1e3.dat'
          './plane_strain/feti2g_1e4.dat'}'
        

files.planestrain.fas={...
          './plane_strain/fetias_1e1.dat'
          './plane_strain/fetias_1e2.dat'
          './plane_strain/fetias_1e3.dat'
          './plane_strain/fetias_1e4.dat'}'

files.planestrain.ffas={...
          './plane_strain/fetifas_1e1.dat'
          './plane_strain/fetifas_1e2.dat'
          './plane_strain/fetifas_1e3.dat'
          './plane_strain/fetifas_1e4.dat'}'
        
        
        
files.planestress.f1={...
          './plane_stress/feti1_1e1.dat'
          './plane_stress/feti1_1e2.dat'
          './plane_stress/feti1_1e3.dat'
          './plane_stress/feti1_1e4.dat'}'
        
files.planestress.fs={...
          './plane_stress/fetis_1e1.dat'
          './plane_stress/fetis_1e2.dat'
          './plane_stress/fetis_1e3.dat'
          './plane_stress/fetis_1e4.dat'}'
        
files.planestress.f2g={...
          './plane_stress/feti2g_1e1.dat'
          './plane_stress/feti2g_1e2.dat'
          './plane_stress/feti2g_1e3.dat'
          './plane_stress/feti2g_1e4.dat'}'

files.planestress.fas={...
          './plane_stress/fetias_1e1.dat'
          './plane_stress/fetias_1e2.dat'
          './plane_stress/fetias_1e3.dat'
          './plane_stress/fetias_1e4.dat'}'
        
files.planestress.ffas={...
          './plane_stress/fetifas_1e1.dat'
          './plane_stress/fetifas_1e2.dat'
          './plane_stress/fetifas_1e3.dat'
          './plane_stress/fetifas_1e4.dat'}'




%% FETI-1 calculations
numiter.planestrain.f1=[];
res.planestrain.f1={};
prob=femac_pre(files.planestrain.f1{1})
for iter=files.planestrain.f1
  prob=femac_main(iter{:})
  numiter.planestrain.f1=[numiter.planestrain.f1,prob.solver_.numiter_];
  res.planestrain.f1{end+1}=prob.solver_.res_;
end

numiter.planestress.f1=[];
res.planestress.f1={};
prob=femac_pre(files.planestress.f1{1})
for iter=files.planestress.f1
  prob=femac_main(iter{:})
  numiter.planestress.f1=[numiter.planestress.f1,prob.solver_.numiter_];
  res.planestress.f1{end+1}=prob.solver_.res_;
end

%% FETI-2(Geneo) calculations
numiter.planestrain.f2g=[];
res.planestrain.f2g={};
%prob=femac_pre(files.planestrain.f2g{1}) %all problems in this row use the same mesh
for iter=files.planestrain.f2g
  prob=femac_main(iter{:})
  numiter.planestrain.f2g=[numiter.planestrain.f2g,prob.solver_.numiter_];
  res.planestrain.f2g{end+1}=prob.solver_.res_;
end

numiter.planestress.f2g=[];
res.planestress.f2g={};
%prob=femac_pre(files.planestress.f2g{1})
for iter=files.planestress.f2g
  prob=femac_main(iter{:})
  numiter.planestress.f2g=[numiter.planestress.f2g,prob.solver_.numiter_];
  res.planestress.f2g{end+1}=prob.solver_.res_;
end


%% FETI-S calculations
numiter.planestrain.fs=[];
numsdir.planestrain.fs={};
res.planestrain.fs={};
for iter=files.planestrain.fs
  prob=femac_main(iter{:})
  numiter.planestrain.fs=[numiter.planestrain.fs,prob.solver_.numiter_];
  numsdir.planestrain.fs{end+1}=prob.solver_.numsdir_;
  res.planestrain.fs{end+1}=prob.solver_.res_;
end

numsdir.planestrain.fs={};
for i=1:length(numiter.planestrain.fs)
  numsdir.planestrain.fs{end+1}=12*ones(1,numiter.planestrain.fs(i));
end


numiter.planestress.fs=[];
res.planestress.fs={};
%prob=femac_pre(files.planestress.fs{1})
for iter=files.planestress.fs
  prob=femac_main(iter{:})
  numiter.planestress.fs=[numiter.planestress.fs,prob.solver_.numiter_];
  res.planestress.fs{end+1}=prob.solver_.res_;
  
end



%% FETI-AS calculations
numiter.planestrain.fas=[];
numsdir.planestrain.fas={};
res.planestrain.fas={};
%prob=femac_pre(files.planestrain.ffas{1})
for iter=files.planestrain.fas
  prob=femac_main(iter{:})
  numiter.planestrain.fas=[numiter.planestrain.fas,prob.solver_.numiter_];
  numsdir.planestrain.fas{end+1}=prob.solver_.numsdir_;
  res.planestrain.fas{end+1}=prob.solver_.res_;
end

numiter.planestress.fas=[];
res.planestress.fas={};
%prob=femac_pre(files.planestress.ffas{1})
for iter=files.planestress.fas
  prob=femac_main(iter{:})
  numiter.planestress.fas=[numiter.planestress.fas,prob.solver_.numiter_];
  res.planestress.fas{end+1}=prob.solver_.res_;
end

%% FETI-FAS calculations
numiter.planestrain.ffas=[];
numsdir.planestrain.ffas={};
res.planestrain.ffas={};
%prob=femac_pre(files.planestrain.ffas{1})
for iter=files.planestrain.ffas
  prob=femac_main(iter{:})
  numiter.planestrain.ffas=[numiter.planestrain.ffas,prob.solver_.numiter_];
  numsdir.planestrain.ffas{end+1}=prob.solver_.numsdir_;
  res.planestrain.ffas{end+1}=prob.solver_.res_;
end

numiter.planestress.ffas=[];
res.planestress.ffas={};
%prob=femac_pre(files.planestress.ffas{1})
for iter=files.planestress.ffas
  prob=femac_main(iter{:})
  numiter.planestress.ffas=[numiter.planestress.ffas,prob.solver_.numiter_];
  res.planestress.ffas{end+1}=prob.solver_.res_;
end


%% Plotting
comp=[1e-1, 1e-2, 1e-3, 1e-4];
figure()
semilogx(comp,numiter.planestrain.f1,'-o',...
         comp,numiter.planestrain.f2g,'-o',...
         comp, numiter.planestrain.fs,'-o',...
         comp, numiter.planestrain.fas,'-o',...
         comp, numiter.planestrain.ffas,'-o');
legend('FETI-1','FETI-2(Geneo)','FETI-S')



%% Write output
csvwrite('./data/planestrain/numiter_feti1.txt',[comp',numiter.planestrain.f1']);
csvwrite('./data/planestrain/numiter_feti2g.txt',[comp',numiter.planestrain.f2g']);
csvwrite('./data/planestrain/numiter_fetis.txt',[comp',numiter.planestrain.fs']);
csvwrite('./data/planestrain/numiter_fetias.txt',[comp',numiter.planestrain.fas']);
csvwrite('./data/planestrain/numiter_fetifas.txt',[comp',numiter.planestrain.ffas']);

csvwrite('./data/planestress/numiter_feti1.txt',[comp',numiter.planestress.f1']);
csvwrite('./data/planestress/numiter_feti2g.txt',[comp',numiter.planestress.f2g']);
csvwrite('./data/planestress/numiter_fetis.txt',[comp',numiter.planestress.fs']);
csvwrite('./data/planestress/numiter_fetias.txt',[comp',numiter.planestress.fas']);
csvwrite('./data/planestress/numiter_fetifas.txt',[comp',numiter.planestress.ffas']);

incompfac={'1e1', '1e2', '1e3', '1e4'}

for i=1:4
% csvwrite(['./data/planestrain/numsdir_feti1_',  num2str(incompfac{i}),'.txt'],[(1:length(numsdir.planestrain.f1{i}))',  numsdir.planestrain.f1{i}']);
% csvwrite(['./data/planestrain/numsdir_feti2g_', num2str(incompfac{i}),'.txt'],[(1:length(numsdir.planestrain.f2g{i}))', numsdir.planestrain.f2g{i}']);
csvwrite(['./data/planestrain/numsdir_fetis_',  num2str(incompfac{i}),'.txt'],[(1:length(numsdir.planestrain.fs{i}))',  numsdir.planestrain.fs{i}']);
csvwrite(['./data/planestrain/numsdir_fetias_', num2str(incompfac{i}),'.txt'],[(1:length(numsdir.planestrain.fas{i}))', numsdir.planestrain.fas{i}']);
csvwrite(['./data/planestrain/numsdir_fetifas_',num2str(incompfac{i}),'.txt'],[(1:length(numsdir.planestrain.ffas{i}))',numsdir.planestrain.ffas{i}']);

csvwrite(['./data/planestrain/res_feti1_',  num2str(incompfac{i}),'.txt'],[(1:length(res.planestrain.f1{i}))',  res.planestrain.f1{i}']);
csvwrite(['./data/planestrain/res_feti2g_', num2str(incompfac{i}),'.txt'],[(1:length(res.planestrain.f2g{i}))', res.planestrain.f2g{i}']);
csvwrite(['./data/planestrain/res_fetis_',  num2str(incompfac{i}),'.txt'],[(1:length(res.planestrain.fs{i}))',  res.planestrain.fs{i}']);
csvwrite(['./data/planestrain/res_fetias_', num2str(incompfac{i}),'.txt'],[(1:length(res.planestrain.fas{i}))', res.planestrain.fas{i}']);
csvwrite(['./data/planestrain/res_fetifas_',num2str(incompfac{i}),'.txt'],[(1:length(res.planestrain.ffas{i}))',res.planestrain.ffas{i}']);

end
