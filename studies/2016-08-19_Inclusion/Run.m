%clear
close all
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare


%% Specify files



files_f1_0p9={...
          './feti1/feti1_incratio-0p9_stiffratio-0p001.dat'
          './feti1/feti1_incratio-0p9_stiffratio-1.dat'
          './feti1/feti1_incratio-0p9_stiffratio-1000.dat'}'
%         
files_fs_0p9={...
          './fetis/fetis_incratio-0p9_stiffratio-0p001.dat'
          './fetis/fetis_incratio-0p9_stiffratio-1.dat'
          './fetis/fetis_incratio-0p9_stiffratio-1000.dat'}'
%         
files_f2g_0p9={...
          './feti2g/feti2g_incratio-0p9_stiffratio-0p001.dat'
          './feti2g/feti2g_incratio-0p9_stiffratio-1.dat'
          './feti2g/feti2g_incratio-0p9_stiffratio-1000.dat'}'
        
files_fas_0p9={...
          './fetias/fetias_incratio-0p9_stiffratio-0p001.dat'
          './fetias/fetias_incratio-0p9_stiffratio-1.dat'
          './fetias/fetias_incratio-0p9_stiffratio-1000.dat'}'
        
files_ffas_0p9={...
          './fetifas/fetifas_incratio-0p9_stiffratio-0p001.dat'
          './fetifas/fetifas_incratio-0p9_stiffratio-1.dat'
          './fetifas/fetifas_incratio-0p9_stiffratio-1000.dat'}'
        
        
files_f1_0p95={...
          './feti1/feti1_incratio-0p95_stiffratio-0p001.dat'
          './feti1/feti1_incratio-0p95_stiffratio-1.dat'
          './feti1/feti1_incratio-0p95_stiffratio-1000.dat'}'
%         
files_fs_0p95={...
          './fetis/fetis_incratio-0p95_stiffratio-0p001.dat'
          './fetis/fetis_incratio-0p95_stiffratio-1.dat'
          './fetis/fetis_incratio-0p95_stiffratio-1000.dat'}'
% z        
files_f2g_0p95={...
          './feti2g/feti2g_incratio-0p95_stiffratio-0p001.dat'
          './feti2g/feti2g_incratio-0p95_stiffratio-1.dat'
          './feti2g/feti2g_incratio-0p95_stiffratio-1000.dat'}'
        
files_fas_0p95={...
          './fetias/fetias_incratio-0p95_stiffratio-0p001.dat'
          './fetias/fetias_incratio-0p95_stiffratio-1.dat'
          './fetias/fetias_incratio-0p95_stiffratio-1000.dat'}'
        
files_ffas_0p95={...
          './fetifas/fetifas_incratio-0p95_stiffratio-0p001.dat'
          './fetifas/fetifas_incratio-0p95_stiffratio-1.dat'
          './fetifas/fetifas_incratio-0p95_stiffratio-1000.dat'}'


        
stiffratio=[0.001 1 1000];



%% FETI-AS calculations
numiter_fas_0p9=[];
numsdir_fas_0p9={};
res_fas_0p9={};
femac_pre(files_fas_0p9{1});
for iter=files_fas_0p9
  prob=femac_main(iter{:});
  numiter_fas_0p9=[numiter_fas_0p9,prob.solver_.numiter_];
  numsdir_fas_0p9{end+1}=prob.solver_.numsdir_';
  res_fas_0p9{end+1}=prob.solver_.res_';
end

numiter_fas_0p95=[];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
numsdir_fas_0p95={};
res_fas_0p95={};
femac_pre(files_fas_0p95{1});
for iter=files_fas_0p95
  prob=femac_main(iter{:})
  numiter_fas_0p95=[numiter_fas_0p95,prob.solver_.numiter_];
  numsdir_fas_0p95{end+1}=prob.solver_.numsdir_';
  res_fas_0p95{end+1}=prob.solver_.res_';
end

