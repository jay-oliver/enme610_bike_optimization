%-----------%
% Constants %
%-----------%
m = 70;
g = 9.81;
y = [0.0014 1.6336 -0.0576 5.4576];
%crr for concrete is 1/2x asphalt, gravel is 2x asphalt, crr conversion is
%based on asphalt

%-----------%
% Equations % (script is not to be run) 
%-----------%
% Objectives: Power (at any moment), Time to commute 
% Design Varis: Gear Ratio,  Tire Width, Effort

% ==Trails== %
crr = y(1) + (1/p(1))*(y(2) + y(3)*(v/y(4))^2);
crr_a = crr;
crr_c = 0.5 * crr;
crr_g = 2 * crr;
W = x*crr*m*g*cosd(theta);
%m is mass, using 70 kg
Met = W/(m*3.5)

% ==Power Equivalence== %
% Power for acceleration 
Pa = V_roll * m_total * accel 
% Power needed to roll 
Pr = V_roll * m_total * g * Crr
% Power to overcome drag
Pd = (1/2) * rho * V_roll^3 * Cd * A
% Power needed to go on a slope (s>0 means uphill)
Ps = V_roll * m_total * g * s
% Total power assembly, with user power 
Pa==P_user - (Pd + Ps + Pr)
% maybe rearrange to minimize power input from the user?
% also, include effiency from the drive train that affects user power "eta"
P_user == (Pa + Pd + Ps + Pr) / eta