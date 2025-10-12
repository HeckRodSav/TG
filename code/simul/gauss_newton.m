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
	it, ...
	P_b_estimado ...
)

	% Distancia entre pares de Locators
	Rho = d/(2*sin(pi / N_antenas));

	% Posicao Locators
	locator_pair = [ -(d/2) (d/2) ];

	x_L = [0 Rho -Rho]';
	y_L = zeros(size(x_L));
	aux_ones = ones(size(x_L));
	aux_ant_array = x_L + (aux_ones * locator_pair);

	% ant_array = aux_ant_array'(:)';
	ant_matrix = aux_ant_array;

	% ant_array = [ locator_pair Rho+locator_pair -Rho+locator_pair ];

	% P_b_estimado = [0.1, 0.1]; % [x, y]

	t = linspace(0,(2 * pi / omega_w), resolution); % Intervalo de integração

	for iteration = 1:5

		% % Calculos de fase
		% Z_phase_array = arrayfun(@(a) phase_z(t, a, amp_w, ...
		% 	ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, ...
		% 	SNR_dB, ATT), ant_array);
		% Calculos de fase
		Z_phase_matrix = arrayfun(@(a) phase_z(t, a, amp_w, ...
			ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, ...
			SNR_dB, ATT), ant_matrix);
		% Z_phase_matrix'(:)'

		[Z_x_L phi_L] = arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(:,2), Z_phase_matrix(:,1));
		% deltaPhi_L = angle(Z_x_L);
		% phi_L = asin(deltaPhi_L/(pi));

		% [Z_x_L_1 phi_L_1] = arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(1,2), Z_phase_matrix(1,1));
		% % deltaPhi_L_1 = angle(Z_x_L_1);
		% % phi_L_1 = asin(deltaPhi_L_1/(pi));

		% [Z_x_L_2 phi_L_2] = arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(2,2), Z_phase_matrix(2,1));
		% % deltaPhi_L_2 = angle(Z_x_L_2);
		% % phi_L_2 = asin(deltaPhi_L_2/(pi));

		% [Z_x_L_3 phi_L_3] = arrayfun(@(a,b) dephase_A_to_B(a, b), Z_phase_matrix(3,2), Z_phase_matrix(3,1));
		% % deltaPhi_L_3 = angle(Z_x_L_3);
		% % phi_L_3 = asin(deltaPhi_L_3/(pi));

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
		% phi_medido = atan((y_L-y_B)./(x_L-x_B))
		% phi_medido_1 = atan((y_L(1)-y_B)/(x_L(1)-x_B))
		% phi_medido_2 = atan((y_L(2)-y_B)/(x_L(2)-x_B))
		% phi_medido_3 = atan((y_L(3)-y_B)/(x_L(3)-x_B))

		phi_estimado = atan2((y_L-P_b_estimado(2)),(x_L-P_b_estimado(1)));
		% phi_estimado = atan((y_L-P_b_estimado(2))./(x_L-P_b_estimado(1)))
		% phi_estimado_1 = atan((y_L(1)-P_b_estimado(2))/(x_L(1)-P_b_estimado(1)))
		% phi_estimado_2 = atan((y_L(2)-P_b_estimado(2))/(x_L(2)-P_b_estimado(1)))
		% phi_estimado_3 = atan((y_L(3)-P_b_estimado(2))/(x_L(3)-P_b_estimado(1)))

		A = (phi_medido - phi_estimado);
		% A_1 = phi_medido_1 - phi_estimado_1
		% A_2 = phi_medido_2 - phi_estimado_2
		% A_3 = phi_medido_3 - phi_estimado_3

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