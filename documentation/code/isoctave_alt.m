function r = isoctave ()
	persistent x;
	if (isempty (x))
		x = exist ('OCTAVE_VERSION', 'builtin');
	end
	r = x;
end
