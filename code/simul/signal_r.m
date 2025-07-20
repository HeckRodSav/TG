function res = signal_r( ...
	x_w, ... % coordenada x associada ao ponto da antena
	y_w, ... % coordenada y associada ao ponto da antena
	t_w, ... % tempo t associado ao instante de afericao do sinal
	amp_w, ... % amplitude desejada para o sinal
	ang_w, ... % angulo theta de chegada do sinal em relacao ao sistema de antenas
	r_w, ... % distancia que o emissor de sinal esta da coordenada (0,0) do sistema
	phase_w, ... % defasagem phi do sinal
	lambda_w, ... % comprimento de onda
	omega_w, ... % frequencia angular
	S, ... % utilizacao de funcao Seno
	C, ... % utilizacao de funcao Cosseno
	NOISE, ... % se o sinal contara com ruido
	SNR_dB, ... % relacao sinal-ruido
	ATT ... % se o sinal contara com atenuacao por distancia
) % Funcao de sinal senoidal

	res = 0;
	if S
		res = res + sin( argument_r(x_w, y_w, t_w, ang_w, r_w, phase_w, lambda_w, omega_w) );
	end %if
	if C
		res = res + cos( argument_r(x_w, y_w, t_w, ang_w, r_w, phase_w, lambda_w, omega_w) );
	end %if
	if S && C
		res = res / sqrt(2);
	end %if

	if ATT
		%%% Lei de Friis
		G_t = 1; % Ganho Antena Tx
		G_r = 1; % Ganho Antena Rx
		%%% Potencia eletrica
		R_t = 1; % Resistencia Antena Tx (Reatância)
		R_r = 1; % Resistencia Antena Rx (Reatância)
		%%%%%%%%%%%%%%%%%%%%%%%%

		P_t = (amp_w^2)/R_t;

		P_r = P_t * G_t * G_r * (lambda_w / (4 * pi * r_w));

		amp_r = sqrt(P_r * R_r);
		res = res * amp_r;
	else
		res = res * amp_w;
	end %if

	if NOISE
		res = awgn(res, SNR_dB, 'measured');
	end %if

end %function