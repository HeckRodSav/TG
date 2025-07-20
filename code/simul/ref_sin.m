function s = ref_sin( ...
	t_w, ... % tempo t associado ao instante de afericao do sinal
	omega_w ... % frequencia angular
) % Funcao auxiliar de sinal seno
	s = sin(argument_r(0, 0, t_w, 0, 0, 0, 1, omega_w));
end %function