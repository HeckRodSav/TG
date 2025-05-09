classdef xyt_functions
	methods
		function r = isoctave (obj) % Confere se esta executando no octave ou nao
		persistent x;
		if (isempty (x))
			x = exist ('OCTAVE_VERSION', 'builtin');
		end
		r = x;
		end

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function res = argument_r(obj,x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w)
			% Argumento da funcao senoidal
			% x_w = coordenada x associada ao ponto da antena
			% y_w = coordenada y associada ao ponto da antena
			% t_w = tempo t associado ao instante de afericao do sinal
			% ang_w = angulo theta de chegada do sinal em relacao ao sistema de antenas
			% lambda_w = comprimento de onda
			% omega_w = frequencia angular

			r = r_w * lambda_w;

			x_0 = r * cos(ang_w);
			y_0 = r * sin(ang_w);
			% y_0 = r * 10;

			res = (2*pi/lambda_w) * ( sqrt((y_w-y_0).^2 + (x_w-x_0).^2) ) + omega_w*t_w;
		end %function


		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function res = signal_r(obj, x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, ...
			lambda_w, omega_w, S, C, NOISE, SNR_dB, ATTENUATION)
			% Funcao de sinal senoidal
			% x_w = coordenada x associada ao ponto da antena
			% y_w = coordenada y associada ao ponto da antena
			% t_w = tempo t associado ao instante de afericao do sinal
			% ang_w = angulo theta de chegada do sinal em relacao ao sistema de antenas
			% phase_w = defasagem phi do sinal
			% lambda_w = comprimento de onda
			% omega_w = frequencia angular
			% S = utilizacao de funcao Seno
			% C = Utilizacao de funcao Cosseno
			% NOISE = Se o sinal contara com ruido
			% SNR_dB = Relacao sinal-ruido
			% ATTENUATION = Se o sinal contara com atenuacao por distancia

			res = 0;
			if S
				res = res + sin( obj.argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w) + phase_w);
			end %if
			if C
				res = res + cos( obj.argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w) + phase_w);
			end %if
			if S && C
				res = res / sqrt(2);
			end %if


			if ATTENUATION
				%%% Variaveis auxiliares
				G_t = 1;
				G_r = 1;
				R_t = 1;
				R_r = 1;
				%%%%%%%%%%%%%%%%%%%%%%%%

				P_t = (amp_w^2)/R_t;
				P_r = P_t * G_t * G_r * (lambda_w / (4 * pi * r_w));

				amp_r = sqrt(P_r * R_t);
				res = res * amp_r;
			else
				res = res * amp_w;
			end %if

			if NOISE
				res = awgn(res, SNR_dB, 'measured');
				% res = awgn(res, SNR, 'linear');
				% res += awgn(1, SNR_dB, 1, 0);
				% res += rand()/SNR_dB;
			end %if
			% res = res * 2;
		end %function

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function s = ref_sin(obj, t_w, lambda_w, omega_w)
			% funcao auxiliar de sinal seno
			s = sin(obj.argument_r(0, 0, t_w, 0, 0, lambda_w, omega_w));
		end %function

		function c = ref_cos(obj, t_w, lambda_w, omega_w)
			% funcao auxiliar de sinal cosseno
			c = cos(obj.argument_r(0, 0, t_w, 0, 0, lambda_w, omega_w));
		end %function

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function generate_fig(obj, x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, ...
			omega_w, S, C, NOISE, SNR_dB, ATTENUATION, DEBUG, interval, resulution, T, d)

			% Calcular a figura de fundo para visualizacao em imagem
			z = obj.signal_r(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, ...
				omega_w, S, C, NOISE, SNR_dB, ATTENUATION);

			if ~DEBUG

				t = linspace(0,T,resulution);

				% Calculos de amostra I/Q para antena em (0,0)
				C_00 = trapz(t,obj.ref_cos(t, lambda_w, omega_w) ...
					.* obj.signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
				S_00 = trapz(t,obj.ref_sin(t, lambda_w, omega_w) ...
					.* obj.signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

				Z_00 = 2*(S_00 + 1i*C_00);

				% Calculos de amostra I/Q para antena em (0,d)
				C_0d = trapz(t, obj.ref_cos(t, lambda_w, omega_w) ...
					.* obj.signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
				S_0d = trapz(t, obj.ref_sin(t, lambda_w, omega_w) ...
					.* obj.signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

				Z_0d = 2*(S_0d + 1i*C_0d);

				% Calculos de amostra I/Q para antena em (d, 0)
				C_d0 = trapz(t, obj.ref_cos(t, lambda_w, omega_w) ...
					.* obj.signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));
				S_d0 = trapz(t, obj.ref_sin(t, lambda_w, omega_w) ...
					.* obj.signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, ...
						omega_w, S, C, NOISE, SNR_dB, ATTENUATION));

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
				if obj.isoctave()
					set( gca, 'rtick', [ 0 : 0.25*lambda_w : interval_2d ] );
					set( gca, 'ttick', [ 0  : 15 : 359 ] );
				else
					rtick([ 0 : 0.25*lambda_w : interval_2d ]);
					ttick([ 0  : 15 : 359 ]);
				end %if
				A0d = plot(0, d,'pb');
				Ad0 = plot(d, 0,'pr');

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
				plot(Z_0d/abs(Z_0d)*lambda_w*.75,'ob');
				plot(Z_d0/abs(Z_d0)*lambda_w*.75,'or');
				plot(Z_00/abs(Z_00)*lambda_w*.75,'og', 'markerfacecolor', 'none');

				% Defasagem entre antenas
				plot(Z_0d_x_00/(abs(Z_0d_x_00))*lambda_w*.25,'dg', 'markerfacecolor', 'b');
				plot(Z_d0_x_00/(abs(Z_d0_x_00))*lambda_w*.25,'dg', 'markerfacecolor', 'r');

				% Angulo de chegada calculado
				plot(componente_x*lambda_w, componente_y*lambda_w,'vm');
				% plot([0 lambda_w*componente_x], [0 lambda_w*componente_y],':y', 'linewidth', 1, 'markersize', 5)

				% Angulo de chegada real
				plot(DoA_x*lambda_w, DoA_y*lambda_w,'^c', 'markerfacecolor', 'none');
				% plot([0 DoA_x], [0 DoA_y],'--c', 'linewidth', 1, 'markersize', 5)

				% h = legend('show');
				% legend (h, 'location', 'east');
				% set (h, 'fontsize', 20);

				hold off;

			end %if

		end %function

	end %methods
end %classdef
