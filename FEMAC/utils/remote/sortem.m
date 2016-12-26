function [P2,D2]=sortem(P,D)
% this function takes in two matrices P and D, presumably the output 
% from Matlab's eig function, and then sorts the columns of P to 
% match the sorted columns of D (going from smallest to largest)
% 
% EXAMPLE: 
% 
% P =
%      1     2     3
%      1     2     3
%      1     2     3
% D =
%      4     0     0
%      0     6     0
%      0     0     5
% 
% [P,D]=sortem(P,D)
% P =
%      1     3     2
%      1     3     2
%      1     3     2
% D =
%      4     0     0
%      0     5     0
%      0     0     6


D2=diag(sort(diag(D),'ascend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(D),'ascend'); % store the indices of which columns the sorted eigenvalues come from
P2=P(:,ind); % arrange the columns in this order

