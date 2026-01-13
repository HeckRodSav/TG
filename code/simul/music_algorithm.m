function doa_estimates = music_algorithm( ...
	Z_phase_matrix, ...
	D_signals, ...
	AoA_range, ...
	steering_function, ...
	steering_arguments ...
)

	% Compute the MUSIC spectrum
	[Vn, Pmusic] = music_spectrum(Z_phase_matrix, D_signals, AoA_range, ...
		steering_function, steering_arguments);

	% Find the initial estimates of DoAs
	[~, doa_indices] = sort(Pmusic, 'descend');

	% If more than D_signals peaks are found, select the D_signals largest ones
	if length(doa_indices) > D_signals
		doa_indices = doa_indices(1:D_signals);
	end

	initial_DoAs = AoA_range(doa_indices);
	doa_estimates = initial_DoAs;

	% % Refine the DoAs using fminsearch
	% doa_estimates = zeros(1, D_signals);
	% for i = 1:length(initial_DoAs)
	% 	error_function = @(steering_angle) abs(1 / abs( ...
	% 		(steering_function(steering_angle, steering_arguments)' * Vn) * ...
	% 		(Vn' * steering_function(steering_angle, steering_arguments)) ...
	% 		) - Pmusic(doa_indices(i)));
	% 	doa_estimates(i) = fminsearch(error_function, initial_DoAs(i));
	% end
	% % If less than D_signals estimates were found, fill the remaining ones with NaN
	% if length(doa_estimates) < D_signals
	% 	doa_estimates = [doa_estimates, nan(1, D_signals - length(doa_estimates))];
	% end
end
