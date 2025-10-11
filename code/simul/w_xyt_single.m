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
	true, ... % CHG_PHI
	false, ... % CHG_R
	false, ... % CHG_THETA
	true, ... % S_GIF
	false, ... % S_DAT
	1/1, ... % SNR
	5, ... % range_step
	9 ... % N_antenas
	);
