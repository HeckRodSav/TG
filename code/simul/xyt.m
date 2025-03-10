clear all;
close all;
clc;

if isoctave()
	pkg load communications;
end %if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DEBUG = false;

NOISE = true;

ATTENUATION = true;

CHANGE_PHI = false;
CHANGE_DISTANCE = false;

SAVE_GIF = false;

SNR = 1/1;
SNR_dB = 10*log10(SNR);

phase = 0;
% phase = 2*pi*rand()
R_upper = 50;
R_lower = 1;

range_step = 5;

DoA_range = 0:range_step:360;
% DoA_range = [30];
DoA = deg2rad(DoA_range);

limits = 2; % ± * Lambda

lambda = 2;
omega = pi;
d = lambda / 2;
T = 2 * pi / omega;

amp_0 = 1;

C = true;
S = true;

interval = limits*lambda;
resulution = 100;

% o = ones(1,resulution);
space = linspace(-interval,interval,resulution+1); % 1-by-100
[x, y] = meshgrid(space);
% x = space; % 1-by-100
% y = space'; % 1-by-100
t_0 = 0;

name = 'simul';

if CHANGE_DISTANCE
	name = [name '_R_' num2str(R_upper) '~' num2str(R_lower) ];
	% name = sprintf('%s_SNR_%d',name, SNR);
else
	name = [name '_R_' num2str(R_upper)];
end %if
if NOISE
	name = [name '_SNR_' num2str(SNR)];
	% name = sprintf('%s_SNR_%d',name, SNR);
end %if
if ATTENUATION
	name = [name '_ATT'];
end %if*

if SAVE_GIF
	filename = ['Output/' name '.gif'];
	% filename = sprintf('%s.gif',name, SNR);
end %if


if SAVE_GIF
	% f = figure(1, 'Position', get(0, 'Screensize'), 'visible', 'off');
	f = figure(1, 'name', name, 'visible', 'off', 'Position', [1 1 1000 500]);
else
	f = figure('name', name);
	% f = figure(1, 'Position', get(0, 'Screensize'));
	% _ = input('Pressione Enter para continuar... ');
end %if




percent = 0;
ref_iteration = 1/length(DoA_range);
it = 0;
DelayTime = 15*ref_iteration;
r = R_upper+R_lower;

printf('%.2f%% -> %s\n', percent*100, name);

for DoA = [DoA_range DoA_range] % Duas voltas
	it = it + 1;


	if CHANGE_PHI
		phase = phase + pi*ref_iteration;
	end %if

	if CHANGE_DISTANCE
		r = r - R_upper/(2*length(DoA_range));
	end %if

	% disp('')
	ang_W = deg2rad(DoA);

	generate_fig(x, y, t_0, amp_0, ang_W, r, phase, lambda, omega, S, C, ...
		NOISE, SNR_dB, ATTENUATION, DEBUG, interval, resulution, T, d);

	drawnow;
	if SAVE_GIF
		frame = getframe(f);
		im = frame2im(frame);

		[imind, cm] = rgb2ind(im);
		if it == 1
			% Create GIF file
			imwrite(imind, cm, filename,'gif','DelayTime', DelayTime , 'Compression' , 'lzw');
		else
			% Add each new plot to GIF
			imwrite(imind, cm, filename,'gif','WriteMode','append','DelayTime', DelayTime , 'Compression' , 'lzw');
		end %if
	else
		% pause(1/30)
		pause(0.0001)
	end %if

	percent = percent + ref_iteration/2;
	printf('%.2f%% -> %s\n', percent*100, name);

end %for

if SAVE_GIF
	printf('Check: %s\a\n', filename);
end %if
