%-----------%
% Constants %
%-----------%
g = 9.81;
m = 70;
trailsTheta = [[0, 0, 0], [0, 0, 0], [2.6, 0, 0], [2.6, -1.56, 0], [2.6, 0, 0], [4.2, 0, 0];
               [0, 0, 0], [0.88, 0, 0], [0.88, 0, 0], [3.38, 0, 0], [0.88, 0, 0], [0.88, -0.84, 0];
               [0, 0, 0], [2.6, 0, 0], [2.6, 0, 0], [2.29, -2, 0], [1.71, 0, 0], [4.2, 0, 0];
               [-1.31, 0, 0], [0, 0, 0], [2.29, 0, 0], [0, 0, 0], [0, 0, 0], [1.37, 0, 0];
               [-1.48, 0, 0], [-1.48, 0, 0], [-1.48, 5.14, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0];
               [1.8, -0.79, 0], [1.8, 0, 0], [0.93, 0, 0], [0.83, 0, 0], [0.9, 0, 0], [1.8, 0, 0];
               [-0.35, 0, 0], [-0.35, 1.35, 0], [-0.35, 1.72, 0], [-0.35, 1.45, 0], [1.9, -1.35, 0.64], [1.9, -1.35, 1.15]];

trailsX = [[1609.34, 0, 0], [2253.08, 0, 0], [550, 1703.08, 0], [550, 400, 1785], [550, 2185.88, 0], [489, 1925.01, 0];
           [4345.22, 0, 0], [1300, 2240.55, 0], [1300, 2562.42, 0], [220, 1872, 0], [1300, 2562.42, 0], [1300, 750, 2134.28];
           [1609.34, 0, 0], [550, 1542.14, 0], [650, 400, 1364.01], [400, 2496.81, 0], [489, 3212.48, 0];
           [1000, 400, 0], [643.74, 0, 0], [200, 604.67, 0], [482.80, 0, 0], [1609.34, 0, 0], [250, 1359.34, 0];
           [850, 437.47, 0], [850, 598.41, 0], [850, 100, 337.47], [1770.27, 0, 0], [643.74, 0, 0], [49.99, 0, 0];
           [350, 1600, 303.08], [350, 1259.34, 0], [1300, 631.21, 0], [900, 226.54, 0], [1200, 892.14, 0], [350, 2546.81, 0];
           [3400, 301.48, 0], [3400, 1100, 0], [3400, 1100, 0], [3400, 1300, 288.95], [450, 1100, 1700], [450, 1100, 900]]

%crr for concrete is 1/2x asphalt, gravel is 2x asphalt, crr conversion is
%based on asphalt

%-----------%
% Equations % (script is not to be run) 
%-----------%
% Objectives: Power (at any moment), Time to commute 
% Design Varis: Gear Ratio,  Tire Width, Effort

% ==Trails== %
crr=0.0014 + (1/p)*(1.6336 + -0.0576*(v/5.4576)^2);
crr_a = crr;
crr_c = 0.5 * crr;
crr_g = 2 * crr;
W = x*m*g*(crr*cosd(theta) + sind(theta));
%m is mass, using 70 kg
Met = W/(m*3.5)

% ==Power Equivalence== %
% Power for acceleration (should we aim for this to be zero) 
Pa = V_roll * m_total * accel 
% Power needed to roll 
Pr = V_roll * m_total * g * Crr
% Power to overcome drag (Cd * A may be ~=1) 
Pd = (1/2) * rho * V_roll^3 * Cd * A
% Power needed to go on a slope (s>0 means uphill)
Ps = V_roll * m_total * g * s
% Total power assembly, with user power 
Pa==P_user - (Pd + Ps + Pr)
% maybe rearrange to minimize power input from the user?
% also, include effiency from the drive train that affects user power "eta"
P_user == (Pa + Pd + Ps + Pr) / eta

% ==Velocity Calculation== 

