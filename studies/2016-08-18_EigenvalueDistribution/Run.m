clear
clc

femacdir = '../../FEMAC/'
addpath(femacdir)

prepare


%% Perform calculations
prob_f1 = femac_pre('./mesh_5layers_16domains_feti1.dat');
prob_f1 = femac_main('./mesh_5layers_16domains_feti1.dat');
prob_f2g= femac_main('./mesh_5layers_16domains_feti2geneo.dat');
prob_fs = femac_main('./mesh_5layers_16domains_fetis.dat');

close all

%% Retrieve simulation data
Fmat.raw.f1  =full(prob_f1.solver_.F_);
Fmat.raw.f2g =full(prob_f2g.solver_.F_);
Fmat.raw.fs  =full(prob_fs.solver_.F_);

St.raw.f1  =full(prob_f1.solver_.St_);
St.raw.f2g =full(prob_f2g.solver_.St_);
St.raw.fs  =full(prob_fs.solver_.St_);

%% raw eigenvalues
eigval.raw.f1 =sort(eig(Fmat.raw.f1))
eigval.raw.f2g=sort(eig(Fmat.raw.f2g))
eigval.raw.fs =sort(eig(Fmat.raw.fs))

condval.raw.f1 =cond(Fmat.raw.f1)
condval.raw.f2g=cond(Fmat.raw.f2g)
condval.raw.fs =cond(Fmat.raw.fs)


%% preconditioned eigenvalues
eigval.precond.f1 =sort(eig(St.raw.f1*Fmat.raw.f1))
eigval.precond.f2g=sort(eig(St.raw.f2g*Fmat.raw.f2g))
eigval.precond.fs =sort(eig(St.raw.fs*Fmat.raw.fs))

condval.precond.f1 =cond(St.raw.f1*Fmat.raw.f1)
condval.precond.f2g=cond(St.raw.f2g*Fmat.raw.f2g)
condval.precond.fs =cond(St.raw.fs*Fmat.raw.fs)


figure()
plot(1:length(eigval.raw.f1),eigval.raw.f1,'-o',...
       1:length(eigval.raw.f2g),eigval.raw.f2g,'-o',...
       1:length(eigval.raw.fs),eigval.raw.fs,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('raw matrices')

%% project to coarse spaces
projn.f1=prob_f1.solver_.P_;
projn.f2g=prob_f2g.solver_.Pc_*prob_f2g.solver_.P_;
projn.fs=prob_fs.solver_.P_;

%is this correct
Fmat.projn.f1=St.raw.f1*Fmat.raw.f1*projn.f1;
Fmat.projn.f2g=St.raw.f2g*Fmat.raw.f2g*projn.f2g;
Fmat.projn.fs=St.raw.fs*Fmat.raw.fs*projn.fs;

% %old one
% Fmat.projn.f1=projn.f1'*Fmat.raw.f1%*projn.f1;
% Fmat.projn.f2g=projn.f2g'*Fmat.raw.f2g%*projn.f2g;
% Fmat.projn.fs=projn.fs'*Fmat.raw.fs%*projn.fs;


eigval.projn.f1 =sort(abs(real(eig(Fmat.projn.f1))))
eigval.projn.f2g=sort(abs(real(eig(Fmat.projn.f2g))))
eigval.projn.fs =sort(abs(real(eig(Fmat.projn.fs))))



%% cut


eigval.projn.cut.f1 =eigval.projn.f1;
eigval.projn.cut.f2g=eigval.projn.f2g;
eigval.projn.cut.fs =eigval.projn.fs;


eigval.projn.cut.f1(eigval.projn.f1<1e-10)=[];
eigval.projn.cut.f2g(eigval.projn.f2g<1e-10)=[];
eigval.projn.cut.fs(eigval.projn.fs<1e-10)=[];

condval.projn.f1 =cond(Fmat.projn.f1)
condval.projn.f2g=cond(Fmat.projn.f2g)
condval.projn.fs =cond(Fmat.projn.fs)

figure()
semilogx(eigval.projn.f1,eigval.projn.f1*0+1,'-o',...
       eigval.projn.f2g,eigval.projn.f2g*0+2,'-o',...
       eigval.projn.fs,eigval.projn.fs*0+3,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('natural coarse space matrices')




figure()
semilogy(1:length(eigval.raw.f1),eigval.raw.f1,'o',...
     1:length(eigval.projn.f1),eigval.projn.f1,'o')
legend('raw','projected')
title('natural projection')



figure()
plot(1:length(eigval.projn.f1),eigval.projn.f1,'-o',...
       1:length(eigval.projn.f2g),eigval.projn.f2g,'-o',...
       1:length(eigval.projn.fs),eigval.projn.fs,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('natural coarse space matrices')



figure()
plot(1:length(eigval.projn.f1),eigval.projn.f1,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('natural coarse space matrices')




figure()
plot(1:length(eigval.projn.f2g),eigval.projn.f2g,'-o')
legend('FETI-1','FETI-2(Geneo)','FETI-S')
title('natural coarse space matrices')

%% Write output

csvwrite('./data/eigvalues_raw_feti1.txt',     [[1:length(eigval.raw.f1)]', eigval.raw.f1]);
csvwrite('./data/eigvalues_raw_feti2geneo.txt',[[1:length(eigval.raw.f2g)]',eigval.raw.f2g]);
csvwrite('./data/eigvalues_raw_fetis.txt',     [[1:length(eigval.raw.fs)]', eigval.raw.fs]);

csvwrite('./data/eigvalues_precond_feti1.txt',     [[1:length(eigval.precond.f1)]', eigval.precond.f1]);
csvwrite('./data/eigvalues_precond_feti2geneo.txt',[[1:length(eigval.precond.f2g)]',eigval.precond.f2g]);
csvwrite('./data/eigvalues_precond_fetis.txt',     [[1:length(eigval.precond.fs)]', eigval.precond.fs]);

csvwrite('./data/eigvalues_projn_feti1.txt',[[1:length(eigval.projn.f1)]',eigval.projn.f1]);
csvwrite('./data/eigvalues_projn_feti2geneo.txt',[[1:length(eigval.projn.f2g)]',eigval.projn.f2g]);
csvwrite('./data/eigvalues_projn_fetis.txt',[[1:length(eigval.projn.fs)]',eigval.projn.fs]);



csvwrite('./data/eigvalues_projn_cut_feti1.txt',[[1:length(eigval.projn.cut.f1)]',eigval.projn.cut.f1]);
csvwrite('./data/eigvalues_projn_cut_feti2geneo.txt',[[1:length(eigval.projn.cut.f2g)]',eigval.projn.cut.f2g]);
csvwrite('./data/eigvalues_projn_cut_fetis.txt',[[1:length(eigval.projn.cut.fs)]',eigval.projn.cut.fs]);



csvwrite('./data/eigvaluesonly_UU.txt',[eigval.raw.f1]);
csvwrite('./data/eigvaluesonly_feti2g_projn_cut.txt',[eigval.projn.cut.f2g]);
