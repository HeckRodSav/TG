clear all;
close all;
clc;

DEBUG = false;

NOISE = true;

ATTENUATION = true;

CHANGE_PHI = false;
CHANGE_DISTANCE = true;

SAVE_GIF = false;

if NOISE
	pkg load communications;
endif
SNR = 50/1;

phase = 0;
% phase = 2*pi*rand()
R_upper = 50;
R_lower = 1;

range_step = 10;

DoA_range = 0:range_step:360;
% DoA_range = [30];
DoA = deg2rad(DoA_range);

limits = 2; % ± * Lambda

lambda = 2;
omega = pi;
d = lambda / 2;
T = 2 * pi / omega;

amp_0 = 1;

C = true;
S = true;

interval = limits*lambda;
res = 100;

% o = ones(1,res);
space = linspace(-interval,interval,res+1); % 1-by-100
[x, y] = meshgrid(space);
% x = space; % 1-by-100
% y = space'; % 1-by-100
t_0 = 0;

name = 'simul';

if CHANGE_DISTANCE
	name = [name '_R_' num2str(R_upper) '~' num2str(R_lower) ];
	% name = sprintf('%s_SNR_%d',name, SNR);
else
	name = [name '_R_' num2str(R_upper)];
endif
if NOISE
	name = [name '_SNR_' num2str(SNR)];
	% name = sprintf('%s_SNR_%d',name, SNR);
endif
if ATTENUATION
	name = [name '_ATT'];
endif

if SAVE_GIF
	filename = ['Output/' name '.gif'];
	% filename = sprintf('%s.gif',name, SNR);
endif

function res = argument(x_w, y_w, t_w, ang_w, lambda_w, omega_w)
	% Argumento da função senoidal
	% x_w = coordenada x associada ao ponto da antena
	% y_w = coordenada y associada ao ponto da antena
	% t_w = tempo t associado ao instante de aferição do sinal
	% ang_w = ângulo theta de chegada do sinal em relação ao sistema de antenas
	% lambda_w = comprimento de onda
	% omega_w = frequencia angular

	res = (2*pi/lambda_w) * ( sin(ang_w)*y_w + cos(ang_w)*x_w ) + omega_w*t_w;
endfunction

function res = argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w)
	% Argumento da função senoidal
	% x_w = coordenada x associada ao ponto da antena
	% y_w = coordenada y associada ao ponto da antena
	% t_w = tempo t associado ao instante de aferição do sinal
	% ang_w = ângulo theta de chegada do sinal em relação ao sistema de antenas
	% lambda_w = comprimento de onda
	% omega_w = frequencia angular

	r = r_w * lambda_w;

	x_0 = r * cos(ang_w);
	y_0 = r * sin(ang_w);
	% y_0 = r * 10;

	res = (2*pi/lambda_w) * ( sqrt((y_w-y_0).^2 + (x_w-x_0).^2) ) + omega_w*t_w;
endfunction


function res = signal(x_w, y_w, t_w, ang_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR)
	% Função de sinal senoidal
	% x_w = coordenada x associada ao ponto da antena
	% y_w = coordenada y associada ao ponto da antena
	% t_w = tempo t associado ao instante de aferição do sinal
	% ang_w = ângulo theta de chegada do sinal em relação ao sistema de antenas
	% phase_w = defasagem phi do sinal
	% lambda_w = comprimento de onda
	% omega_w = frequencia angular
	% S = utilização de função Seno
	% C = Utilização de função Cosseno
	% NOISE = Se o sinal contará com ruído
	% SNR = Relação sinal-ruído

	res = 0;
	if S
		res += sin( argument(x_w, y_w, t_w, ang_w, lambda_w, omega_w) + phase_w);
	endif
	if C
		res += cos( argument(x_w, y_w, t_w, ang_w, lambda_w, omega_w) + phase_w);
	endif
	if NOISE
		res = awgn(res, SNR);
		% res += awgn(1, SNR, 1, 0);
		% res += rand()/SNR;
	endif
	% res *= 2;
endfunction

function res = signal_r(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION)
	% Função de sinal senoidal
	% x_w = coordenada x associada ao ponto da antena
	% y_w = coordenada y associada ao ponto da antena
	% t_w = tempo t associado ao instante de aferição do sinal
	% ang_w = ângulo theta de chegada do sinal em relação ao sistema de antenas
	% phase_w = defasagem phi do sinal
	% lambda_w = comprimento de onda
	% omega_w = frequencia angular
	% S = utilização de função Seno
	% C = Utilização de função Cosseno
	% NOISE = Se o sinal contará com ruído
	% SNR = Relação sinal-ruído
	% ATTENUATION = Se o sinal contará com atenuação por distância

	% global lambda;
	% global S;
	% global C;
	% global NOISE;
	% global SNR;
	% global ATTENUATION;

	res = 0;
	if S
		res += sin( argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w) + phase_w);
	endif
	if C
		res += cos( argument_r(x_w, y_w, t_w, ang_w, r_w, lambda_w, omega_w) + phase_w);
	endif
	if S && C
		res /= sqrt(2);
	endif


	if ATTENUATION
		G_t = 1;
		G_r = 1;
		R_t = 1;
		R_r = 1;
		P_t = (amp_w^2)/R_t;
		P_r = P_t * G_t * G_r * (lambda_w / (4 * pi * r_w));
		amp_r = sqrt(P_r * R_t);
		res *= amp_r;
	else
		res *= amp_w;
	endif

	if NOISE
		res = awgn(res, SNR);
		% res += awgn(1, SNR, 1, 0);
		% res += rand()/SNR;
	endif
	% res *= 2;
