function return_struct = music_ULA ( ...
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
	% M = N_antenas;
	% wavelength = lambda_w;
	% x = Z_phase_matrix;
	N = 100;  % Number of samples

	ant_array = complex(0,d.*(0:N_antenas-1)')';

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
	function doa_estimates = music_algorithm(x, M, K, d, wavelength)
		% Compute the MUSIC spectrum
		theta = (-pi/2):0.05:(pi/2);
		[Vn, Pmusic] = compute_music_spectrum(x, M, K, d, wavelength, theta);
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
			error_function = @(x) abs(1 / abs((a(x, d, M, wavelength)' * Vn) * (Vn' * a(x, d, M, wavelength))) - Pmusic(doa_indices(i)));
			doa_estimates(i) = fminsearch(error_function, initial_DoAs(i));
		end
		% If less than K estimates were found, fill the remaining ones with NaN
		if length(doa_estimates) < K
			doa_estimates = [doa_estimates, nan(1, K - length(doa_estimates))];
		end
	end

	% Function to compute the MUSIC spectrum
	function [Vn, Pmusic] = compute_music_spectrum(x, M, K, d, wavelength, theta)
		Rxx = (x * x') / size(x, 2);
		[V, D] = eig(Rxx);
		[~, idx] = sort(diag(D), 'descend');
		V = V(:, idx);
		Vn = V(:, K+1:end);
		% Calculate the MUSIC spectrum
		% Pmusic = arrayfun(@(angle) 1 / abs((a(angle, d, M, wavelength)' * Vn) * (Vn' * a(angle, d, M, wavelength))), theta);

    	Pmusic = arrayfun(@(angle) 1 / abs((a(angle, d, M, wavelength)' * Vn) * (Vn' * a(angle, d, M, wavelength))), theta);

	end

	% Function to compute steering vector (linear)
	function a_vec = a(angle, d, M, wavelength)
		% Frank Gross - Smart Antennas for Wireless Communications, pg. 69 [87]
		a_vec = exp(-1i*d*(0:M-1)'*sin(angle)*2*pi/wavelength);
	end

	% Apply the algorithm
	choose_angle = music_algorithm(Z_phase_matrix, N_antenas, K, d, lambda_w)

	return_struct = { ...
		choose_angle, ...
	};


end %function