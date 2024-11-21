%-----------%
% Equations % (script is not to be run) 
%-----------%
% Objectives: Power (at any moment), Time to commute 
% Design Varis: Gear Ratio,  Tire Width, Effort

% ==Trails== %
W = x*crr*m*g*cosd(theta)

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