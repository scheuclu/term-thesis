close all
clear
clc

A=[...
   2 1 0 0 9
   1 2 1 0 9
   0 0 2 1 9
   0 1 2 1 9
   1 2 1 0 9]
 
%  A=A'*A
 
 nspace=null(A)
 
 sA=sparse(A)
 sb=sparse(5,0)
 
 
 [~, SpRight] = spspaces(sA,2,1e-12)
 snspace=SpRight{1}(:,SpRight{3})
 
 
 [Q,R,es]=qr(sA)

 PIF=pseudoinverse(sA)

 PIF*[1;2;3;4;5]

%  
%  
%  [L,U,P]=lu(A)
%  
%  
%  disp('asddddddddddddddddddddddddddd')
%  
%  
%  [U,S,V] = svd(A)
%  
% [Us,Ss,Vs] = svds(sparse(A))
% 
% Us'-inv(Us)>1e-14
% Vs'-inv(Vs)>1e-14
% 
% %If the singlular value decpomposition is known, 