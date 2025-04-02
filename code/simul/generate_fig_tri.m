function generate_fig_tri(
		z_plot,
		x_w,
		y_w,
		ang_w,
		lambda_w,
		interval,
		Rho,
		choose_angle,
		ant_array,
		Z_phase_array,
		Z_x_array,
		delta_A_x_B_array,
		delta_B_x_A_array
	) % Graficos

	[ant_SS ant_NE ant_NO] = num2cell(ant_array){:};

	[Z_phase_SS Z_phase_NE Z_phase_NO] = num2cell(Z_phase_array){:};

	[Z_SS_x_NE Z_NE_x_NO Z_NO_x_SS] = num2cell(Z_x_array){:};

	[delta_SS_x_NE delta_NE_x_NO delta_NO_x_SS] = num2cell(delta_A_x_B_array){:};
	[delta_NE_x_SS delta_NO_x_NE delta_SS_x_NO] = num2cell(delta_B_x_A_array){:};

	AoA_x = cos(choose_angle);
	AoA_y = sin(choose_angle);

	DoA_x = cos(ang_w);
	DoA_y = sin(ang_w);

	% set(0, 'CurrentFigure', fig3d)

	set(0, 'defaultlinelinewidth', 0.5);
	set(0, 'defaultlinemarkersize', 5);
	set(0, 'defaultlinemarkerfacecolor', 'auto');

	clf;

	% Calcular a figura de fundo para visualizacao em imagem

	subplot(1,2,2, 'align');
	surf(x_w,y_w,z_plot); % Desenhar sinal eletromagnetico
	view(-45, 45)

	colormap('gray');
	hold on;
		% Desenhar antenas
		plot3(real(ant_SS)*[1 1], imag(ant_SS)*[1 1], [-lambda_w lambda_w], '-pg');
		plot3(real(ant_NE)*[1 1], imag(ant_NE)*[1 1], [-lambda_w lambda_w], '-pb');
		plot3(real(ant_NO)*[1 1], imag(ant_NO)*[1 1], [-lambda_w lambda_w], '-pr');

		plot3([0 lambda_w]*AoA_x, [0 lambda_w]*AoA_y, [lambda_w lambda_w],':k');
		plot3(lambda_w*AoA_x, lambda_w*AoA_y, lambda_w,'hk');

		% Angulo de chegada real
		plot3(DoA_x*lambda_w, DoA_y*lambda_w, lambda_w, 'ok', 'markerfacecolor', 'none', 'markersize', 10, 'linewidth', 1);


		shading interp;
		axis([-interval interval -interval interval -interval interval],'square')
		caxis([-lambda_w lambda_w]);
	hold off;

	% set(0, 'CurrentFigure', fig2d)
	% clf;
	subplot(1,2,1, 'align');

	interval_2d = 1.25*lambda_w;
	axis([-interval_2d interval_2d -interval_2d interval_2d],'square')

	polar(0,0,':w')
	hold on;
	if isoctave()
		set( gca, 'rtick', [ 0 : 0.25 : 1 ] );
		set( gca, 'ttick', [ 0  : 15 : 359 ] );
	else
		rtick([ 0 : 0.25 : 1 ]);
		ttick([ 0  : 15 : 359 ]);
	end %if

	grid on;
	grid minor;
	% colormap('jet');
	% colormap('gray');
	% colormap('hot');
	% colormap('cool');
	% xlabel('x');
	% ylabel('y');
	% colorbar();

	% Antenas
	ant_SS_plot_aux = ant_SS/(8 * Rho);
	ant_NE_plot_aux = ant_NE/(8 * Rho);
	ant_NO_plot_aux = ant_NO/(8 * Rho);
	plot(real(ant_SS_plot_aux), imag(ant_SS_plot_aux),'pg');
	plot(real(ant_NE_plot_aux), imag(ant_NE_plot_aux),'pb');
	plot(real(ant_NO_plot_aux), imag(ant_NO_plot_aux),'pr');

	% Fase por antena
	Z_phase_NE_plot_aux = Z_phase_NE/abs(Z_phase_NE)*(4/16);
	Z_phase_NO_plot_aux = Z_phase_NO/abs(Z_phase_NO)*(4/16);
	Z_phase_SS_plot_aux = Z_phase_SS/abs(Z_phase_SS)*(4/16);
	plot(real(Z_phase_NE_plot_aux), imag(Z_phase_NE_plot_aux),'ob');
	plot(real(Z_phase_NO_plot_aux), imag(Z_phase_NO_plot_aux),'or');
	plot(real(Z_phase_SS_plot_aux), imag(Z_phase_SS_plot_aux),'og');

	% Eixos auxiliares
	plot(real(ant_SS*i)*[1 -1]/abs(ant_SS), imag(ant_SS*i)*[1 -1]/abs(ant_SS) ,'-m');
	plot(real(ant_NO*i)*[1 -1]/abs(ant_NO), imag(ant_NO*i)*[1 -1]/abs(ant_NO) ,'-c');
	plot(real(ant_NE*i)*[1 -1]/abs(ant_NE), imag(ant_NE*i)*[1 -1]/abs(ant_NE) ,'-y');

	plot(real(ant_SS)*[1 -1]/abs(ant_SS), imag(ant_SS)*[1 -1]/abs(ant_SS) ,':m');
	plot(real(ant_NO)*[1 -1]/abs(ant_NO), imag(ant_NO)*[1 -1]/abs(ant_NO) ,':c');
	plot(real(ant_NE)*[1 -1]/abs(ant_NE), imag(ant_NE)*[1 -1]/abs(ant_NE) ,':y');


	% Defasagem entre antenas
	aux_SS_x_NE = (Z_SS_x_NE/abs(Z_SS_x_NE))*(6/16);
	aux_NO_x_SS = (Z_NO_x_SS/abs(Z_NO_x_SS))*(6/16);
	aux_NE_x_NO = (Z_NE_x_NO/abs(Z_NE_x_NO))*(6/16);
	plot(real(aux_SS_x_NE), imag(aux_SS_x_NE),'db', 'markerfacecolor', 'g', 'linewidth', 0.75);
	plot(real(aux_NO_x_SS), imag(aux_NO_x_SS),'dg', 'markerfacecolor', 'r', 'linewidth', 0.75);
	plot(real(aux_NE_x_NO), imag(aux_NE_x_NO),'dr', 'markerfacecolor', 'b', 'linewidth', 0.75);

	% Angulos de chegada parciais
	plot(cos(delta_SS_x_NE)*(12/16), sin(delta_SS_x_NE)*(12/16),'vb', 'markerfacecolor', 'g', 'linewidth', 0.75);
	plot(cos(delta_NO_x_SS)*(10/16), sin(delta_NO_x_SS)*(10/16),'vg', 'markerfacecolor', 'r', 'linewidth', 0.75);
	plot(cos(delta_NE_x_NO)*( 8/16), sin(delta_NE_x_NO)*( 8/16),'vr', 'markerfacecolor', 'b', 'linewidth', 0.75);

	plot(cos(delta_NE_x_SS)*(12/16), sin(delta_NE_x_SS)*(12/16),'^b', 'markerfacecolor', 'g', 'linewidth', 0.75);
	plot(cos(delta_SS_x_NO)*(10/16), sin(delta_SS_x_NO)*(10/16),'^g', 'markerfacecolor', 'r', 'linewidth', 0.75);
	plot(cos(delta_NO_x_NE)*( 8/16), sin(delta_NO_x_NE)*( 8/16),'^r', 'markerfacecolor', 'b', 'linewidth', 0.75);

	% Angulo de chegada calculado
	plot([0 7/8]*AoA_x, [0 7/8]*AoA_y,':k');
	plot(7/8*AoA_x, 7/8*AoA_y,'hk');
	cplx_aux_AoA = i*exp(i*choose_angle);
	plot(real(cplx_aux_AoA)*[1 -1], imag(cplx_aux_AoA)*[1 -1],'-k');

	% Angulo de chegada real
	plot(DoA_x*7/8, DoA_y*7/8,'ok', 'markerfacecolor', 'none', 'markersize', 10, 'linewidth', 1);

	hold off;

end % function
