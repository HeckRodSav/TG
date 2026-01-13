function file_adress = w_xyt( ...
	NOISE, ...
	ATT, ...
	CHG_PHI, ...
	CHG_R, ...
	CHG_THETA, ...
	S_GIF, ...
	S_DAT, ...
	SNR, ...
	range_step, ...
	N_antenas ...
)

	function ang_norm = normalize_angle(ang)
		ang_norm = ang;
		if ang > pi
			ang_norm = ang_norm - (2*pi);
		end % if
		if ang < -pi
			ang_norm = ang_norm + (2*pi);
		end % if
	end % function

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	DEBUG = false;

	USE_GEOMETRIC = true;
	USE_MSC_ULA = true;
	USE_MSC_UCA = true;
	USE_GN = false;

	% Evitar processar dados que nao serao salvos
	USE_MSC_ULA = (S_DAT && USE_MSC_ULA);
	USE_MSC_UCA = (S_DAT && USE_MSC_UCA);
	USE_GN = (S_DAT && USE_GN);

	CALC_R2 = true;

	SNR_dB = 10*log10(SNR);

	phase = 0;

	R_upper = 50;
	R_lower = 1;

	range_shift = 0;

	DoA_range = (0+range_shift):range_step:(360+range_shift-1);
	DoA = deg2rad(DoA_range);

	limits = 2; % -+ * Lambda

	c = 1; % Velocidade da luz, simplificacao
	lambda = 4;
	omega = 2*pi*c/lambda;
	d = lambda / 2;
	T = 2 * pi / omega;

	amp_0 = 1;

	C = true;
	S = true;

	interval = limits*lambda;
	resolution = 100;

	space = linspace(-interval,interval,resolution+1); % 1-by-100
	[x, y] = meshgrid(space);
	t_0 = 0;

	ant_idx_list = 1:1:N_antenas;
	ant_idx_list_shift = circshift(ant_idx_list, 1);

	name = 'simul';
	folder = '';

	name = [name '_POLY_' num2str(N_antenas)];
	folder = [folder 'POLY_' num2str(N_antenas)];

	if CHG_R
		name = [name '_R_' num2str(R_upper) '~' num2str(R_lower) ];
	else
		name = [name '_R_' num2str(R_upper)];
	end %if
	if ~CHG_THETA
		name = [name '_FIXED_W'];
	end %if
	if NOISE
		name = [name '_SNR_' num2str(SNR)];
	end %if
	if ATT
		name = [name '_ATT'];
	end %if

	if (S_GIF || S_DAT)
		foldername = fullfile('Output', folder);
		if not(isfolder(foldername))
			mkdir(foldername);
		end %if
		if S_GIF
			gif_filename = fullfile(foldername, [name '.gif']);
		end %if
		if S_DAT
			dat_filename = fullfile(foldername, [name '.dat']);
		end %if
		if (S_DAT && CALC_R2)
			dat_r2_filename = fullfile(foldername, [name '.r2.dat']);
		end %if
	end %if

	if USE_GEOMETRIC
		if S_GIF
			if isoctave()
				f = figure(1, 'name', name, 'visible', 'off', 'Position', [1 1 1000 500]);
			else % MATLAB
				f = figure('name', name, 'visible', 'off', 'Position', [1 1 1000 500]);
			end % if

		else
			f = figure('name', name);
		end %if
	end %if

	if S_DAT
		dat_file = fopen(dat_filename, 'w');
		fprintf(dat_file, '%s', 'percent');
		fprintf(dat_file, '\t%s', 'ang_W');
		fprintf(dat_file, '\t%s', 'r');
		fprintf(dat_file, '\t%s', 'phase');
		if USE_GEOMETRIC
			fprintf(dat_file, '\t%s', 'choose_angle_GEOMETRIC');
		end % if
		if USE_MSC_ULA
			fprintf(dat_file, '\t%s', 'choose_angle_MSC_ULA');
		end % if
		if USE_MSC_UCA
			fprintf(dat_file, '\t%s', 'choose_angle_MSC_UCA');
		end % if
		if USE_GN
			fprintf(dat_file, '\t%s', 'choose_angle_GN');
		end % if
		if USE_GEOMETRIC
			for i = ant_idx_list
				fprintf(dat_file, '\t%s%d_x_%d', 'delta_', i, ant_idx_list_shift(i));
			end % for
			for i = ant_idx_list
				fprintf(dat_file, '\t%s%d_x_%d', 'delta_', ant_idx_list_shift(i), i);
			end % for
		end % if
		fprintf(dat_file, '\n');
		if isoctave()
			fflush(dat_file);
		end %if
	end % if

	if (S_DAT && CALC_R2)
		angles_DOA = [];
		if USE_GEOMETRIC
			angles_GEOMETRIC = [];
		end % if
		if USE_MSC_ULA
			angles_MSC_ULA = [];
		end % if
		if USE_MSC_UCA
			angles_MSC_UCA = [];
		end % if
		if USE_GN
			angles_GN = [];
		end % if
	end % if

	DoA_loop_range = [DoA_range DoA_range 360]; % Duas voltas

	percent = 0;
	ref_iteration = 1/(length(DoA_loop_range)-1);
	it = 0;
	DelayTime = 15*ref_iteration;
	r = R_upper+R_lower;

	for DoA = DoA_loop_range
		it = it + 1;

		fprintf('%.2f%% -> %s\n', percent*100, name);

		if CHG_PHI
			phase = phase + 2*pi*ref_iteration;
		end %if

		if CHG_R
			r = r - R_upper/(2*length(DoA_range));
		end %if

		if CHG_THETA
			ang_W = deg2rad(DoA);
		else
			ang_W = pi*5/12;
		end %if

		% ang = normalize_angle(ang_W)
		if (S_DAT && CALC_R2)
			angles_DOA = [angles_DOA; ang_W];
		end % if

		if USE_GEOMETRIC
			return_struct = calc_AoA_geometric(amp_0, ang_W, r, phase, lambda, ...
				omega, S, C, NOISE, SNR_dB, ATT, resolution, d , N_antenas);

			[ ...
				choose_angle_GEOMETRIC, ...
				Rho, ...
				ant_array, ...
				Z_phase_array, ...
				Z_x_array, ...
				delta_A_x_B, ...
				delta_B_x_A, ...
			] = return_struct{:};
			if (S_DAT && CALC_R2)
				angles_GEOMETRIC = [angles_GEOMETRIC; choose_angle_GEOMETRIC];
			end % if
		end % if

		if USE_MSC_ULA
			return_struct = calc_AoA_music_ULA(amp_0, ang_W, r, phase, lambda, ...
				omega, S, C, NOISE, SNR_dB, ATT, resolution, d , N_antenas);

			[ ...
				choose_angle_MSC_ULA, ...
			] = return_struct{:};
			if (S_DAT && CALC_R2)
				angles_MSC_ULA = [angles_MSC_ULA; choose_angle_MSC_ULA];
			end % if
		end % if

		if USE_MSC_UCA
			return_struct = calc_AoA_music_UCA(amp_0, ang_W, r, phase, lambda, ...
				omega, S, C, NOISE, SNR_dB, ATT, resolution, d , N_antenas);

			[ ...
				choose_angle_MSC_UCA, ...
			] = return_struct{:};
			if (S_DAT && CALC_R2)
				angles_MSC_UCA = [angles_MSC_UCA; choose_angle_MSC_UCA];
			end % if
		end % if

		if USE_GN
			return_struct = calc_AoA_gauss_newton(amp_0, ang_W, r, phase, lambda, ...
				omega, S, C, NOISE, SNR_dB, ATT, resolution, d , N_antenas);

			[ ...
				choose_angle_GN, ...
			] = return_struct{:};
			if (S_DAT && CALC_R2)
				angles_GN = [angles_GN; choose_angle_GN];
			end % if
		end % if

		if USE_GEOMETRIC
			% Calcular a figura de fundo para visualizacao em imagem
			z_plot = signal_r(x, y, t_0, amp_0, ang_W, r, phase, ...
				lambda, omega, S, C, NOISE, SNR_dB, ATT);

			generate_fig( ...
				z_plot, ...
				x, ...
				y, ...
				ang_W, ...
				lambda, ...
				interval, ...
				Rho, ...
				choose_angle_GEOMETRIC, ...
				ant_array, ...
				Z_phase_array, ...
				Z_x_array, ...
				delta_A_x_B, ...
				delta_B_x_A ...
			);

			drawnow;

			if S_GIF
				frame = getframe(f);
				im = frame2im(frame);

				[imind, cm] = rgb2ind(im);
				% [imind, cm] = rgb2ind(RGB, im); % MATLAB
				if it == 1
					% Create GIF file
					if isoctave()
						imwrite(imind, cm, gif_filename,'gif','DelayTime', DelayTime , 'Compression' , 'lzw');
					else % MATLAB
						imwrite(imind, cm, gif_filename,'gif','DelayTime', DelayTime);
					end % if
				else
					% Add each new plot to GIF
					if isoctave()
						imwrite(imind, cm, gif_filename,'gif','WriteMode','append','DelayTime', DelayTime , 'Compression' , 'lzw');
					else
						imwrite(imind, cm, gif_filename,'gif','WriteMode','append','DelayTime', DelayTime); % MATLAB
					end % if
				end %if
			else
				% pause(1/30)
				pause(0.0001)
			end %if

		end % if

		if S_DAT
			fprintf(dat_file, '%.2f', percent*100);
			fprintf(dat_file, '\t%.3f', normalize_angle(ang_W));
			fprintf(dat_file, '\t%.3f', r);
			fprintf(dat_file, '\t%.3f', normalize_angle(phase));
			if USE_GEOMETRIC
				fprintf(dat_file, '\t%.3f', normalize_angle(choose_angle_GEOMETRIC));
			end % if
			if USE_MSC_ULA
				fprintf(dat_file, '\t%.3f', normalize_angle(choose_angle_MSC_ULA));
			end % if
			if USE_MSC_UCA
				fprintf(dat_file, '\t%.3f', normalize_angle(choose_angle_MSC_UCA));
			end % if
			if USE_GN
				fprintf(dat_file, '\t%.3f', normalize_angle(choose_angle_GN));
			end % if

			if USE_GEOMETRIC
				for i = ant_idx_list
					fprintf(dat_file, '\t%.3f', normalize_angle(delta_A_x_B(i)));
				end % for
				for i = ant_idx_list
					fprintf(dat_file, '\t%.3f', normalize_angle(delta_B_x_A(i)));
				end % for
			end % if

			fprintf(dat_file, '\n');
			if isoctave()
				fflush(dat_file);
			end %if
		end % if

		percent = percent + ref_iteration;

	end %for

	if (S_DAT && CALC_R2)
		% Coefficient of determination
		if (USE_MSC_ULA || USE_GN)
			abs_angles_DOA = arrayfun(@(ang) abs(normalize_angle(ang)), angles_DOA);
		end % if
		if USE_GEOMETRIC
			r2_GEOMETRIC = (corr(angles_DOA, angles_GEOMETRIC))^2;
		end % if
		if USE_MSC_ULA
			r2_MSC_ULA = (corr(((abs_angles_DOA)), (angles_MSC_ULA)))^2;
		end % if
		if USE_MSC_UCA
			r2_MSC_UCA = (corr(angles_DOA, angles_MSC_UCA))^2;
		end % if
		if USE_GN
			r2_GN = (corr(abs_angles_DOA, angles_GN))^2;
		end % if
	end % if

	fprintf('\n');

	if S_GIF
		fprintf('Check: %s\a\n', gif_filename);
	end %if

	if S_DAT
		fclose(dat_file);
		fprintf('Check: %s\a\n', dat_filename);
	end %if

	if (S_DAT && CALC_R2)
		dat_r2_file = fopen(dat_r2_filename, 'w');
		if USE_GEOMETRIC
			fprintf(dat_r2_file, '%s\t', 'GEOMETRIC');
		end % if
		if USE_MSC_ULA
			fprintf(dat_r2_file, '%s\t', 'MSC_ULA');
		end % if
		if USE_MSC_UCA
			fprintf(dat_r2_file, '%s\t', 'MSC_UCA');
		end % if
		if USE_GN
			fprintf(dat_r2_file, '%s\t', 'GN');
		end % if
		fprintf(dat_r2_file, '\n');

		if USE_GEOMETRIC
			fprintf(dat_r2_file, '%.2f\t', 100*r2_GEOMETRIC);
		end % if
		if USE_MSC_ULA
			fprintf(dat_r2_file, '%.2f\t', 100*r2_MSC_ULA);
		end % if
		if USE_MSC_UCA
			fprintf(dat_r2_file, '%.2f\t', 100*r2_MSC_UCA);
		end % if
		if USE_GN
			fprintf(dat_r2_file, '%.2f\t', 100*r2_GN);
		end % if
		fprintf(dat_r2_file, '\n');

		fclose(dat_r2_file);
		fprintf('Check: %s\a\n', dat_r2_filename);
	end %if

	fprintf('\n%s\n\n', repelem('-',70));

	file_adress = { ...
		foldername, ...
		name, ...
	};


end %function