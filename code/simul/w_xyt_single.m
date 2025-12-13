clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

w_xyt( ...
	true, ... % NOISE
	false, ... % ATT
	false, ... % CHG_PHI
	false, ... % CHG_R
	true, ... % CHG_THETA
	false, ... % S_GIF
	true, ... % S_DAT
	50/1, ... % SNR
	5, ... % range_step
	9 ... % N_antenas
	);
