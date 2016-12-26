close all
clear
clc

A=[...
   2 1 0 0
   1 2 1 0
   0 1 2 1
   0 1 2 1]
 
%  A=A'*A
 
 nspace=null(A)
 nspace=nspace/nspace(1)
 

 sparse(A)
 
 
 [L,U,P]=lu(A)
 
 
 disp('asddddddddddddddddddddddddddd')
 
 
 [U,S,V] = svd(A)
 
[Us,Ss,Vs] = svds(sparse(A))

Us'-inv(Us)>1e-14
Vs'-inv(Vs)>1e-14

%If the singlular value decpomposition is known, 