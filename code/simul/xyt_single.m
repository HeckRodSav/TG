clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

xyt(
	POLYGON = true,
	NOISE = true,
	ATTENUATION = false,
	CHANGE_PHI = false,
	CHANGE_DISTANCE = false,
	CHANGE_DIRECTION = true,
	SAVE_GIF = true,
	SAVE_DAT = false,
	SNR = 1/1,
	range_step = 5,
	N_antenas = 12
	);
