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
	ATTENUATION = true,
	CHANGE_PHI = false,
	CHANGE_DISTANCE = false,
	CHANGE_DIRECTION = true,
	SAVE_GIF = true,
	SNR = 1/1,
	range_step = 5,
	N_antenas = 3
	);