endfunction

function s = ref_sin(t_w, lambda_w, omega_w)
	% função auxiliar de sinal seno
	s = sin(argument(0, 0, t_w, 0, lambda_w, omega_w));
endfunction

function c = ref_cos(t_w, lambda_w, omega_w)
	% função auxiliar de sinal cosseno
	c = cos(argument(0, 0, t_w, 0, lambda_w, omega_w));
endfunction

function generate_fig(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION, DEBUG, interval, res, T, d)

	% global DEBUG;
	% global SNR;
	% global lambda;
	% global omega;
	% global interval;
	% global res;
	% global T;
	% global d;

	% Calcular a figura de fundo para visualização em imagem
	z = signal_r(x_w, y_w, t_w, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION);

	if ~DEBUG

		t = linspace(0,T,res);

		% Calculos de amostra I/Q para antena em (0,0)
		C_00 = trapz(t,ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));
		S_00 = trapz(t,ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));

		% C_00 = quad(@(t) (ref_cos(t) * signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		% S_00 = quad(@(t) (ref_sin(t) * signal_r(0, 0, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		Z_00 = 2*(S_00 + i*C_00);

		% Calculos de amostra I/Q para antena em (0,d)
		C_0d = trapz(t, ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));
		S_0d = trapz(t, ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(0, d, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));

		% C_0d = quad(@(t) (ref_cos(t) * signal_r(0, d, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		% S_0d = quad(@(t) (ref_sin(t) * signal_r(0, d, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		Z_0d = 2*(S_0d + i*C_0d);

		% Calculos de amostra I/Q para antena em (d, 0)
		C_d0 = trapz(t, ref_cos(t, lambda_w, omega_w) ...
			.* signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));
		S_d0 = trapz(t, ref_sin(t, lambda_w, omega_w) ...
			.* signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w, lambda_w, omega_w, S, C, NOISE, SNR, ATTENUATION));

		% C_d0 = quad(@(t) (ref_cos(t) * signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		% S_d0 = quad(@(t) (ref_sin(t) * signal_r(d, 0, t, amp_w, ang_w, r_w, phase_w)), 0, T);
		Z_d0 = 2*(S_d0 + i*C_d0);


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
			printf('Z_00 = %.2f°\n',rad2deg(Z_00));
			printf('Z_0d = %.2f°\n',rad2deg(Z_0d));
			printf('Z_d0 = %.2f°\n',rad2deg(Z_d0));
			disp('')
			printf('delta_0d = %.2f°\n',rad2deg(delta_0d));
			printf('delta_d0 = %.2f°\n',rad2deg(delta_d0));
			disp('')
		endif

	endif

	% set(0, 'CurrentFigure', fig3d)


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

		set(0, 'defaultlinelinewidth', 1);
		set(0, 'defaultlinemarkersize', 10);
		set(0, 'defaultlinemarkerfacecolor', 'auto');

		interval_2d = 1.25*lambda_w;
		axis([-interval_2d interval_2d -interval_2d interval_2d],'square')

		% Antenas
		% A00 = plot(0, 0,'pg');
		A00 = compass(0, 0,'pg');
		hold on;
		set( gca, 'rtick', [ 0 : 0.25*lambda_w : interval_2d ] );
		set( gca, 'ttick', [ 0  : 15 : 359 ] );
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

		% Fundo de referência
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
		plot(DoA_x*lambda_w, DoA_y*lambda_w,'^c', 'linewidth', 1, 'markersize', 10, 'markerfacecolor', 'none');
		% plot([0 DoA_x], [0 DoA_y],'--c', 'linewidth', 1, 'markersize', 5)

		% h = legend('show');
		% legend (h, 'location', 'east');
		% set (h, 'fontsize', 20);

		hold off;

	endif

endfunction

if SAVE_GIF
	f = figure(1, 'Position', get(0, 'Screensize'), 'visible', 'off');
else
	f = figure('name', name);
	% f = figure(1, 'Position', get(0, 'Screensize'));
	_ = input('Pressione Enter para continuar... ');
endif



percent = 0;
ref_iteration = 1/length(DoA_range);
it = 0;
DelayTime = 15*ref_iteration;
r = R_upper+R_lower;

printf('%s\n', name);
printf('%.2f%%\n', percent*100);

for DoA = [DoA_range DoA_range] % Duas voltas
	it += 1;


	if CHANGE_PHI
		phase += pi*ref_iteration;
	endif

	if CHANGE_DISTANCE
		r -= R_upper/(2*length(DoA_range));
	endif

	% disp('')
	ang_W = deg2rad(DoA);

	generate_fig(x, y, t_0, amp_0, ang_W, r, phase, lambda, omega, S, C, NOISE, SNR, ATTENUATION, DEBUG, interval, res, T, d);

	drawnow;
	if SAVE_GIF
		frame = getframe(f);
		im = frame2im(frame);

		[imind,cm] = rgb2ind(im);
		if it == 1;
			% Create GIF file
			imwrite(imind,cm,filename,'gif','DelayTime', DelayTime , 'Compression' , 'lzw');
		else
			% Add each new plot to GIF
			imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime', DelayTime , 'Compression' , 'lzw');
		endif
	else
		% pause(1/30)
		pause(0.0001)
	endif

	percent += ref_iteration/2;
	printf('%.2f%%\n', percent*100);

endfor

if SAVE_GIF
	printf('Check: %s\a\n', filename);
endif
