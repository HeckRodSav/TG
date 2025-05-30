function [delta_A_x_B delta_B_x_A] = deltas_A_B(...)
	ang_A_x_B = deg2rad(mod(rad2deg(...
		angle(Z_antenna_A - Z_antenna_B)),360));
	delta_A_x_B = ang_A_x_B + angle_Z_A_x_B;
	delta_B_x_A = ang_A_x_B - angle_Z_A_x_B;
end % function