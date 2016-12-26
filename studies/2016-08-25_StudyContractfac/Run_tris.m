close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)


%/home/lukas/Desktop/SA_Thesis/studies/2016-08-10_Partitioning/chaco/tris/feti1/tau1.dat


%% .
files.chaco.tris.feti1={...
    './chaco/tris/feti1/tau1.dat'
    './chaco/tris/feti1/tau10.dat'
    './chaco/tris/feti1/tau100.dat'
    './chaco/tris/feti1/tau1000.dat'}';
  
files.chaco.tris.feti2g={...
    './chaco/tris/feti2geneo/tau1.dat'
    './chaco/tris/feti2geneo/tau10.dat'
    './chaco/tris/feti2geneo/tau100.dat'
    './chaco/tris/feti2geneo/tau1000.dat'}';
  
files.chaco.tris.fetis={...
    './chaco/tris/fetis/tau1.dat'
    './chaco/tris/fetis/tau10.dat'
    './chaco/tris/fetis/tau100.dat'
    './chaco/tris/fetis/tau1000.dat'}';
  

  
files.regular.tris.feti1={...
    './regular/tris/feti1/tau1.dat'
    './regular/tris/feti1/tau10.dat'
    './regular/tris/feti1/tau100.dat'
    './regular/tris/feti1/tau1000.dat'}';
  
files.regular.tris.feti2g={...
    './regular/tris/feti2geneo/tau1.dat'
    './regular/tris/feti2geneo/tau10.dat'
    './regular/tris/feti2geneo/tau100.dat'
    './regular/tris/feti2geneo/tau1000.dat'}';
  
files.regular.tris.fetis={...
    './regular/tris/fetis/tau1.dat'
    './regular/tris/fetis/tau10.dat'
    './regular/tris/fetis/tau100.dat'
    './regular/tris/fetis/tau1000.dat'}';


%% Perform calculations

numiter.chaco.tris.feti1=[];
for iter=files.chaco.tris.feti1
  prob=femac(iter{:})
  numiter.chaco.tris.feti1=[numiter.chaco.tris.feti1,prob.main.solver_.numiter_];
  clear prob
end

numiter.chaco.tris.feti2g=[];
for iter=files.chaco.tris.feti2g
  prob=femac(iter{:})
  numiter.chaco.tris.feti2g=[numiter.chaco.tris.feti2g,prob.main.solver_.numiter_];
  clear prob
end


numiter.chaco.tris.fetis=[];
for iter=files.chaco.tris.fetis
  prob=femac(iter{:})
  numiter.chaco.tris.fetis=[numiter.chaco.tris.fetis,prob.main.solver_.numiter_];
  clear prob
end



numiter.regular.tris.feti1=[];
for iter=files.regular.tris.feti1
  prob=femac(iter{:})
  numiter.regular.tris.feti1=[numiter.regular.tris.feti1,prob.main.solver_.numiter_];
  clear prob
end

numiter.regular.tris.feti2g=[];
for iter=files.regular.tris.feti2g
  prob=femac(iter{:})
  numiter.regular.tris.feti2g=[numiter.regular.tris.feti2g,prob.main.solver_.numiter_];
  clear prob
end


numiter.regular.tris.fetis=[];
for iter=files.regular.tris.fetis
  prob=femac(iter{:})
  numiter.regular.tris.fetis=[numiter.regular.tris.fetis,prob.main.solver_.numiter_];
  clear prob
end



save('numiter','numiter');


%% Plot

tauvec=[1 10 100 1000];

figure()
semilogx(tauvec,numiter.chaco.tris.feti1,'-o',...
        tauvec,numiter.chaco.tris.feti2g,'-o',...
        tauvec,numiter.chaco.tris.fetis,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('chaco partitioning')
hold on
%figure()
semilogx(tauvec,numiter.regular.tris.feti1,'-o',...
        tauvec,numiter.regular.tris.feti2g,'-o',...
        tauvec,numiter.regular.tris.fetis,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('regular partitioning')




figure()
y=[...
    numiter.chaco.tris.feti1
    numiter.chaco.tris.feti2g
    numiter.chaco.tris.fetis     ]'
bar(y)
legend('FETI-1','FETI-2(Geneo)','FETI-S')
set(gca,'XTickLabel',{'1', '10', '100', '1000'}')

% 
% csvwrite('./data/chaco_tris_feti1.txt',[tauvec',numiter.chaco.tris.feti1']);
% csvwrite('./data/chaco_tris_feti2g.txt',[tauvec',numiter.chaco.tris.feti2g']);
% csvwrite('./data/chaco_tris_fetis.txt',[tauvec',numiter.chaco.tris.fetis']);
% 
% csvwrite('./data/regular_tris_feti1.txt',[tauvec',numiter.regular.tris.feti1']);
% csvwrite('./data/regular_tris_feti2g.txt',[tauvec',numiter.regular.tris.feti2g']);
% csvwrite('./data/regular_tris_fetis.txt',[tauvec',numiter.regular.tris.fetis']);