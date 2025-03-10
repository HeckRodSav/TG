clear all;
close all;
clc;

DEBUG = false;

NOISE = true;

C = false;
S = true;

SNR = 10/1;

interval = 3;
res = 500;

% phase = 2*pi*rand()
phase = 0;

% DoA_range = [30];
DoA_range = 0:5:360;
DoA = deg2rad(DoA_range);


lambda = 2;
omega = pi;
d = lambda / 2;
T = 2 * pi / omega;

% o = ones(1,res);
x = linspace(-interval,interval,res); % 1-by-100
y = linspace(-interval,interval,res)'; % 1-by-100
t_0 = 0;

fig = figure();
set(gcf, 'Position', get(0, 'Screensize'));


for DoA = [DoA_range DoA_range] % Duas voltas

    % phase = 2*pi*rand();
    phase = phase + pi/length(DoA_range);

    % disp('')
    ang_W = deg2rad(DoA);

    generate_fig(x, y, t_0, ang_W, phase, SNR, T, d, lambda, omega, ...
        interval, S, C, NOISE, DEBUG, res);

    pause(0.1)
end













function generate_fig(x_w, y_w, t_w, ang_w, phase_w, SNR, T, d, lambda,...
    omega, interval, S, C, NOISE, DEBUG, res)

% Calcular a figura de fundo para visualização em imagem
z = signal(x_w, y_w, t_w, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res);

if ~DEBUG

    t = linspace(0,T,res);

    % Calculos de amostra I/Q para antena em (0,0)
    C_00 = trapz(t,ref_cos(t, lambda, omega) ...
        .* signal(0, 0, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));
    S_00 = trapz(t,ref_sin(t, lambda, omega) ...
        .* signal(0, 0, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));

    % C_00 = quad(@(t) (ref_cos(t) * signal(0, 0, t, ang_w, phase_w)), 0, T);
    % S_00 = quad(@(t) (ref_sin(t) * signal(0, 0, t, ang_w, phase_w)), 0, T);
    Z_00 = 2*(S_00 + i*C_00);

    % Calculos de amostra I/Q para antena em (0,d)
    C_0d = trapz(t, ref_cos(t, lambda, omega) ...
        .* signal(0, d, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));
    S_0d = trapz(t, ref_sin(t, lambda, omega) ...
        .* signal(0, d, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));

    % C_0d = quad(@(t) (ref_cos(t) * signal(0, d, t, ang_w, phase_w)), 0, T);
    % S_0d = quad(@(t) (ref_sin(t) * signal(0, d, t, ang_w, phase_w)), 0, T);
    Z_0d = 2*(S_0d + i*C_0d);

    % Calculos de amostra I/Q para antena em (d, 0)
    C_d0 = trapz(t, ref_cos(t, lambda, omega) ...
        .* signal(d, 0, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));
    S_d0 = trapz(t, ref_sin(t, lambda, omega) ...
        .* signal(d, 0, t, ang_w, phase_w, SNR, S, C, NOISE, lambda, omega, res));

    % C_d0 = quad(@(t) (ref_cos(t) * signal(d, 0, t, ang_w, phase_w)), 0, T);
    % S_d0 = quad(@(t) (ref_sin(t) * signal(d, 0, t, ang_w, phase_w)), 0, T);
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
    r_0d = delta_0d * lambda / (2 * pi);
    r_d0 = delta_d0 * lambda / (2 * pi);

    % Calculos de angulo de chegada
    componente_x = r_d0/d; % Conjunto do eixo X
    componente_y = r_0d/d; % Conjunto do eixo T

    % Variaveis auxuliares
    DoA_x = lambda*cos(ang_w);
    DoA_y = lambda*sin(ang_w);

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
        printf('Z_00 = %.2f\n',rad2deg(Z_00));
        printf('Z_0d = %.2f\n',rad2deg(Z_0d));
        printf('Z_d0 = %.2f\n',rad2deg(Z_d0));
        disp('')
        printf('delta_0d = %.2f\n',rad2deg(delta_0d));
        printf('delta_d0 = %.2f\n',rad2deg(delta_d0));
        disp('')
    end
