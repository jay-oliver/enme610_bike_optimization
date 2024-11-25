%% Function setup: This script is more or less for our own logical use, it will not have formulations 
% Objectives: Power (at any moment), Time to commute 
% Design Varis: Gear Ratio,  Tire Width, Effort
clear
clc

%% include other scripts 
cd 
import c_roll_resist.*
import Eff_eval.*

% ===Testing functions===
% Power 
v = 18; % mph, target rolling velocity 
v = v/2.237; % m/s
GR=2.5; % Gear Ratio 
p=60; %psi 
p=p/14.504; %bar 
m=70+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
Power_test=Power(v,GR,p,m,0.01)


%% Function dump 

% MET conversion eq (inputs are power and weight)
function Metabolic_Equivalent=MET(Power,Weight)
    Metabolic_Equivalent=Power/(Weight*3.5);
end

% Power formulation
function total_power=Power(V_roll, Gear_Ratio, Tire_Pressure,m_total,s)
    rho=1.225; %kg/m3 , air pressure at stp 
    g=9.81; %m/s2
    % Power for acceleration (should we aim for this to be zero) 
    accel=0; %Acceleration set to 0, we're just keeping formulation for reading reasons
    Pa = V_roll * m_total * accel;
    % Power needed to roll 
    Pr = V_roll * m_total * g * c_roll_resist(Tire_Pressure,V_roll);
    % Power to overcome drag (Cd * A may be ~=1) 
    Cd=1;
    A=1; 
    Pd = (1/2) * rho * V_roll^3 * Cd * A;
    % Power needed to go on a slope (s>0 means uphill)
    Ps = V_roll * m_total * g * s
    % Total power assembly, with user power 
    % Pa==(P_user*(Eff_Eval(Gear_Ratio)/100)) - (Pd + Ps + Pr)
    % Assuming we want acceleration to be 0, here it the formulation to
    % minimize user power input 
    total_power=(Pd + Ps + Pr + Pa)/(Eff_Eval(Gear_Ratio)*(1/100));
end

