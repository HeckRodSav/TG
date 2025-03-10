clear all;
close all;
clc;

interval = 3;
res = 500;

phase = 0
% phase = 2*pi*rand()

DoA_range = 0:5:360;
DoA = deg2rad(DoA_range);

lambda = 2;
d = lambda/4

% o = ones(1,res);
x = linspace(-interval,interval,res); % 1-by-100
y = linspace(-interval,interval,res)'; % 1-by-100

function res = signal(X, Y, ANG, PHASE, LAMBDA)
	res = cos((2*pi/LAMBDA)*(sin(ANG)*Y+cos(ANG)*X+PHASE));
endfunction

fig = figure();

for DoA = [DoA_range DoA_range]
	doa = deg2rad(DoA);

	z = signal(x, y, doa, phase, lambda); % 100-by-100

	array_x = [0 0 d];
	array_y = [0 d 0];


	A = signal(array_x, array_y, doa, phase, lambda);
	% [A00_sig Ad0_sig A0d_sig] = [A(1:3)]

	A00_sig = A(1);
	Ad0_sig = A(3);
	A0d_sig = A(2);

	% A00_sig = signal(0, 0, doa, phase, lambda);
	% Ad0_sig = signal(d, 0, doa, phase, lambda);
	% A0d_sig = signal(0, d, doa, phase, lambda);

	A00_phi = acos(A00_sig);
	Ad0_phi = acos(Ad0_sig);
	A0d_phi = acos(A0d_sig);

	delta_phi_x = Ad0_phi - A00_phi;
	delta_phi_y = A0d_phi - A00_phi;

	r_x = delta_phi_x * lambda/(2*pi);
	r_y = delta_phi_y * lambda/(2*pi);

	componente_x = r_x/d;
	componente_y = r_y/d;

	angle_of_arrival_x = acos(componente_x);
	angle_of_arrival_y = asin(componente_y);

	% printf("direction_of_arrival = %.0f\n",rad2deg(doa));
	% printf("angle_of_arrival_x = %.0f\n",rad2deg(angle_of_arrival_x));
	% printf("angle_of_arrival_y = %.0f\n\n",rad2deg(angle_of_arrival_y));

	arrow_x_x = lambda*cos(angle_of_arrival_x);
	arrow_x_y = lambda*sin(angle_of_arrival_x);

	arrow_y_x = lambda*cos(angle_of_arrival_y);
	arrow_y_y = lambda*sin(angle_of_arrival_y);

	DoA_x = lambda*cos(doa);
	DoA_y = lambda*sin(doa);

	clf;
	hold on;

	% colormap("jet");
	colormap("gray");
	% xlabel("x");
	% ylabel("y");
	% colorbar();
	axis([-interval interval -interval interval])

	imagesc(x,y,z);
	plot(array_x, array_y,"xm", "linewidth", 1, "markersize", 10)
	plot(lambda*componente_x, lambda*componente_y,"om", "linewidth", 1, "markersize", 10)
	plot([0 arrow_x_x], [0 arrow_x_y],"-r", "linewidth", 1, "markersize", 10)
	plot([0 arrow_y_x], [0 arrow_y_y],"-g", "linewidth", 1, "markersize", 10)
	plot([0 DoA_x], [0 DoA_y],"--b", "linewidth", 1, "markersize", 10)
	hold off;

	% saveas(fig, 'heatplot.png');
	% savefig (fig, 'heatplot.fig', "compact");

	pause(0.001)

endfor









