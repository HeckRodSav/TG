function return_struct = calc_AoA(
	amp_w,
	ang_w,
	r_w,
	phase_w,
	lambda_w,
	omega_w,
	S,
	C,
	NOISE,
	SNR_dB,
	ATTENUATION,
	DEBUG,
	resulution,
	d
  )

	function Z_phase = phase_z(t, Z_antenna, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION)
			% Calculos de amostra I/Q para antena em (0,0)
		C_medido = trapz(t,ref_cos(t, omega_w) ...
			.* signal_r(real(Z_antenna), imag(Z_antenna), t, amp_w, ang_w, ...
			r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
		S_medido = trapz(t,ref_sin(t, omega_w) ...
			.* signal_r(real(Z_antenna), imag(Z_antenna), t, amp_w, ang_w, ...
			r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

		Z_phase = (omega_w/pi)*(C_medido + i*S_medido);
	end % function

	function [Z_phase_A_x_B angle_Z_A_x_B] = dephase_A_to_B(Z_phase_A, Z_phase_B)
		Z_phase_A_x_B = Z_phase_A * conj(Z_phase_B);
		deltaPhi_A_x_B = angle(Z_phase_A_x_B);
		angle_Z_A_x_B = acos(deltaPhi_A_x_B/(pi));
	end % function

	function [delta_A_x_B delta_B_x_A] = deltas_A_B(angle_Z_A_x_B, Z_antenna_A, Z_antenna_B)
		ang_A_x_B = deg2rad(mod(rad2deg(arg(Z_antenna_A - Z_antenna_B)),360));
		% ang_A_x_B = (ang_A_x_B);
		delta_A_x_B = ang_A_x_B + angle_Z_A_x_B;
		delta_B_x_A = ang_A_x_B - angle_Z_A_x_B;
	end % function


	% Numero de antenas
	N_antenas = 3;

	% Raio do circulo de circunscreve o poligono com N lados de tamanho d
	Rho = d/(2*sin(pi / N_antenas));
	ant_angles_shift = -90;
	ant_angles = (0 + ant_angles_shift):(360/N_antenas):(359+ ant_angles_shift);

	% Coordenadas das antenas
	ant_SS = Rho * exp(i * deg2rad(ant_angles(1))); % 270°
	ant_NE = Rho * exp(i * deg2rad(ant_angles(2))); % 30°
	ant_NO = Rho * exp(i * deg2rad(ant_angles(3))); % 150°

	t = linspace(0,(2 * pi / omega_w),resulution); % Intervalo de integração

	% Calculos de fase
	Z_phase_SS = phase_z(t, ant_SS, amp_w, ang_w, r_w, phase_w, lambda_w, ...
	omega_w, S, C, NOISE, SNR_dB, ATTENUATION);

	Z_phase_NE = phase_z(t, ant_NE, amp_w, ang_w, r_w, phase_w, lambda_w, ...
	omega_w, S, C, NOISE, SNR_dB, ATTENUATION);

	Z_phase_NO = phase_z(t, ant_NO, amp_w, ang_w, r_w, phase_w, lambda_w, ...
	omega_w, S, C, NOISE, SNR_dB, ATTENUATION);


	% Calculos de simetria
	[Z_SS_x_NE angle_Z_SS_x_NE] = dephase_A_to_B(Z_phase_SS, Z_phase_NE);
	[Z_NO_x_SS angle_Z_NO_x_SS] = dephase_A_to_B(Z_phase_NO, Z_phase_SS);
	[Z_NE_x_NO angle_Z_NE_x_NO] = dephase_A_to_B(Z_phase_NE, Z_phase_NO);


	[delta_SS_x_NE delta_NE_x_SS] = deltas_A_B(angle_Z_SS_x_NE, ant_SS, ant_NE);
	[delta_NO_x_SS delta_SS_x_NO] = deltas_A_B(angle_Z_NO_x_SS, ant_NO, ant_SS);
	[delta_NE_x_NO delta_NO_x_NE] = deltas_A_B(angle_Z_NE_x_NO, ant_NE, ant_NO);


	% Fazer "votacao" de angulo escolhido
	precision = 10;

	angle_vector = [delta_SS_x_NE delta_NE_x_SS delta_NO_x_SS delta_SS_x_NO delta_NE_x_NO delta_NO_x_NE];
	angle_vector = mod(360+rad2deg(angle_vector),360); % Normalizar vetor de angulos

	angle_vector_round = round(angle_vector./precision).*precision; % Simplificar contas

	target_angle = mode(angle_vector_round); % Escolher angulo mais provavel

	angle_vector = angle_vector((target_angle - precision) < angle_vector & angle_vector < (target_angle + precision)); % Descartar improvaveis
	% angle_vector = angle_vector(angle_vector < (target_angle + precision)); % Descartar improvaveis

	choose_angle = median(angle_vector); % Calcular angulo provavel
	choose_angle = deg2rad(choose_angle);

	ant_array = [ant_SS ant_NE ant_NO];

	Z_phase_array = [Z_phase_SS Z_phase_NE Z_phase_NO];

	Z_x_array = [Z_SS_x_NE Z_NE_x_NO Z_NO_x_SS];

	delta_A_x_B = [delta_SS_x_NE delta_NE_x_NO delta_NO_x_SS];
	delta_B_x_A = [delta_NE_x_SS delta_NO_x_NE delta_SS_x_NO];

	return_struct = { ...
		choose_angle ...
		Rho ...
		ant_array ...
		Z_phase_array ...
		Z_x_array ...
		delta_A_x_B ...
		delta_B_x_A ...
	};


	% Exibir valores
	if DEBUG
		printf('C_SS = %.2f\n',C_SS);
		printf('C_NE = %.2f\n',C_NE);
		printf('C_NO = %.2f\n',C_NO);
		disp('')
		printf('S_SS = %.2f\n',S_SS);
		printf('S_NE = %.2f\n',S_NE);
		printf('S_NO = %.2f\n',S_NO);
		disp('')
		printf('Z_phase_SS = %.2f*\n',rad2deg(Z_phase_SS));
		printf('Z_phase_NE = %.2f*\n',rad2deg(Z_phase_NE));
		printf('Z_phase_NO = %.2f*\n',rad2deg(Z_phase_NO));
		disp('')
		printf('delta_SS_x_NE = %.2f*\n',rad2deg(delta_SS_x_NE));
		printf('delta_NO_x_SS = %.2f*\n',rad2deg(delta_NO_x_SS));
		printf('delta_NE_x_NO = %.2f*\n',rad2deg(delta_NE_x_NO));
		disp('')
	end %if

end %function