close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)


%/home/lukas/Desktop/SA_Thesis/studies/2016-08-10_Partitioning/chaco/quads/feti1/tau1.dat


%% .
files.chaco.quads.feti1={...
    './chaco/quads/feti1/tau1.dat'
    './chaco/quads/feti1/tau10.dat'
    './chaco/quads/feti1/tau100.dat'
    './chaco/quads/feti1/tau1000.dat'}';
  
files.chaco.quads.feti2g={...
    './chaco/quads/feti2geneo/tau1.dat'
    './chaco/quads/feti2geneo/tau10.dat'
    './chaco/quads/feti2geneo/tau100.dat'
    './chaco/quads/feti2geneo/tau1000.dat'}';
  
files.chaco.quads.fetis={...
    './chaco/quads/fetis/tau1.dat'
    './chaco/quads/fetis/tau10.dat'
    './chaco/quads/fetis/tau100.dat'
    './chaco/quads/fetis/tau1000.dat'}';
  

  
files.regular.quads.feti1={...
    './regular/quads/feti1/tau1.dat'
    './regular/quads/feti1/tau10.dat'
    './regular/quads/feti1/tau100.dat'
    './regular/quads/feti1/tau1000.dat'}';
  
files.regular.quads.feti2g={...
    './regular/quads/feti2geneo/tau1.dat'
    './regular/quads/feti2geneo/tau10.dat'
    './regular/quads/feti2geneo/tau100.dat'
    './regular/quads/feti2geneo/tau1000.dat'}';
  
files.regular.quads.fetis={...
    './regular/quads/fetis/tau1.dat'
    './regular/quads/fetis/tau10.dat'
    './regular/quads/fetis/tau100.dat'
    './regular/quads/fetis/tau1000.dat'}';


%% Perform calculations

numiter.chaco.quads.feti1=[];
for iter=files.chaco.quads.feti1
  prob=femac(iter{:})
  numiter.chaco.quads.feti1=[numiter.chaco.quads.feti1,prob.main.solver_.numiter_];
  clear prob
end

numiter.chaco.quads.feti2g=[];
for iter=files.chaco.quads.feti2g
  prob=femac(iter{:})
  numiter.chaco.quads.feti2g=[numiter.chaco.quads.feti2g,prob.main.solver_.numiter_];
  clear prob
end


numiter.chaco.quads.fetis=[];
for iter=files.chaco.quads.fetis
  prob=femac(iter{:})
  numiter.chaco.quads.fetis=[numiter.chaco.quads.fetis,prob.main.solver_.numiter_];
  clear prob
end



numiter.regular.quads.feti1=[];
for iter=files.regular.quads.feti1
  prob=femac(iter{:})
  numiter.regular.quads.feti1=[numiter.regular.quads.feti1,prob.main.solver_.numiter_];
  clear prob
end

numiter.regular.quads.feti2g=[];
for iter=files.regular.quads.feti2g
  prob=femac(iter{:})
  numiter.regular.quads.feti2g=[numiter.regular.quads.feti2g,prob.main.solver_.numiter_];
  clear prob
end


numiter.regular.quads.fetis=[];
for iter=files.regular.quads.fetis
  prob=femac(iter{:})
  numiter.regular.quads.fetis=[numiter.regular.quads.fetis,prob.main.solver_.numiter_];
  clear prob
end



save('numiter','numiter');


%% Plot

tauvec=[1 10 100 1000];

figure()
semilogx(tauvec,numiter.chaco.quads.feti1,'-o',...
        tauvec,numiter.chaco.quads.feti2g,'-o',...
        tauvec,numiter.chaco.quads.fetis,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('chaco partitioning')
hold on
%figure()
semilogx(tauvec,numiter.regular.quads.feti1,'-o',...
        tauvec,numiter.regular.quads.feti2g,'-o',...
        tauvec,numiter.regular.quads.fetis,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('regular partitioning')




figure()
y=[...
    numiter.chaco.quads.feti1
    numiter.chaco.quads.feti2g
    numiter.chaco.quads.fetis     ]'
bar(y)
legend('FETI-1','FETI-2(Geneo)','FETI-S')
set(gca,'XTickLabel',{'1', '10', '100', '1000'}')


csvwrite('./data/chaco_quads_feti1.txt',[tauvec',numiter.chaco.quads.feti1']);
csvwrite('./data/chaco_quads_feti2g.txt',[tauvec',numiter.chaco.quads.feti2g']);
csvwrite('./data/chaco_quads_fetis.txt',[tauvec',numiter.chaco.quads.fetis']);

csvwrite('./data/regular_quads_feti1.txt',[tauvec',numiter.regular.quads.feti1']);
csvwrite('./data/regular_quads_feti2g.txt',[tauvec',numiter.regular.quads.feti2g']);
csvwrite('./data/regular_quads_fetis.txt',[tauvec',numiter.regular.quads.fetis']);