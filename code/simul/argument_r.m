function res = argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w, phase_w)
	% Argumento da funcao senoidal
	% x_w = coordenada x associada ao ponto da antena
	% y_w = coordenada y associada ao ponto da antena
	% t_w = tempo t associado ao instante de afericao do sinal
	% ang_w = angulo theta de chegada do sinal em relacao ao sistema de antenas
	% r_w = distância que o emissor de sinal está da coordenada (0,0) do sistema
	% lambda_w = comprimento de onda
	% omega_w = frequencia angular
	% phase_w = defasagem do sinal no emissor

	r = r_w * lambda_w;

	x_0 = r * cos(ang_w);
	y_0 = r * sin(ang_w);
	% y_0 = r * 10;

	res = (2*pi/lambda_w) * ( sqrt((y_w-y_0).^2 + (x_w-x_0).^2) ) + omega_w*t_w + phase_w;
end %function