end

clf;
hold on;

% colormap('jet');
colormap('gray');
% colormap('hot');
% colormap('cool');
% xlabel('x');
% ylabel('y');
% colorbar();
axis([-interval interval -interval interval],'square')

% Fundo de referencia
imagesc(x_w, y_w, z);

if ~DEBUG

    % Antenas
    plot(0, 0,'vg', 'linewidth', 1, 'markersize', 5)
    plot(0, d,'vb', 'linewidth', 1, 'markersize', 5)
    plot(d, 0,'vr', 'linewidth', 1, 'markersize', 5)

    % Fase por antena
    plot(Z_0d/abs(Z_0d)*lambda*.75,'ob', 'linewidth', 1, 'markersize', 5, 'markerfacecolor', 'b')
    plot(Z_d0/abs(Z_d0)*lambda*.75,'or', 'linewidth', 1, 'markersize', 5, 'markerfacecolor', 'r')
    plot(Z_00/abs(Z_00)*lambda*.75,'og', 'linewidth', 1, 'markersize', 5)

    % Defasagem entre antenas
    plot(Z_0d_x_00/(abs(Z_0d_x_00))*lambda*.25,'db', 'linewidth', 1, 'markersize', 5, 'markerfacecolor', 'b')
    plot(Z_d0_x_00/(abs(Z_d0_x_00))*lambda*.25,'dr', 'linewidth', 1, 'markersize', 5, 'markerfacecolor', 'r')

    % Angulo de chegada calculado
    plot(lambda*componente_x, lambda*componente_y,'om', 'linewidth', 1, 'markersize', 5, 'markerfacecolor', 'm')
    % plot([0 lambda*componente_x], [0 lambda*componente_y],':y', 'linewidth', 1, 'markersize', 5)

    % Angulo de chegada real
    plot(DoA_x, DoA_y,'oc', 'linewidth', 1, 'markersize', 5)
    % plot([0 DoA_x], [0 DoA_y],'--c', 'linewidth', 1, 'markersize', 5)
end

hold off;

end


function res = signal(x_w, y_w, t_w, ang_w, phase_w, SNR, S, C, NOISE, ...
    lambda, omega, res)
% Funcao de sinal senoidal
% x_w = coordenada x associada ao ponto da antena
% y_w = coordenada y associada ao ponto da antena
% t_w = tempo t associado ao instante de aferição do sinal
% ang_w = ângulo theta de chegada do sinal em relacao ao sistema de antenas
% phase_w = defasagem phi do sinal

if S
    res = res + sin(argument(x_w, y_w, t_w, ang_w, lambda, omega) + phase_w);
end

if C
    res = res + cos(argument(x_w, y_w, t_w, ang_w, lambda, omega) + phase_w);
end

if NOISE
    % res += awgn(1, SNR, 1, 0);
    % res += rand()/SNR;
    res = awgn(res, SNR);
end
% res *= 2;
end


function res = argument(x_w, y_w, t_w, ang_w, lambda, omega)
% Argumento da função senoidal
% x_w = coordenada x associada ao ponto da antena
% y_w = coordenada y associada ao ponto da antena
% t_w = tempo t associado ao instante de aferição do sinal
% ang_w = ângulo theta de chegada do sinal em relação ao sistema de antenas

res = (2*pi/lambda) * ( sin(ang_w)*y_w + cos(ang_w)*x_w ) + omega*t_w;
end



function s = ref_sin(t_w, lambda, omega)
% funcao auxiliar de sinal seno
s = sin(argument(0, 0, t_w, 0, lambda, omega));
end

function c = ref_cos(t_w, lambda, omega)
% funcao auxiliar de sinal cosseno
c = cos(argument(0, 0, t_w, 0, lambda, omega));
end