%% FETI-FAS calculations
numiter_ffas_0p9=[];
numsdir_ffas_0p9={};
res_ffas_0p9={};
femac_pre(files_ffas_0p9{1});
for iter=files_ffas_0p9
  prob=femac_main(iter{:});
  numiter_ffas_0p9=[numiter_ffas_0p9,prob.solver_.numiter_];
  numsdir_ffas_0p9{end+1}=prob.solver_.numsdir_';
  res_ffas_0p9{end+1}=prob.solver_.res_';
end

numiter_ffas_0p95=[];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
numsdir_ffas_0p95={};
res_ffas_0p95={};
femac_pre(files_ffas_0p95{1});
for iter=files_ffas_0p95
  prob=femac_main(iter{:})
  numiter_ffas_0p95=[numiter_ffas_0p95,prob.solver_.numiter_];
  numsdir_ffas_0p95{end+1}=prob.solver_.numsdir_';
  res_ffas_0p95{end+1}=prob.solver_.res_';
end



%% FETI-1 calculations
numiter_f1_0p9=[];
res_f1_0p9={};
femac_pre(files_f1_0p9{1});
for iter=files_f1_0p9
  prob=femac_main(iter{:})
  numiter_f1_0p9=[numiter_f1_0p9,prob.solver_.numiter_];
  res_f1_0p9{end+1}=prob.solver_.res_';
end

numiter_f1_0p95=[];
res_f1_0p95={};
femac_pre(files_f1_0p95{1});
for iter=files_f1_0p95
  prob=femac_main(iter{:})
  numiter_f1_0p95=[numiter_f1_0p95,prob.solver_.numiter_];
  res_f1_0p95{end+1}=prob.solver_.res_';
end



%% FETI-2(Geneo) calculations
numiter_f2g_0p9=[];
res_f2g_0p9={};
femac_pre(files_f2g_0p9{1});
for iter=files_f2g_0p9
  prob=femac_main(iter{:})
  numiter_f2g_0p9=[numiter_f2g_0p9,prob.solver_.numiter_];
  res_f2g_0p9{end+1}=prob.solver_.res_';
end

numiter_f2g_0p95=[];
res_f2g_0p95={};
femac_pre(files_f2g_0p95{1});
for iter=files_f2g_0p95
  prob=femac_main(iter{:})
  numiter_f2g_0p95=[numiter_f2g_0p95,prob.solver_.numiter_];
  res_f2g_0p95{end+1}=prob.solver_.res_';
end



%% FETI-S calculations
numiter_fs_0p9=[];
res_fs_0p9={};
femac_pre(files_fs_0p9{1});
for iter=files_fs_0p9
  prob=femac_main(iter{:})
  numiter_fs_0p9=[numiter_fs_0p9,prob.solver_.numiter_];
  res_fs_0p9{end+1}=prob.solver_.res_';
end

numiter_fs_0p95=[];
res_fs_0p95={};
femac_pre(files_fs_0p95{1});
for iter=files_fs_0p95
  prob=femac_main(iter{:})
  numiter_fs_0p95=[numiter_fs_0p95,prob.solver_.numiter_];
  res_fs_0p95{end+1}=prob.solver_.res_';
end


close all



%% Plotting
figure()
semilogx(stiffratio,numiter_f1_0p9,'-o',...
         stiffratio,numiter_f2g_0p9,'-o',...
         stiffratio,numiter_fs_0p9,'-o');
title('Geometry Ratio 0.9')
%xlabel('Einc/Ebulk')
ylabel('$# iterations$')
legend('FETI-1','FETI-2(Geneo)','FETI-S')



%% Plotting
figure()
semilogx(stiffratio,numiter_f1_0p95,'-o',...
         stiffratio,numiter_f2g_0p95,'-o',...
         stiffratio,numiter_fs_0p95,'-o');
title('Geometry Ratio 0.95')
%xlabel('$\frac{E_{inclusion}}{E_{lattice}}$')
ylabel('$# iterations$')
legend('FETI-1','FETI-2(Geneo)','FETI-S')

%% Bar plots



