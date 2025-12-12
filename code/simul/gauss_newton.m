function return_struct = gauss_newton( ...
	amp_w, ...
	ang_w, ...
	r_w, ...
	phase_w, ...
	lambda_w, ...
	omega_w, ...
	S, ...
	C, ...
	NOISE, ...
	SNR_dB, ...
	ATT, ...
	resolution, ...
	d, ...
	N_antenas, ...
	P_b_estimado ...
)

	% Distancia entre pares de Locators
	Rho = d/(2*sin(pi / N_antenas));

	% Posicao Locators
	locator_pair = [ -(d/2) (d/2) ];

	N_pairs_alt = floor(N_antenas/2);

	x_L = (-N_pairs_alt:N_pairs_alt)';

	y_L = zeros(size(x_L));
	aux_ones = ones(size(x_L));
	aux_ant_array = x_L + (aux_ones * locator_pair);

	ant_matrix = aux_ant_array;

	t = linspace(0,(2 * pi / omega_w), resolution); % Intervalo de integração

	for iteration = 1:5

		% % Calculos de fase
		Z_phase_matrix = arrayfun(@(a) phase_z(t, a, amp_w, ...
			ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, ...
			SNR_dB, ATT), ant_matrix);

		[Z_x_L phi_L] = arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(:,2), Z_phase_matrix(:,1));

		% Posicao_B lido
		% Coordenada X do emissor em relação ao sistema
		x_B = (y_L(2) - y_L(1) + tan(phi_L(1)) * x_L(1) - tan(phi_L(2)) * x_L(2)) / (tan(phi_L(1)) - tan(phi_L(2)));

		% Coordenada Y do emissor em relação ao sistema
		y_B = y_L(1) - tan(phi_L(1)) * (x_L(1) - x_B);

		% Componente Z desconsiderada
		% z_B

		if iteration == 1
			P_b_estimado = [x_B, y_B];
		end % if

		phi_medido = atan2((y_L-y_B),(x_L-x_B));

		phi_estimado = atan2((y_L-P_b_estimado(2)),(x_L-P_b_estimado(1)));

		A = (phi_medido - phi_estimado);

		function res = phi_dxB(x_L, x_B, y_L, y_B)
			res = (y_L - y_B)./(-2 .* x_L .* x_B + x_B.^2 + (y_L - y_B).^2 + x_L.^2);
		end % function

		function res = phi_dyB(x_L, x_B, y_L, y_B)
			res = (x_B - x_L)./(-2 .* x_L .* x_B + x_B.^2 + (y_L - y_B).^2 + x_L.^2);
		end % function

		% arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(:,1), Z_phase_matrix(:,2));
		Jacobiano = [ phi_dxB(x_L, P_b_estimado(1), y_L, P_b_estimado(2)) ...
			phi_dyB(x_L, P_b_estimado(1), y_L, P_b_estimado(2)) ];

		deltas = (inv(Jacobiano * Jacobiano') * Jacobiano)' * A;

		P_b_estimado(1) = P_b_estimado(1) + deltas(1);
		P_b_estimado(2) = P_b_estimado(2) + deltas(2);

		choose_angle = angle(P_b_estimado(1) + i * P_b_estimado(2));

	end % for

	return_struct = { ...
		choose_angle, ...
		P_b_estimado ...
		% Rho ...
		% ant_array ...
		% Z_phase_array ...
		% Z_x_array ...
		% delta_A_x_B ...
		% delta_B_x_A ...
	};


end %function