% Trail Energy Offset 
function Trail_Energy=Trail_Energy(name, m, p)
    g=9.81; %m/s^2, gravity constant 
    % Trail Data 
    % B -- Berwyn
    % UP -- University Park
    % MS -- Metro Station
    % WH -- Washington Hall
    % LP -- La Plata
    % GG -- Graduate Gardens
    % MRR -- Metzerott Road Residences
    % Each array of three corresponds to three sections of a trail, 0s are used
    % where a trail has fewer than three sections. For example
    % trailsTheta.B_clark[1] is the theta value for the first cosd(theta) and
    % sind(theta), trailsTheta.B_clark[2] corresponds to the second, etc
    trailsTheta = struct('B_clark', {[0, 0, 0]}, 'B_lib', {[0, 0, 0]}, 'B_stamp', {[2.6, 0, 0]}, 'B_smith', {[2.6, -1.56, 0]}, 'B_clarice', {[2.6, 0, 0]}, 'B_eppley', {[4.2, 0, 0]},...
              'UP_clark', {[0, 0, 0]}, 'UP_lib', {[0.88, 0, 0]}, 'UP_stamp', {[0.88, 0, 0]}, 'UP_smith', {[3.38, 0, 0]}, 'UP_clarice', {[0.88, 0, 0]}, 'UP_eppley', {[0.88, -0.84, 0]},...
              'MS_clark', {[0, 0, 0]}, 'MS_lib', {[2.6, 0, 0]}, 'MS_stamp', {[2.6, 0, 0]}, 'MS_smith', {[2.29, -2, 0]}, 'MS_clarice', {[1.71, 0, 0]}, 'MS_eppley', {[4.2, 0, 0]},...
              'WH_clark', {[-1.31, 0, 0]}, 'WH_lib', {[0, 0, 0]}, 'WH_stamp', {[2.29, 0, 0]}, 'WH_smith', {[0, 0, 0]}, 'WH_clarice', {[0, 0, 0]}, 'WH_eppley', {[1.37, 0, 0]},...
              'LP_clark', {[-1.48, 0, 0]}, 'LP_lib', {[-1.48, 0, 0]}, 'LP_stamp', {[-1.48, 5.14, 0]}, 'LP_smith', {[0, 0, 0]}, 'LP_clarice', {[0, 0, 0]}, 'LP_eppley', {[0, 0, 0]},...
              'GG_clark', {[1.8, -0.79, 0]}, 'GG_lib', {[1.8, 0, 0]}, 'GG_stamp', {[0.93, 0, 0]}, 'GG_smith', {[0.83, 0, 0]}, 'GG_clarice', {[0.9, 0, 0]}, 'GG_eppley', {[1.8, 0, 0]},...
              'MRR_clark', {[-0.35, 0, 0]}, 'MRR_lib', {[-0.35, 1.35, 0]}, 'MRR_stamp', {[-0.35, 1.72, 0]}, 'MRR_smith', {[-0.35, 1.45, 0]}, 'MRR_clarice', {[1.9, -1.35, 0.64]}, 'MRR_eppley', {[1.9, -1.35, 1.15]});

    trailsX = struct('B_clark', {[1609.34, 0, 0]}, 'B_lib', {[2253.08, 0, 0]}, 'B_stamp', {[550, 1703.08, 0]}, 'B_smith', {[550, 400, 1785]}, 'B_clarice', {[550, 2185.88, 0]}, 'B_eppley', {[489, 1925.01, 0]},...
           'UP_clark', {[4345.22, 0, 0]}, 'UP_lib', {[1300, 2240.55, 0]}, 'UP_stamp', {[1300, 2562.42, 0]}, 'UP_smith', {[220, 1872, 0]}, 'UP_clarice', {[1300, 2562.42, 0]}, 'UP_eppley', {[1300, 750, 2134.28]},...
           'MS_clark', {[1609.34, 0, 0]}, 'MS_lib', {[550, 1542.14, 0]}, 'MS_stamp', {[550, 1703.08, 0]}, 'MS_smith', {[650, 400, 1364.01]}, 'MS_clarice', {[400, 2496.81, 0]}, 'MS_eppley', {[489, 3212.48, 0]},...
           'WH_clark', {[1000, 400, 0]}, 'WH_lib', {[643.74, 0, 0]}, 'WH_stamp', {[200, 604.67, 0]}, 'WH_smith', {[482.80, 0, 0]}, 'WH_clarice', {[1609.34, 0, 0]}, 'WH_eppley', {[250, 1359.34, 0]},...
           'LP_clark', {[850, 437.47, 0]}, 'LP_lib', {[850, 598.41, 0]}, 'LP_stamp', {[850, 100, 337.47]}, 'LP_smith', {[1770.27, 0, 0]}, 'LP_clarice', {[643.74, 0, 0]}, 'LP_eppley', {[49.99, 0, 0]},...
           'GG_clark', {[350, 1600, 303.08]}, 'GG_lib', {[350, 1259.34, 0]}, 'GG_stamp', {[1300, 631.21, 0]}, 'GG_smith', {[900, 226.54, 0]}, 'GG_clarice', {[1200, 892.14, 0]}, 'GG_eppley', {[350, 2546.81, 0]},...
           'MRR_clark', {[3400, 301.48, 0]}, 'MRR_lib', {[3400, 1100, 0]}, 'MRR_stamp', {[3400, 1100, 0]}, 'MRR_smith', {[3400, 1300, 288.95]}, 'MRR_clarice', {[450, 1100, 1700]}, 'MRR_eppley', {[450, 1100, 900]});
    trailsE = zeros([42, 1]);
    
    % ==Trails== %
    crr=c_roll_resist(p,v);
    crr_a = crr;
    crr_c = 0.5 * crr;
    crr_g = 2 * crr;
    
    % x from trailsX, theta from trailsTheta
    % Work = x*m*g*(crr*cosd(theta(1)) + sind(theta(1))) + x*m*g*(crr*cosd(theta(2)) + sind(theta(2))) + x*m*g*(crr*cosd(theta(3)) + sind(theta(3)));
    % Get energy required by each trail
    fields = fieldnames(trailsX);
    fields = string(fields);
    for i = 1:length(fields)
        name=fields(i);
        trailsE(i) = trailsX.(name)(1)*m*g*(crr*cosd(trailsTheta.(name)(1)) + ...
        sind(trailsTheta.(name)(1))) + ...
        trailsX.(name)(2)*m*g*(crr*cosd(trailsTheta.(name)(2)) + ...
        sind(trailsTheta.(name)(2))) + ...
        trailsX.(name)(3)*m*g*(crr*cosd(trailsTheta.(name)(3)) + ...
        sind(trailsTheta.(name)(3)));
    end
end