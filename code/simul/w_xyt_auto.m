clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

case_line = 0

S_GIF = true;
S_DAT = false;

range_step = 5;

N_antenas = 5;

% w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);

w_xyt(NOISE = false, ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

w_xyt(NOISE = false, ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = true,  CHG_R = false, CHG_THETA = false, S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

w_xyt(NOISE = false, ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = false, ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1

w_xyt(NOISE = false, ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = false, ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1

w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = true,  CHG_THETA = true,  S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = false, CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
w_xyt(NOISE = true,  ATT = true,  CHG_PHI = false, CHG_R = false, CHG_THETA = true,  S_GIF, S_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1
