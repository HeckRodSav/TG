function res = argument_r(...)
	r = r_w * lambda_w;

	x_0 = r * cos(ang_w);
	y_0 = r * sin(ang_w);

	res = (2*pi/lambda_w) * ( sqrt((y_w-y_0).^2 + ...
		(x_w-x_0).^2) ) + omega_w*t_w + phase_w;
end %function
