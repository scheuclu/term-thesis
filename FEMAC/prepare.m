% close all
% clear
clc

format compact

femacdir=regexp(mfilename('fullpath'),'prepare','split')
femacdir=femacdir{1}

addpath (fullfile(femacdir,'examples'));
addpath (fullfile(femacdir,'fe_lib'));
addpath (fullfile(femacdir,'fe_core'));
addpath (fullfile(femacdir,'feti'));
addpath (fullfile(femacdir,'io'));
addpath (fullfile(femacdir,'utils'));
addpath (fullfile(femacdir,'utils/remote'));
addpath (fullfile(femacdir,'ele'));
addpath (fullfile(femacdir,'post'));
addpath (fullfile(femacdir,'prob'));
addpath (fullfile(femacdir,'solver'));
addpath (fullfile(femacdir,'validation'));