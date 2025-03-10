EARTH_RADIUS = 6371E3;

                  % Lat               Lon
coord_ufabc_SA  = [-23.64450271006082 -46.52808340455618];
coord_ufabc_SBC = [-23.67751377362596 -46.563491717644425];

A = coord_ufabc_SA;
B = coord_ufabc_SBC;

theta_A = deg2rad(A(1));
theta_B = deg2rad(B(1));

phi_A = deg2rad(A(2));
phi_B = deg2rad(B(2));

delta_theta = theta_B - theta_A;
delta_phi = phi_B - phi_A;

X = cos(theta_B)*sin(delta_phi);
Y = cos(theta_A)*sin(theta_B) ...
    - sin(theta_A)*cos(theta_B)*cos(delta_phi);
Z = (sin(delta_theta/2))^2 ...
    + cos(theta_B) * cos(theta_A) * (sin(delta_phi/2))^2;

beta = atan2(X,Y) - pi/2;

if beta < -pi
	beta = beta + 2*pi
end


d = EARTH_RADIUS * 2 * atan2(sqrt(Z), sqrt(1 - Z))

d_deg = rad2deg(beta)