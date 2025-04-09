function return_struct = calc_AoA_polygon(
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
	d,
	N_antenas
  )

	function Z_phase = phase_z(t, Z_antenna, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION)
			% Calculos de amostra I/Q para antena em (0,0)
		I_medido = trapz(t,ref_cos(t, omega_w) ...
			.* signal_r(real(Z_antenna), imag(Z_antenna), t, amp_w, ang_w, ...
			r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
		Q_medido = trapz(t,ref_sin(t, omega_w) ...
			.* signal_r(real(Z_antenna), imag(Z_antenna), t, amp_w, ang_w, ...
			r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

		Z_phase = (omega_w/pi)*(I_medido + i*Q_medido);
	end % function

	function [Z_phase_A_x_B angle_Z_A_x_B] = dephase_A_to_B(Z_phase_A, Z_phase_B)
		Z_phase_A_x_B = Z_phase_A * conj(Z_phase_B);
		deltaPhi_A_x_B = angle(Z_phase_A_x_B);
		angle_Z_A_x_B = acos(deltaPhi_A_x_B/(pi));
	end % function

	function [delta_A_x_B delta_B_x_A] = deltas_A_B(angle_Z_A_x_B, Z_antenna_A, Z_antenna_B)
		ang_A_x_B = deg2rad(mod(rad2deg(arg(Z_antenna_A - Z_antenna_B)),360));
		delta_A_x_B = ang_A_x_B + angle_Z_A_x_B;
		delta_B_x_A = ang_A_x_B - angle_Z_A_x_B;
	end % function

	% Raio do circulo de circunscreve o poligono com N lados de tamanho d
	Rho = d/(2*sin(pi / N_antenas));
	ant_angles_shift = -90;
	ant_angles = (0 + ant_angles_shift):(360/N_antenas):(359 + ant_angles_shift);

	% Coordenadas das antenas
	ant_array = Rho * exp(i * deg2rad(ant_angles));

	t = linspace(0,(2 * pi / omega_w), resulution); % Intervalo de integração

	% Calculos de fase
	Z_phase_array = arrayfun(@(a) phase_z(t, a, amp_w, ang_w, r_w, phase_w, ...
		lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION), ant_array);

	% Calculos de simetria
	[Z_x_array angle_Z_A_x_B_array] = arrayfun(@(a, b) dephase_A_to_B(a, b), ...
		Z_phase_array, circshift(Z_phase_array,-1));

	[delta_A_x_B delta_B_x_A] = arrayfun(@(ang, a, b) deltas_A_B(ang, a, b), ...
		angle_Z_A_x_B_array, ant_array, circshift(ant_array,-1));

	% % Fazer "votacao" de angulo escolhido
	% range_angle = 90/N_antenas;
	% precision = 10;

	% angle_vector = [delta_A_x_B delta_B_x_A];
	% angle_vector = mod(360+rad2deg(angle_vector),360); % Normalizar vetor de angulos
	% angle_vector_round = round(angle_vector./precision).*precision; % Simplificar contas

	% target_angle = mode(angle_vector_round); % Escolher angulo mais provavel

	% angle_vector = angle_vector(abs(target_angle - angle_vector) <= range_angle ); % Descartar improvaveis

	% choose_angle = median(angle_vector); % Calcular angulo provavel
	% choose_angle = deg2rad(choose_angle);


	% Fazer "votacao" de angulo escolhido
	range_angle_alt = pi/(2*(N_antenas+1));

	angle_vector_alt = [delta_A_x_B delta_B_x_A];
	angle_vector_alt = [...
		(angle_vector_alt(angle_vector_alt<0)+(2*pi)) ...
		(angle_vector_alt(0<=angle_vector_alt & angle_vector_alt<=(2*pi))) ...
		(angle_vector_alt((2*pi)<angle_vector_alt)-(2*pi)) ...
	]; % Normalizar vetor de angulos entre 0 e 2 pi

	% angle_vector_round_alt = round(angle_vector_alt.*(range_angle_alt*100))./(range_angle_alt*100);
	% angle_vector_round_alt = round(angle_vector_alt.*100)./(100);
	angle_vector_round_alt = round(angle_vector_alt./range_angle_alt).*range_angle_alt;
	% rad2deg(angle_vector_round_alt)
	target_angle_alt = mode(angle_vector_round_alt);
	% rad2deg(target_angle_alt)

	angle_vector_alt = angle_vector_alt(abs(target_angle_alt - angle_vector_alt) <= range_angle_alt ); % Descartar improvavei
	% rad2deg(angle_vector_alt)
	choose_angle_alt = median(angle_vector_alt); % Calcular angulo provavel
	% rad2deg(choose_angle_alt)

	% rad2deg(choose_angle)
	choose_angle = choose_angle_alt;
	% rad2deg(choose_angle)

	return_struct = { ...
		choose_angle ...
		Rho ...
		ant_array ...
		Z_phase_array ...
		Z_x_array ...
		delta_A_x_B ...
		delta_B_x_A ...
	};

end %function