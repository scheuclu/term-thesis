% close all
% clear
% clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Ts developement fetis
 files.taudevelopment={...
  './taudevelopment/chaco_fetis.dat'
  './taudevelopment/chaco_feti2.dat'}'


prob_fetis=femac(files.taudevelopment{1})
ts.fetis=prob_fetis.main.solver_.ts_
ressub.fetis=prob_fetis.main.solver_.ressub_

csvwrite('./data/ts_fetis.txt',[[1:size(ts.fetis,1)]',ts.fetis])


 %% study of tau development FETI-S
 %TODO this must be done with a fetis solver
 figure()
 semilogy(1:size(ts.fetis,1),ts.fetis(:,1),'-o')
 hold on
 semilogy(1:size(ts.fetis,1),ts.fetis(:,2),'-o')
 semilogy(1:size(ts.fetis,1),ts.fetis(:,3),'-o')
 
 legend('iteration 1', 'iteration 2', 'iteration 3')
 
  %% study of residuum development FETI-S
 %TODO this must be done with a fetis solver
 figure()
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,2),'-o')
 hold on
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,3),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,4),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,5),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,6),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,7),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,8),'-o')
 semilogy(1:size(ressub.fetis,1),ressub.fetis(:,9),'-o')
 
 title('residuum')
 legend('iteration 1', 'iteration 2', 'iteration 3')
 
 %% study of tau development FETI-S
 %TODO this must be done with a fetis solver
 figure()
 subplot(4,1,1)
 plot(1:size(ts.fetis,1),ts.fetis(:,2)-ts.fetis(:,1),'-o',...
      1:size(ts.fetis,1),ts.fetis(:,2)*0,'--')
 subplot(4,1,2)
 plot(1:size(ts.fetis,1),ts.fetis(:,3)-ts.fetis(:,2),'-o',...
      1:size(ts.fetis,1),ts.fetis(:,2)*0,'--')
 subplot(4,1,3)
 plot(1:size(ts.fetis,1),ts.fetis(:,4)-ts.fetis(:,3),'-o',...
      1:size(ts.fetis,1),ts.fetis(:,2)*0,'--')
 subplot(4,1,4)
 plot(1:size(ts.fetis,1),ts.fetis(:,8)-ts.fetis(:,7),'-o',...
      1:size(ts.fetis,1),ts.fetis(:,2)*0,'--')
 
 legend('iteration 1', 'iteration 2', 'iteration 3')

 
%% study of ts scattering in a fetis simulation
 
figure()
p=semilogy(1:size(ts.fetis,1),ts.fetis(:,1),'-o',...
           1:size(ts.fetis,1),ts.fetis(:,5),'-',...
           1:size(ts.fetis,1),ts.fetis(:,7),'-o',...
           1:size(ts.fetis,1),ts.fetis(:,15),'-o')
legend('1','5','7','11')
title('ts FETI-S')
set(p,'LineWidth',2)

figure()
p=semilogy(  1:size(ressub.fetis),ressub.fetis(:,2),'-o',...
         1:size(ressub.fetis,1),ressub.fetis(:,5),'-o',...
         1:size(ressub.fetis,1),ressub.fetis(:,7),'-o',...
         1:size(ressub.fetis,1),ressub.fetis(:,15),'-o')
legend('2','5','7','11')
title('resub FETI-S')
set(p,'LineWidth',2)
 
 

%% testingground

figure()
subplot(4,1,1)
p=plot(  1:size(ressub.fetis,1),ressub.fetis(:,2)-ressub.fetis(:,3),'-o')
subplot(4,1,2)
p=plot(  1:size(ressub.fetis,1),ressub.fetis(:,5)-ressub.fetis(:,6),'-o')
subplot(4,1,3)
p=plot(  1:size(ressub.fetis,1),ressub.fetis(:,7)-ressub.fetis(:,8),'-o')
subplot(4,1,4)
p=plot(  1:size(ressub.fetis,1),ressub.fetis(:,10)-ressub.fetis(:,11),'-o')

legend('2','5','7','11')
title('ressub FETI-2')
set(p,'LineWidth',2)

 
 
test=[... 
  ts.fetis(:,1)'
  ts.fetis(:,5)'
  ts.fetis(:,7)'
  ts.fetis(:,15)']
surf(test)
 set(gca,'ZScale','log')
 
 
 
 %% Visualisierung der Glaettung
 figure()
p=semilogy(  1:size(ts.fetis,1),ts.fetis(:,1),'-o',...
         1:size(ts.fetis,1),ts.fetis(:,end),'-o')
legend('1','end')
title('Glaettung FETI-S')
set(p,'LineWidth',2)
 
