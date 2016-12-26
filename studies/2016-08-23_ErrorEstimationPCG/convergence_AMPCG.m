clear
close all
clc


lfrac=logspace(0,4,1000)


temp1=2*( (sqrt(lfrac)-1)./(sqrt(lfrac)+1))
temp2=2*( (sqrt(lfrac)-1)./(sqrt(lfrac)+1)).^2
temp3=2*( (sqrt(lfrac)-1)./(sqrt(lfrac)+1)).^3
temp4=2*( (sqrt(lfrac)-1)./(sqrt(lfrac)+1)).^10
temp5=2*( (sqrt(lfrac)-1)./(sqrt(lfrac)+1)).^100




semilogx(lfrac,temp1,'-',...
         lfrac,temp2,'-',...
         lfrac,temp3,'-',...
         lfrac,temp4,'-',...
         lfrac,temp5,'-')
xlabel('lambda_max/lambda_min')
ylabel('error estimat')
       
       
legend('iter1','iter2','iter3','iter10','iter100')

csvwrite('./data/relative_error.txt',[lfrac', temp1', temp2', temp3', temp4', temp5'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % lfrac=logspace(-1,3,100)
% % power=linspace(1,10,10)
% % 
% % 
% %   temp=[]
% % 
% % 
% % for p=power
% % 
% %   temp=[temp;real(( (sqrt(lfrac)-1)./(sqrt(lfrac)+1)).^p)];
% % 
% % 
% % 
% % end
% % 
% % figure()
% % [POWER,LFRAC]=meshgrid(power,lfrac)
% % 
% % surf(real(POWER),real(LFRAC),temp')
% % hold on
% % surf(real(POWER),real(LFRAC),temp'*0)
% % %set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale', 'log')
% % set(gca, 'YScale', 'log')
% % % 
% % % semilogx(lfrac,temp1,'-',...
% % %          lfrac,temp2,'-',...
% % %          lfrac,temp3,'-',...
% % %          lfrac,temp4,'-')
% % %        
% % %        
% % % legend('iter1','iter2','iter3','iter4')