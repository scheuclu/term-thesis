close all
clear
clc

numel=[60 76 150 375 1500]
numdof=[186 234 408 912 3322]
l2=[...
  0.00067345
  0.00047555
  0.00027774
  0.00012281
  2.7514e-05]'
  
  
figure()
loglog(numel,l2,'-o',numel,0.05*numel.^-1.0,'--')
title('convergence')
xlabel('# elements')
ylabel('integral l2-error')
grid on

figure()
loglog(numdof,l2,'-o',numdof,0.1*numdof.^-1.0,'--')
title('convergence')
xlabel('# dofs')
ylabel('integral l2-error')
grid on