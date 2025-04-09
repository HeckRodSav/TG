function xyt(POLYGON, NOISE, ATTENUATION, CHANGE_PHI, CHANGE_DISTANCE, CHANGE_DIRECTION, SAVE_GIF, SAVE_DAT, SNR, range_step, N_antenas)

	function ang_norm = normalize_angle(ang)
		ang_norm = ang;
		if ang > pi
			ang_norm -= (2*pi);
		end % if
		if ang < -pi
			ang_norm += (2*pi);
		end % if
	end % function

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	DEBUG = false;
	% SAVE_DAT = false;

	% POLYGON = true;

	% NOISE = true;

	% ATTENUATION = true;

	% CHANGE_PHI = false;
	% CHANGE_DISTANCE = true;
	% CHANGE_DIRECTION = true;

	% SAVE_GIF = true;

	% SNR = 5/1;
	SNR_dB = 10*log10(SNR);

	phase = 0;
	% phase = 2*pi*rand()
	R_upper = 50;
	R_lower = 1;

	% range_step = 5;
	range_shift = 0;

	DoA_range = (0+range_shift):range_step:(360+range_shift-1);
	% DoA_range = [30];
	DoA = deg2rad(DoA_range);

	limits = 2; % ± * Lambda

	c = 1; % Velocidade da luz, simplificacao
	lambda = 4;
	omega = 2*pi*c/lambda;
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

	ant_idx_list = 1:1:N_antenas;
	ant_idx_list_shift = circshift(ant_idx_list, 1);

	name = 'simul';
	folder = '';

	if POLYGON
		name = [name '_POLY_' num2str(N_antenas)];
		folder = [folder 'POLY_' num2str(N_antenas)];
	end %if

	if CHANGE_DISTANCE
		name = [name '_R_' num2str(R_upper) '~' num2str(R_lower) ];
		% name = sprintf('%s_SNR_%d',name, SNR);
	else
		name = [name '_R_' num2str(R_upper)];
	end %if
	if ~CHANGE_DIRECTION
		name = [name '_FIXED_W'];
	end %if
	if NOISE
		name = [name '_SNR_' num2str(SNR)];
		% name = sprintf('%s_SNR_%d',name, SNR);
	end %if
	if ATTENUATION
		name = [name '_ATT'];
	end %if

	if (SAVE_GIF || SAVE_DAT)
		foldername = fullfile('Output', folder);
		if not(isfolder(foldername))
			mkdir(foldername);
		end %if
		if SAVE_GIF
			gif_filename = fullfile(foldername, [name '.gif']);
		end %if
		if SAVE_DAT
			dat_filename = fullfile(foldername, [name '.dat']);
		end %if
	end %if

	if SAVE_GIF
		% f = figure(1, 'Position', get(0, 'Screensize'), 'visible', 'off');
		f = figure(1, 'name', name, 'visible', 'off', 'Position', [1 1 1000 500]);
	else
		f = figure('name', name);
		% f = figure(1, 'Position', get(0, 'Screensize'));
		% _ = input('Pressione Enter para continuar... ');
	end %if

	if SAVE_DAT
		dat_file = fopen(dat_filename, 'w');
		fprintf(dat_file, "%s", "percent");
		fprintf(dat_file, "\t%s", "ang_W");
		fprintf(dat_file, "\t%s", "r");
		fprintf(dat_file, "\t%s", "phase");
		fprintf(dat_file, "\t%s", "choose_angle");
		for i = ant_idx_list
			fprintf(dat_file, "\t%s%d_x_%d", "delta_", i, ant_idx_list_shift(i));
		end % for
		for i = ant_idx_list
			fprintf(dat_file, "\t%s%d_x_%d", "delta_", ant_idx_list_shift(i), i);
		end % for
		fprintf(dat_file, "\n");
		fflush(dat_file);
	end % if

	DoA_loop_range = [DoA_range DoA_range 360]; % Duas voltas

	percent = 0;
	ref_iteration = 1/(length(DoA_loop_range)-1);
	it = 0;
	DelayTime = 15*ref_iteration;
	r = R_upper+R_lower;

	% printf('%.2f%% -> %s\n', percent*100, name);


	for DoA = DoA_loop_range
	% for DoA = [DoA_range] % Uma volta
		it = it + 1;

		printf('%.2f%% -> %s\n', percent*100, name);

		if CHANGE_PHI
			phase = phase + 2*pi*ref_iteration;
		end %if

		if CHANGE_DISTANCE
			r = r - R_upper/(2*length(DoA_range));
		end %if

		% disp('')
		if CHANGE_DIRECTION
			ang_W = deg2rad(DoA);
		else
			ang_W = pi*5/12;
		end %if

		if POLYGON
			return_struct = calc_AoA_polygon(amp_0, ang_W, r, phase, lambda, ...
				omega, S, C, NOISE, SNR_dB, ATTENUATION, DEBUG, resulution, d , N_antenas);

			[ ...
				choose_angle ...
				Rho ...
				ant_array ...
				Z_phase_array ...
				Z_x_array ...
				delta_A_x_B ...
				delta_B_x_A ...
			] = return_struct{:};

			% Calcular a figura de fundo para visualizacao em imagem
			z_plot = signal_r(x, y, t_0, amp_0, ang_W, r, phase, ...
				lambda, omega, S, C, NOISE, SNR_dB, ATTENUATION);

			% generate_fig_tri(
			generate_fig_polygon(
				z_plot,
				x,
				y,
				ang_W,
				lambda,
				interval,
				Rho,
				choose_angle,
				ant_array,
				Z_phase_array,
				Z_x_array,
				delta_A_x_B,
				delta_B_x_A
			)

		else
			generate_fig(x, y, t_0, amp_0, ang_W, r, phase, lambda, omega, S, C, ...
			NOISE, SNR_dB, ATTENUATION, DEBUG, interval, resulution, T, d);
		end %if

		drawnow;
		if SAVE_GIF
			frame = getframe(f);
			im = frame2im(frame);

			[imind, cm] = rgb2ind(im);
			if it == 1
				% Create GIF file
				imwrite(imind, cm, gif_filename,'gif','DelayTime', DelayTime , 'Compression' , 'lzw');
			else
				% Add each new plot to GIF
				imwrite(imind, cm, gif_filename,'gif','WriteMode','append','DelayTime', DelayTime , 'Compression' , 'lzw');
			end %if
		else
			% pause(1/30)
			pause(0.0001)
		end %if

		if SAVE_DAT
			fprintf(dat_file, "%.2f", percent*100);
			fprintf(dat_file, "\t%.3f", normalize_angle(ang_W));
			fprintf(dat_file, "\t%.3f", r);
			fprintf(dat_file, "\t%.3f", normalize_angle(phase));
			fprintf(dat_file, "\t%.3f", normalize_angle(choose_angle));

			for i = ant_idx_list
				fprintf(dat_file, "\t%.3f", normalize_angle(delta_A_x_B(i)));
			end % for
			for i = ant_idx_list
				fprintf(dat_file, "\t%.3f", normalize_angle(delta_B_x_A(i)));
			end % for

			fprintf(dat_file, "\n");
			fflush(dat_file);
		end % if

		percent = percent + ref_iteration;

	end %for

	if SAVE_GIF
		printf('Check: %s\a\n', gif_filename);
	end %if

	if SAVE_DAT
		fclose(dat_file);
		printf('Check: %s\a\n', dat_filename);
	end %if


end %function