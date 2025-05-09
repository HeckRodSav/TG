function generate_fig(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION, DEBUG, interval, resulution, T, d)

	% Calcular a figura de fundo para visualizacao em imagem
	z = signal_r(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, ...
	lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION);

	if ~DEBUG

		t = linspace(0,T,resulution);

		% Calculos de amostra I/Q para antena em (0,0)
		C_00 = trapz(t,ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
		S_00 = trapz(t,ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

		Z_00 = 2*(S_00 + 1i*C_00);

		% Calculos de amostra I/Q para antena em (0,d)
		C_0d = trapz(t, ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
		S_0d = trapz(t, ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

		Z_0d = 2*(S_0d + 1i*C_0d);

		% Calculos de amostra I/Q para antena em (d, 0)
		C_d0 = trapz(t, ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
		S_d0 = trapz(t, ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

		Z_d0 = 2*(S_d0 + 1i*C_d0);


		% Calculo de defasagem entre antenas 0d e 00 (Eixo x)
		Z_0d_x_00 = Z_0d * conj(Z_00);
		delta_0d = angle(Z_0d_x_00);
		% delta_0d -= ifelse(delta_0d>pi,2*pi,0);

		% Calculo de defasagem entre antenas d0 e 00 (Eixo Y)
		Z_d0_x_00 = Z_d0 * conj(Z_00);
		delta_d0 = angle(Z_d0_x_00);
		% delta_d0 -= ifelse(delta_d0>pi,2*pi,0);


		% Parametros r
		r_0d = delta_0d * lambda_w / (2 * pi);
		r_d0 = delta_d0 * lambda_w / (2 * pi);

		% Calculos de angulo de chegada
		componente_x = -r_d0/d; % Conjunto do eixo X
		componente_y = -r_0d/d; % Conjunto do eixo T


		% Variaveis auxuliares
		DoA_x = cos(ang_w);
		DoA_y = sin(ang_w);

		% Exibir valores
		if false
			printf('C_00 = %.2f\n',C_00);
			printf('C_0d = %.2f\n',C_0d);
			printf('C_d0 = %.2f\n',C_d0);
			disp('')
			printf('S_00 = %.2f\n',S_00);
			printf('S_0d = %.2f\n',S_0d);
			printf('S_d0 = %.2f\n',S_d0);
			disp('')
			printf('Z_00 = %.2f*\n',rad2deg(Z_00));
			printf('Z_0d = %.2f*\n',rad2deg(Z_0d));
			printf('Z_d0 = %.2f*\n',rad2deg(Z_d0));
			disp('')
			printf('delta_0d = %.2f*\n',rad2deg(delta_0d));
			printf('delta_d0 = %.2f*\n',rad2deg(delta_d0));
			disp('')
		end %if

	end %if

	% set(0, 'CurrentFigure', fig3d)


	set(0, 'defaultlinelinewidth', 1);
	set(0, 'defaultlinemarkersize', 5);
	set(0, 'defaultlinemarkerfacecolor', 'auto');

	clf;
	subplot(1,2,2, 'align');
	surf(x_w,y_w,z);
	view(-45, 45)

	colormap('gray');
	hold on;
		plot3([0 0], [0 0], [-lambda_w lambda_w], '-pg', 'linewidth', 1);
		% plot3(0, 0, lambda_w, 'pg', 'linewidth', 1);
		plot3([0 0], [d d], [-lambda_w lambda_w], '-pb', 'linewidth', 1);
		% plot3(0, d, lambda_w, 'pb', 'linewidth', 1);
		plot3([d d], [0 0], [-lambda_w lambda_w], '-pr', 'linewidth', 1);
		% plot3(d, 0, lambda_w, 'pr', 'linewidth', 1);
		shading interp;
		axis([-interval interval -interval interval -interval interval],'square')
		caxis([-lambda_w lambda_w]);
	hold off;

	if ~DEBUG

		% set(0, 'CurrentFigure', fig2d)
		% clf;
		subplot(1,2,1, 'align');

		interval_2d = 1.25*lambda_w;
		axis([-interval_2d interval_2d -interval_2d interval_2d],'square')

		% Antenas
		% A00 = plot(0, 0,'pg');
		A00 = compass(0, 0,'pg');
		hold on;
		% if isoctave()
		% 	set( gca, 'rtick', [ 0 : 0.25*lambda_w : interval_2d ] );
		% 	set( gca, 'ttick', [ 0  : 15 : 359 ] );
		% else
			% rtick([ 0 : 0.25*lambda_w : interval_2d ]);
			% ttick([ 0  : 15 : 359 ]);
		% end %if
		A0d = plot(0, d/lambda_w,'pb');
		Ad0 = plot(d/lambda_w, 0,'pr');

		grid on;
		grid minor;
		% colormap('jet');
		% colormap('gray');
		% colormap('hot');
		% colormap('cool');
		% xlabel('x');
		% ylabel('y');
		% colorbar();

		% Fundo de referencia
		% imagesc(x_w,y_w,z);


		% Fase por antena
		plot(Z_0d/abs(Z_0d)*.5,'ob');
		plot(Z_d0/abs(Z_d0)*.5,'or');
		plot(Z_00/abs(Z_00)*.5,'og', 'markerfacecolor', 'none');

		% Defasagem entre antenas
		plot(Z_0d_x_00/(abs(Z_0d_x_00))*.25,'dg', 'markerfacecolor', 'b');
		plot(Z_d0_x_00/(abs(Z_d0_x_00))*.25,'dg', 'markerfacecolor', 'r');

		% Angulo de chegada calculado
		plot(componente_x*0.75, componente_y*0.75,'vm');
		% plot([0 lambda_w*componente_x], [0 lambda_w*componente_y],':y', 'linewidth', 1, 'markersize', 5)

		% Angulo de chegada real
		plot(DoA_x*0.75, DoA_y*0.75,'^c', 'markerfacecolor', 'none');
		% plot([0 DoA_x], [0 DoA_y],'--c', 'linewidth', 1, 'markersize', 5)

		% h = legend('show');
		% legend (h, 'location', 'east');
		% set (h, 'fontsize', 20);

		hold off;

	end %if

end %function