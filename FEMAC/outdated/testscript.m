clear
close all
clc


%K=NodeBase.empty(0,10000);
newnode=NodeBase();

tic
for i=1:10000
  K(i)=newnode;
end
toc