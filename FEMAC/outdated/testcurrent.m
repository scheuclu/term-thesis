close all
clear
clc

nodes=[];
numnodes=6000;

tic
for i=1:numnodes
  newnode=NodeBase(i,3,[0 1 2],1,1,0);
  nodes=[nodes,newnode];
end
toc