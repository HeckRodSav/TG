% https://github.com/Techniex/OctaveScripts/blob/master/dataVis/heatMapExample.m

%This script draws heatmap using imagesc.
%Heatmap function is not yet implemented in Octave.

clear all;
close all;
clc;

interval = 4;
res = 500;

phase = 0
% phase = 2*pi*rand()
DoA = deg2rad(30);

lambda = 2;
d = lambda/4

o = ones(1,res);
x = linspace(-10,10,res); % 1-by-100
y = linspace(-10,10,res)'; % 1-by-100

function res = signal(X, Y, ANG, PHASE, LAMBDA)
	res = sin((2*pi/LAMBDA)*(sin(ANG)*Y+cos(ANG)*X+PHASE));
endfunction

z = signal(x, y, DoA, phase, lambda); % 100-by-100
fig = figure();

array = [0 d];


A1_sig = signal(0, 0, DoA, phase, lambda)
A2_sig = signal(d, 0, DoA, phase, lambda)

A1_phi = asin(A1_sig)
A2_phi = asin(A2_sig)

delta_phi = abs(A1_phi - A2_phi)
r = delta_phi * lambda/(2*pi)

angle_of_arrival = acos(r/d);

printf("angle_of_arrival = %.3f\n",rad2deg(angle_of_arrival));



arrow_x = lambda*cos(angle_of_arrival);
arrow_y = lambda*sin(angle_of_arrival);

DoA_x = lambda*cos(DoA);
DoA_y = lambda*sin(DoA);



hold on;
imagesc(x,y,z);
plot(array, zeros(1,length(array)),"xr", "linewidth", 1, "markersize", 10)
plot([0 arrow_x], [0 arrow_y],"-g", "linewidth", 1, "markersize", 10)
plot([0 DoA_x], [0 DoA_y],"-b", "linewidth", 1, "markersize", 10)
axis([-interval interval -interval interval])
% colormap("jet");
colormap("gray");
xlabel("x");
ylabel("y");
colorbar();
hold off;
% saveas(fig, 'heatplot.png');
% savefig (fig, 'heatplot.fig', "compact");


