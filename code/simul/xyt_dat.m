clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

case_line = 0

POLYGON = true;

SAVE_GIF = true;
SAVE_DAT = true;

range_step = 5;

N_antenas = 3;

% xyt(POLYGON, NOISE, ATTENUATION, CHANGE_PHI, CHANGE_DISTANCE, CHANGE_DIRECTION, SAVE_GIF, SAVE_DAT, SNR, range_step, N_antenas);

% xyt(POLYGON, NOISE = false, ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

% xyt(POLYGON, NOISE = false, ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = true,  CHANGE_DISTANCE = false, CHANGE_DIRECTION = false, SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

xyt(POLYGON, NOISE = false, ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = false, ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1

% xyt(POLYGON, NOISE = false, ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = false, ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1

% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = true,  CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = false, CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1

xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 1/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 5/1,   range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 25/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 50/1,  range_step, N_antenas); case_line += 1
% xyt(POLYGON, NOISE = true,  ATTENUATION = true,  CHANGE_PHI = false, CHANGE_DISTANCE = false, CHANGE_DIRECTION = true,  SAVE_GIF, SAVE_DAT, SNR = 100/1, range_step, N_antenas); case_line += 1
