function r = isoctave () % Confere se esta executando no octave ou nao
	persistent x;
	if (isempty (x))
		x = exist ('OCTAVE_VERSION', 'builtin');
	end
	r = x;
end
