function [Z_phase_A_x_B angle_Z_A_x_B] = dephase_A_to_B(...)
	Z_phase_A_x_B = Z_phase_A * conj(Z_phase_B);
	deltaPhi_A_x_B = angle(Z_phase_A_x_B);
	angle_Z_A_x_B = acos(deltaPhi_A_x_B/(pi));
end % function