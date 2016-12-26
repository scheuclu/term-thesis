close all
clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare



contractfacs=[0.1 0.5 0.9 0.95 0.99 0.999 0.9999 0.99999]


file.setup1.chaco.fetia={...
  './chaco/chaco_tri_contract0p1_setup1.dat'
  './chaco/chaco_tri_contract0p5_setup1.dat'
  './chaco/chaco_tri_contract0p9_setup1.dat'
  './chaco/chaco_tri_contract0p95_setup1.dat'
  './chaco/chaco_tri_contract0p99_setup1.dat'
  './chaco/chaco_tri_contract0p999_setup1.dat'
  './chaco/chaco_tri_contract0p9999_setup1.dat'
  './chaco/chaco_tri_contract0p99999_setup1.dat'}'

file.setup2.chaco.fetia={...
  './chaco/chaco_tri_contract0p1_setup2.dat'
  './chaco/chaco_tri_contract0p5_setup2.dat'
  './chaco/chaco_tri_contract0p9_setup2.dat'
  './chaco/chaco_tri_contract0p95_setup2.dat'
  './chaco/chaco_tri_contract0p99_setup2.dat'
  './chaco/chaco_tri_contract0p999_setup2.dat'
  './chaco/chaco_tri_contract0p9999_setup2.dat'
  './chaco/chaco_tri_contract0p99999_setup2.dat'}'



file.setup1detail.chaco.fetia={...
  './chaco/detail/chaco_tri_contract0p1_setup1.dat'
  './chaco/detail/chaco_tri_contract0p5_setup1.dat'
  './chaco/detail/chaco_tri_contract0p9_setup1.dat'
  './chaco/detail/chaco_tri_contract0p95_setup1.dat'
  './chaco/detail/chaco_tri_contract0p99_setup1.dat'
  './chaco/detail/chaco_tri_contract0p999_setup1.dat'
  './chaco/detail/chaco_tri_contract0p9999_setup1.dat'
  './chaco/detail/chaco_tri_contract0p99999_setup1.dat'}'

file.setup2detail.chaco.fetia={...
  './chaco/detail/chaco_tri_contract0p1_setup2.dat'
  './chaco/detail/chaco_tri_contract0p5_setup2.dat'
  './chaco/detail/chaco_tri_contract0p9_setup2.dat'
  './chaco/detail/chaco_tri_contract0p95_setup2.dat'
  './chaco/detail/chaco_tri_contract0p99_setup2.dat'
  './chaco/detail/chaco_tri_contract0p999_setup2.dat'
  './chaco/detail/chaco_tri_contract0p9999_setup2.dat'
  './chaco/detail/chaco_tri_contract0p99999_setup2.dat'}'
 

%% setup1 calculations
numdir.setup1.chaco.fetia = {}
res.setup1.chaco.fetia = {}
tau.setup1.chaco.fetia = []
numiter.setup1.chaco.fetia = []


femac_pre(file.setup1.chaco.fetia{1});
 for iter= file.setup1.chaco.fetia
   temp=iter{:};
   prob=femac_main(temp)
   numdir.setup1.chaco.fetia{end+1}=prob.solver_.numsdir_'
   res.setup1.chaco.fetia{end+1}=prob.solver_.res_'
   tau.setup1.chaco.fetia=[tau.setup1.chaco.fetia,prob.solver_.tau_']
   numiter.setup1.chaco.fetia=[numiter.setup1.chaco.fetia,prob.solver_.numiter_']
 end
  

 outmat.setup1=zeros(length(numdir.setup1.chaco.fetia{end}),length(file.setup1.chaco.fetia) )
 for i=1:length(file.setup1.chaco.fetia)
   outmat.setup1(1:length(numdir.setup1.chaco.fetia{i}),i)=numdir.setup1.chaco.fetia{i}
 end
 
 figure()
 bar3(outmat.setup1)
 
 figure()
 for i=1:length(file.setup1.chaco.fetia)
   p=semilogy((1:length(res.setup1.chaco.fetia{i})),res.setup1.chaco.fetia{i})
   set(p,'LineWidth',2)
   hold on
 end
%  legend('0p1','0p5,','0p9','0p95','0p99','0p999','0p9999','0p9999','fast', 'block', 'feti1')

 
csvwrite('./data/numsdir_setup1_chaco_fetia.txt',outmat.setup1)
%csvwrite('./data/contract2tau_chaco.txt',[contractfacs',tau.chaco.fetia'])
 
%% setup2 calculations
numdir.setup2.chaco.fetia = {}
res.setup2.chaco.fetia = {}
tau.setup2.chaco.fetia = []
numiter.setup2.chaco.fetia = []

femac_pre(file.setup2.chaco.fetia{1});
 for iter= file.setup2.chaco.fetia
   temp=iter{:};
   prob=femac_main(temp)
   numdir.setup2.chaco.fetia{end+1}=prob.solver_.numsdir_'
   res.setup2.chaco.fetia{end+1}=prob.solver_.res_'
   tau.setup2.chaco.fetia=[tau.setup2.chaco.fetia,prob.solver_.tau_']
   numiter.setup2.chaco.fetia=[numiter.setup2.chaco.fetia,prob.solver_.numiter_']
 end
 
 
 
for i= 1:length(numdir.setup1.chaco.fetia)
  numiter.setup1.chaco.fetia(i)=length(numdir.setup1.chaco.fetia{i})
end
 
 for i= 1:length(numdir.setup2.chaco.fetia)
  numiter.setup2.chaco.fetia(i)=length(numdir.setup2.chaco.fetia{i})
 end
  

 outmat.setup2=zeros(length(numdir.setup2.chaco.fetia{end}),length(file.setup2.chaco.fetia) )
 for i=1:length(file.setup2.chaco.fetia)
   outmat.setup2(1:length(numdir.setup2.chaco.fetia{i}),i)=numdir.setup2.chaco.fetia{i}
 end
 
 figure()
 bar3(outmat.setup2)
 
 figure()
 for i=1:length(file.setup2.chaco.fetia)
   p=semilogy((1:length(res.setup2.chaco.fetia{i})),res.setup2.chaco.fetia{i})
   set(p,'LineWidth',2)
   hold on
 end
 legend('0p1','0p5,','0p9','0p95','0p99','0p999','0p9999','0p9999','fast', 'block', 'feti1')

 
csvwrite('./data/numsdir_setup2_chaco_fetia.txt',outmat.setup2)
%csvwrite('./data/contract2tau_chaco.txt',[contractfacs',tau.chaco.fetia'])
 
%% plotting

figure()
loglog(contractfacs(end-3:end),numiter.setup1.chaco.fetia(end-3:end)/numiter.setup1.chaco.fetia(1),'-o',...
        contractfacs(end-3:end),numiter.setup2.chaco.fetia(end-3:end)/numiter.setup2.chaco.fetia(1),'-o' )
 
 figure()
 loglog(contractfacs,tau.setup1.chaco.fetia,'-o')
 xlabel('contarction factor')
 ylabel('tau')
 
  figure()
 loglog(contractfacs,tau.setup2.chaco.fetia,'-o')
 xlabel('contarction factor')
 ylabel('tau')