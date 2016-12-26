close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare

%/home/lukas/Desktop/SA_Thesis/studies/2016-08-10_Partitioning/chaco/tris/feti1/tau1.dat


%% .
files.feti1={...
    './new/feti1/regular_tris_6x6.dat'
    './new/feti1/chaco_tris_36x1.dat'
    './new/feti1/chaco_tris_6x6.dat'
    './new/feti1/chaco_tris_1x36.dat'}'
  
files.feti2g={...
    './new/feti2g/regular_tris_6x6.dat'
    './new/feti2g/chaco_tris_36x1.dat'
    './new/feti2g/chaco_tris_6x6.dat'
    './new/feti2g/chaco_tris_1x36.dat'}'
  
files.fetis={...
    './new/fetis/regular_tris_6x6.dat'
    './new/fetis/chaco_tris_36x1.dat'
    './new/fetis/chaco_tris_6x6.dat'
    './new/fetis/chaco_tris_1x36.dat'}'
  
files.fetias={...
    './new/fetias/regular_tris_6x6.dat'
    './new/fetias/chaco_tris_36x1.dat'
    './new/fetias/chaco_tris_6x6.dat'
    './new/fetias/chaco_tris_1x36.dat'}'
  
files.fetifas={...
    './new/fetifas/regular_tris_6x6.dat'
    './new/fetifas/chaco_tris_36x1.dat'
    './new/fetifas/chaco_tris_6x6.dat'
    './new/fetifas/chaco_tris_1x36.dat'}'



%% Perform calculations

%% feti1
numiter.feti1=[];
for iter=files.feti1
  prob=femac_pre(iter{:})
  prob=femac_main(iter{:})
  numiter.feti1=[numiter.feti1,prob.solver_.numiter_];
end


%% feti2g
numiter.feti2g=[];
for iter=files.feti2g
  prob=femac_main(iter{:})
  numiter.feti2g=[numiter.feti2g,prob.solver_.numiter_];
end

%% fetis
numiter.fetis=[];
numsdir.fetis={};
for iter=files.fetis
  prob=femac_main(iter{:})
  numiter.fetis=[numiter.fetis,prob.solver_.numiter_];
  numsdir.fetis{end+1}=prob.solver_.numsdir_;
end


numsdir.fetis{1}=36*ones(1,numiter.fetis(1))
numsdir.fetis{2}=11*ones(1,numiter.fetis(2))
numsdir.fetis{3}=36*ones(1,numiter.fetis(3))
numsdir.fetis{4}=11*ones(1,numiter.fetis(4))

%% fetias
numiter.fetias=[];
numsdir.fetias={};
for iter=files.fetias
  prob=femac_pre(iter{:})
  prob=femac_main(iter{:})
  numiter.fetias=[numiter.fetis,prob.solver_.numiter_];
  numsdir.fetias{end+1}=prob.solver_.numsdir_;
end

%% fetifas
numiter.fetifas=[];
numsdir.fetifas={};
for iter=files.fetifas
  prob=femac_main(iter{:})
  numiter.fetifas=[numiter.fetifas,prob.main.solver_.numiter_];
  numsdir.fetifas{end+1}=prob.main.solver_.numsdir_;
end


figure()
plot(numsdir.fetis{1},numsdir.fetifas{1})

figure()
plot(numsdir.fetis{2},numsdir.fetifas{2})

figure()
plot(numsdir.fetis{3},numsdir.fetifas{3})

figure()
plot(numsdir.fetis{4},numsdir.fetifas{4})

csvwrite('./data/numiter_regular_6x6.txt',[numiter.feti1(1) numiter.feti2g(1) numiter.fetis(1) numiter.fetifas(1) ])
csvwrite('./data/numiter_chaco_11x1.txt', [numiter.feti1(2) numiter.feti2g(2) numiter.fetis(2) numiter.fetifas(2) ])
csvwrite('./data/numiter_chaco_6x6.txt',  [numiter.feti1(3) numiter.feti2g(3) numiter.fetis(3) numiter.fetifas(3) ])
csvwrite('./data/numiter_chaco_1x11.txt',  [numiter.feti1(4) numiter.feti2g(4) numiter.fetis(4) numiter.fetifas(4) ])

csvwrite('./data/numsdir_regular_6x6_fetis.txt',[numsdir.fetis{1}'] )
csvwrite('./data/numsdir_chaco_11x1_fetis.txt',[numsdir.fetis{2}'] )
csvwrite('./data/numsdir_chaco_6x6_fetis.txt',[numsdir.fetis{3}'] )
csvwrite('./data/numsdir_chaco_1x11_fetis.txt',[numsdir.fetis{4}'] )


csvwrite('./data/numsdir_regular_6x6_fetias.txt',[numsdir.fetias{1}'] )
csvwrite('./data/numsdir_chaco_11x1_fetias.txt',[numsdir.fetias{2}'] )
csvwrite('./data/numsdir_chaco_6x6_fetias.txt',[numsdir.fetias{3}'] )
csvwrite('./data/numsdir_chaco_1x11_fetias.txt',[numsdir.fetias{4}'] )

csvwrite('./data/numsdir_regular_6x6_fetifas.txt',[numsdir.fetifas{1}'] )
csvwrite('./data/numsdir_chaco_11x1_fetifas.txt',[numsdir.fetifas{2}'] )
csvwrite('./data/numsdir_chaco_6x6_fetifas.txt',[numsdir.fetifas{3}'] )
csvwrite('./data/numsdir_chaco_1x11_fetifas.txt',[numsdir.fetifas{4}'] )