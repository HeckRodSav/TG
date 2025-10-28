clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

S_GIF = true;
S_DAT = false;

range_step = 5;

N_antenas = 3;

% w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);

w_xyt(false, false, true,  false, false, S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  false, true,  false, false, S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  false, true,  false, false, S_GIF, S_DAT, 5/1,   range_step, N_antenas);
w_xyt(true,  false, true,  false, false, S_GIF, S_DAT, 25/1,  range_step, N_antenas);
w_xyt(true,  false, true,  false, false, S_GIF, S_DAT, 50/1,  range_step, N_antenas);
w_xyt(true,  false, true,  false, false, S_GIF, S_DAT, 100/1, range_step, N_antenas);

w_xyt(false, true,  true,  false, false, S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  true,  true,  false, false, S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  true,  true,  false, false, S_GIF, S_DAT, 5/1,   range_step, N_antenas);
w_xyt(true,  true,  true,  false, false, S_GIF, S_DAT, 25/1,  range_step, N_antenas);
w_xyt(true,  true,  true,  false, false, S_GIF, S_DAT, 50/1,  range_step, N_antenas);
w_xyt(true,  true,  true,  false, false, S_GIF, S_DAT, 100/1, range_step, N_antenas);

% w_xyt(false, false, false, false, true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(false, false, false, true,  true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);

% w_xyt(false, true,  false, false, true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(false, true,  false, true,  true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);

w_xyt(true,  false, false, true,  true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  false, false, true,  true,  S_GIF, S_DAT, 5/1,   range_step, N_antenas);
w_xyt(true,  false, false, true,  true,  S_GIF, S_DAT, 25/1,  range_step, N_antenas);
w_xyt(true,  false, false, true,  true,  S_GIF, S_DAT, 50/1,  range_step, N_antenas);
w_xyt(true,  false, false, true,  true,  S_GIF, S_DAT, 100/1, range_step, N_antenas);

w_xyt(true,  true,  false, true,  true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
w_xyt(true,  true,  false, true,  true,  S_GIF, S_DAT, 5/1,   range_step, N_antenas);
w_xyt(true,  true,  false, true,  true,  S_GIF, S_DAT, 25/1,  range_step, N_antenas);
w_xyt(true,  true,  false, true,  true,  S_GIF, S_DAT, 50/1,  range_step, N_antenas);
w_xyt(true,  true,  false, true,  true,  S_GIF, S_DAT, 100/1, range_step, N_antenas);

% w_xyt(true,  false, false, false, true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
% w_xyt(true,  false, false, false, true,  S_GIF, S_DAT, 5/1,   range_step, N_antenas);
% w_xyt(true,  false, false, false, true,  S_GIF, S_DAT, 25/1,  range_step, N_antenas);
% w_xyt(true,  false, false, false, true,  S_GIF, S_DAT, 50/1,  range_step, N_antenas);
% w_xyt(true,  false, false, false, true,  S_GIF, S_DAT, 100/1, range_step, N_antenas);

% w_xyt(true,  true,  false, false, true,  S_GIF, S_DAT, 1/1,   range_step, N_antenas);
% w_xyt(true,  true,  false, false, true,  S_GIF, S_DAT, 5/1,   range_step, N_antenas);
% w_xyt(true,  true,  false, false, true,  S_GIF, S_DAT, 25/1,  range_step, N_antenas);
% w_xyt(true,  true,  false, false, true,  S_GIF, S_DAT, 50/1,  range_step, N_antenas);
% w_xyt(true,  true,  false, false, true,  S_GIF, S_DAT, 100/1, range_step, N_antenas);
