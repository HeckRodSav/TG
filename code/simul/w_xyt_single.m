clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

w_xyt( ...
	false, ... % NOISE
	false, ... % ATT
	false, ... % CHG_PHI
	false, ... % CHG_R
	true, ... % CHG_THETA
	true, ... % S_GIF
	true, ... % S_DAT
	1/1, ... % SNR
	36*2, ... % range_step
	9 ... % N_antenas
);
