close all
clear
clc


numnodes=6000;

tic
nodes(numnodes)=NodeBaseNew();
for i=1:numnodes
  nodes(i).Set(i,3,[0 1 2],1,1,0);
end
toc