figure()
y=[...
    numiter_f1_0p9(1) numiter_f2g_0p9(1)  numiter_fs_0p9(1)
    numiter_f1_0p9(2) numiter_f2g_0p9(2)  numiter_fs_0p9(2)
    numiter_f1_0p9(3) numiter_f2g_0p9(3)  numiter_fs_0p9(3)     ]
bar(y)
legend('FETI-1')
set(gca,'XTickLabel',{'stiffrat 0.001', 'stiffrat 1.0', 'stiffrat 1000'}')



% 
%% Write iteration numbers
csvwrite('./data/feti1_incratio-0p9.txt',[stiffratio',numiter_f1_0p9']);
csvwrite('./data/feti2g_incratio-0p9.txt',[stiffratio',numiter_f2g_0p9']);
csvwrite('./data/fetis_incratio-0p9.txt',[stiffratio',numiter_fs_0p9']);
csvwrite('./data/fetias_incratio-0p9.txt',[stiffratio',numiter_fas_0p9']);
csvwrite('./data/fetifas_incratio-0p9.txt',[stiffratio',numiter_ffas_0p9']);

csvwrite('./data/feti1_incratio-0p95.txt',[stiffratio',numiter_f1_0p95']);
csvwrite('./data/feti2g_incratio-0p95.txt',[stiffratio',numiter_f2g_0p95']);
csvwrite('./data/fetis_incratio-0p95.txt',[stiffratio',numiter_fs_0p95']);
csvwrite('./data/fetias_incratio-0p95.txt',[stiffratio',numiter_fas_0p95']);
csvwrite('./data/fetifas_incratio-0p95.txt',[stiffratio',numiter_ffas_0p95']);


stiffratios={'0p001', '1' , '1000' }

%% write number of search directions


for  i=1:3
  %fetias
  csvwrite(['./data/numsdir_fetias_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(numsdir_fas_0p9{i}))',numsdir_fas_0p9{i}]);
  csvwrite(['./data/numsdir_fetias_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(numsdir_fas_0p95{i}))',numsdir_fas_0p95{i}]);

  %fetifas
  csvwrite(['./data/numsdir_fetifas_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(numsdir_ffas_0p9{i}))',numsdir_ffas_0p9{i}]);
  csvwrite(['./data/numsdir_fetifas_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(numsdir_ffas_0p95{i}))',numsdir_ffas_0p95{i}]);

  %fetis
  csvwrite(['./data/numsdir_fetis_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:numiter_fs_0p9(i))',9*ones(numiter_fs_0p9(i),1)] );
  csvwrite(['./data/numsdir_fetis_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:numiter_fs_0p95(i))',9*ones(numiter_fs_0p95(i),1)]);

  
  
  
  %fetias
  csvwrite(['./data/res_fetias_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_fas_0p9{i}))',res_fas_0p9{i}]);
  csvwrite(['./data/res_fetias_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_fas_0p95{i}))',res_fas_0p95{i}]);

  %fetifas
  csvwrite(['./data/res_fetifas_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_ffas_0p9{i}))',res_ffas_0p9{i}]);
  csvwrite(['./data/res_fetifas_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_ffas_0p95{i}))',res_ffas_0p95{i}]);

  %fetis
  csvwrite(['./data/res_fetis_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_fs_0p9{i}))',res_fs_0p9{i}]);
  csvwrite(['./data/res_fetis_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_fs_0p95{i}))',res_fs_0p95{i}]);

  %feti1
  csvwrite(['./data/res_feti1_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_f1_0p9{i}))',res_f1_0p9{i}]);
  csvwrite(['./data/res_feti1_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_f1_0p95{i}))',res_f1_0p95{i}]);

  %feti2g
  csvwrite(['./data/res_feti2g_incratio-0p9_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_f2g_0p9{i}))',res_f2g_0p9{i}]);
  csvwrite(['./data/res_feti2g_incratio-0p95_stiffratio-',num2str(stiffratios{i}),'.txt'],[(1:length(res_f2g_0p95{i}))',res_f2g_0p95{i}]);

end

