close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare

%% ts development

prob_feti2=femac(files.taudevelopment{2})                                 
ts.feti2  =prob_feti2.main.solver_.ts_
ressub.feti2=prob_feti2.main.solver_.ressub_

csvwrite('./data/ts_feti2.txt',[[1:size(ts.feti2,1)]',ts.feti2])

 %TODO this must be done with a feti2 solver
 figure()
 semilogy(1:size(ts.feti2,1),ts.feti2(:,1),'--o')
 hold on
 semilogy(1:size(ts.feti2,1),ts.feti2(:,2),'--o')
 semilogy(1:size(ts.feti2,1),ts.feti2(:,3),'--o')
 
 legend('iteration 1', 'iteration 2', 'iteration 3')
 
%%%

 figure()
  p=plot(1:size(ts.fetis,1),ts.fetis(:,1),'-xm',...
           1:size(ts.feti2,1),ts.feti2(:,1),'--xk',...
           1:size(ts.feti2,1),ts.feti2(:,2),'-ok',...
           1:size(ts.fetis,1),ts.fetis(:,2),'-om')
 legend('initial error','initial error','feti2','fetis')
 set(p,'LineWidth',2)
 

 %% study of ts scattering in a feti2 simulation
 
figure()
p=semilogy(  1:size(ts.feti2,1),ts.feti2(:,1),'-o',...
         1:size(ts.feti2,1),ts.feti2(:,5),'-o',...
         1:size(ts.feti2,1),ts.feti2(:,7),'-o',...
         1:size(ts.feti2,1),ts.feti2(:,15),'-o')
legend('1','5','7','11')
title('ts FETI-2')
set(p,'LineWidth',2)


figure()
p=semilogy(  1:size(ressub.feti2,1),ressub.feti2(:,2),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,3),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,4),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,5),'-o')
         1:size(ressub.feti2,1),ressub.feti2(:,6),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,7),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,8),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,9),'-o',...
         1:size(ressub.feti2,1),ressub.feti2(:,10),'-o')
legend('2','5','7','11')
title('ressub FETI-2')
set(p,'LineWidth',2)

%% Visualisierung der Glaettung
figure()
p=semilogy(  1:size(ts.feti2,1),ts.feti2(:,1),'-o',...
         1:size(ts.feti2,1),ts.feti2(:,end),'-o')
legend('1','end')
title('Glaettung FETI-2')
set(p,'LineWidth',2)
 
