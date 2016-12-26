close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare


file.chaco.fetifas={...
  './chaco/chaco_tri_contract_fast.dat'
  './chaco/chaco_tri_contract_lowest.dat'
  './chaco/chaco_tri_contract_block.dat'}'
%   './chaco/chaco_tri_contract_feti1.dat'}'
 
numdir.chaco.fetifas = {}
res.chaco.fetifas    = {}
tau.chaco.fetifas    = []

femac_pre(file.chaco.fetifas{1});
 for iter= file.chaco.fetifas
   temp=iter{:};
   prob=femac_main(temp)
   numdir.chaco.fetifas{end+1}=prob.solver_.numsdir_'
   res.chaco.fetifas{end+1}=prob.solver_.res_'
 end
 
 

 outmat=zeros(length(numdir.chaco.fetifas{end}),length(file.chaco.fetifas) )
 for i=1:length(file.chaco.fetifas)
   outmat(1:length(numdir.chaco.fetifas{i}),i)=numdir.chaco.fetifas{i}
 end
 
figure()
bar3(outmat)

csvwrite('./data/numsdir_chaco_fetifas_all.txt',outmat)
 
csvwrite('./data/numsdir_chaco_fetifas_fast.txt',[ (1:length(numdir.chaco.fetifas{1}) )', numdir.chaco.fetifas{1}])
csvwrite('./data/numsdir_chaco_fetifas_block.txt',[ (1:length(numdir.chaco.fetifas{2}))', numdir.chaco.fetifas{2}])
csvwrite('./data/numsdir_chaco_fetifas_lowest.txt',[ (1:length(numdir.chaco.fetifas{3}))', numdir.chaco.fetifas{3}])
 
 
 
