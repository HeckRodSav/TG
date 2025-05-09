function Z_phase = phase_z(...)
	I_medido = trapz(t, ref_cos(...) .* signal_r(...) );
	Q_medido = trapz(t, ref_sin(...) .* signal_r(...) );

	Z_phase = (omega_w/pi)*(I_medido + i*Q_medido);
end % function