function res = signal_r(...)
	res = 0;
	if S
		res = res + sin( argument_r(...) );
	end %if
	if C
		res = res + cos( argument_r(...) );
	end %if
	if S && C
		res = res / sqrt(2);
	end %if
	if ATT
		%%% Lei de Friis
		G_t = 1; % Ganho Antena Tx
		G_r = 1; % Ganho Antena Rx
		R_t = 1; % Distância do emissor
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		P_t = (amp_w^2)/R_t;
		P_r = P_t * G_t * G_r * (lambda_w / (4 * pi * r_w));
		amp_r = sqrt(P_r * R_t);
		res = res * amp_r;
	else
		res = res * amp_w;
	end %if
	if NOISE
		res = awgn(res, SNR_dB, 'measured');
	end %if
end %function