function generate_fig_polygon(
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

	index_list = 1:length(ant_array);

	color_list = [...
		[1 0 0];
		[0 1 0];
		[0 0 1]];

	if length(color_list) < length(ant_array)
		color_list = [...
			[1 0 0];
			[1 1 0];
			[0 1 0];
			[0 1 1];
			[0 0 1];
			[1 0 1]];
	end % if

	while length(color_list) < length(ant_array)
		aux_color_list = normalize(color_list+circshift(color_list,1),"range");
		color_list = sortrows(cat(1,color_list, aux_color_list.*0.75));
	end %while

	AoA_x = cos(choose_angle);
	AoA_y = sin(choose_angle);

	DoA_x = cos(ang_w);
	DoA_y = sin(ang_w);

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
		for idx = index_list
			ant = ant_array(idx);
			color = color_list(1 + mod(idx-1, length(color_list)),:);
			plot3(real(ant)*[1 1], imag(ant)*[1 1], [-lambda_w lambda_w], '-p', 'color', color);
		end % for

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

	for idx = index_list
		idx_next = idx+1;
		if idx_next > length(ant_array)
			idx_next = 1;
		end %if
		% color = color_list(idx);
		% color_next = color_list(idx_next);
		color = color_list(1 + mod(idx-1, length(color_list)),:);
		color_next = color_list(1 + mod(idx_next-1, length(color_list)),:);
		part_ang_r = 8 + (12-8)*(idx-1)/(length(ant_array)-1);

		% Antenas
		ant = ant_array(idx);
		ant_plot_aux = ant/(8 * Rho);
		plot(real(ant_plot_aux), imag(ant_plot_aux), 'p', 'color', color);

		% Fase por antena
		Z_phase = Z_phase_array(idx);
		Z_phase_plot_aux = Z_phase/abs(Z_phase)*(4/16);
		plot(real(Z_phase_plot_aux), imag(Z_phase_plot_aux), 'o', 'color', color);

		% Eixos auxiliares
		ant_next = ant_array(idx_next);
		ant_axis = ant_next - ant;
		plot(real(ant_axis)*[1 -1]/abs(ant_axis), imag(ant_axis)*[1 -1]/abs(ant_axis), '-', 'color', color);
		plot(real(ant_axis*i)*[1 -1]/abs(ant_axis), imag(ant_axis*i)*[1 -1]/abs(ant_axis), ':', 'color', color);

		% Defasagem entre antenas
		Z_A_x_B = Z_x_array(idx);
		aux_A_x_B = (Z_A_x_B/abs(Z_A_x_B))*(6/16);
		plot(real(aux_A_x_B), imag(aux_A_x_B), 'd', 'color', color, 'markerfacecolor', color_next, 'linewidth', 0.75);

		% Angulos de chegada parciais
		delta_A_x_B = delta_A_x_B_array(idx);
		delta_B_x_A = delta_B_x_A_array(idx);
		plot(cos(delta_A_x_B)*(part_ang_r/16), sin(delta_A_x_B)*(part_ang_r/16), 'v', 'color', color, 'markerfacecolor', color_next, 'linewidth', 0.75);
		plot(cos(delta_B_x_A)*(part_ang_r/16), sin(delta_B_x_A)*(part_ang_r/16), '^', 'color', color, 'markerfacecolor', color_next, 'linewidth', 0.75);
	end % for

	% Angulo de chegada calculado
	plot([0 7/8]*AoA_x, [0 7/8]*AoA_y,':k');
	plot(7/8*AoA_x, 7/8*AoA_y,'hk');
	cplx_aux_AoA = i*exp(i*choose_angle);
	plot(real(cplx_aux_AoA)*[1 -1], imag(cplx_aux_AoA)*[1 -1],'-k');

	% Angulo de chegada real
	plot(DoA_x*7/8, DoA_y*7/8,'ok', 'markerfacecolor', 'none', 'markersize', 10, 'linewidth', 1);

	hold off;

end % function
