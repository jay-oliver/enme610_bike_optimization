%-----------%
% Equations % (script is not to be run) 
%-----------%

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

