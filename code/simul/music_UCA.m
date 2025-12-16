function return_struct = music_UCA ( ...
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
	N_antenas ...
)

	choose_angle = nan;
	K = 1;
	% wavelength = lambda_w;
	% x = Z_phase_matrix;
	N = 100;  % Number of samples

	% Raio do circulo de circunscreve o poligono com N lados de tamanho d
	Rho = d/(2*sin(pi / N_antenas));
	ant_angles_shift = -90;
	ant_angles = (0 + ant_angles_shift):(360/N_antenas):(359 + ant_angles_shift);

	% Coordenadas das antenas
	ant_array = Rho * exp(i * deg2rad(ant_angles));

	t = linspace(0,(2 * pi / omega_w), resolution); % Intervalo de integração

	Z_phase_matrix = [];

	for i = 1:N
		% Calculos de fase
		Z_phase_array = arrayfun(@(a) phase_z(t, a, amp_w, ...
			ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, ...
			SNR_dB, ATT), ant_array);

		Z_phase_matrix = [Z_phase_matrix Z_phase_array.'];

	end % for


	% Algorithm function
	function doa_estimates = music_algorithm(x, ant_angles, K, rho, wavelength)

		% Compute the MUSIC spectrum
		theta = 0:0.001:2*pi;
		[Vn, Pmusic] = compute_music_spectrum(x, ant_angles, K, rho, wavelength, theta);
		% Find the initial estimates of DoAs
		[~, doa_indices] = sort(Pmusic, 'descend');
		% If more than K peaks are found, select the K largest ones
		if length(doa_indices) > K
			doa_indices = doa_indices(1:K);
		end
		initial_DoAs = theta(doa_indices);
		% Refine the DoAs using fminsearch
		doa_estimates = zeros(1, K);
		for i = 1:length(initial_DoAs)
			error_function = @(x) abs(1 / abs((b(x, rho, ant_angles, wavelength)' * Vn) * (Vn' * b(x, rho, ant_angles, wavelength))) - Pmusic(doa_indices(i)));
			doa_estimates(i) = fminsearch(error_function, initial_DoAs(i));
		end
		% If less than K estimates were found, fill the remaining ones with NaN
		if length(doa_estimates) < K
			doa_estimates = [doa_estimates, nan(1, K - length(doa_estimates))];
		end
	end

	% Function to compute the MUSIC spectrum
	function [Vn, Pmusic] = compute_music_spectrum(x, ant_angles, K, rho, wavelength, theta)
		Rxx = (x * x') / size(x, 2);
		[V, D] = eig(Rxx);
		[~, idx] = sort(diag(D), 'descend');
		V = V(:, idx);
		Vn = V(:, K+1:end);
		% Calculate the MUSIC spectrum

		Pmusic = arrayfun(@(angle) 1 / abs((b(angle, rho, ant_angles, wavelength)' * Vn) * (Vn' * b(angle, rho, ant_angles, wavelength))), theta);
	end

	% Function to compute steering vector (circular)
	function b_vec = b(angle, rho, ant_angles, wavelength)
		% Frank Gross - Smart Antennas for Wireless Communications, pg. 90 [108]
		ant_angles_rad = deg2rad(ant_angles)';
		b_vec = exp(1i*rho*cos(angle-ant_angles_rad)*2*pi/wavelength);
	end

	% Apply the algorithm
	choose_angle = music_algorithm(Z_phase_matrix, ant_angles, K, Rho, lambda_w);

	return_struct = { ...
		choose_angle, ...
	};


end %function