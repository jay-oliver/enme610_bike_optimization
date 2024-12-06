% Penalty Method Script 
clear
clc

% ===Constants===
% total mass
m=90+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
CdA=1; %Characteristic area, found to be =1 for most cases
import power_total.*
import c_roll_resist.*
import eff_eval.*

% Penalty method turns a constrained problem into an unconstrained problem
% Going to use exterior inverse penalty model, summing (1/g)^2
% Obj:Power [f(design_varis)=power_total]
% Design Vari's= V_roll, Gear_Ratio, Tire_Pressure
% inequality constraints are as follows: 
%   4.4704<=V_rolling<=8.9408 [m/s]      ||g1:4.4704-V_rolling<=0, g2:V_rolling-8.9408<=0
%   0<=Gear Ratio<=5 [unitless]          ||g3:GR-5<=0, g4:-GR<=0
%   2.41317<=Tire Pressure<=4.13685 [bar]||g5:2.41317-Tire_Pressure<=0, g6:Tire_Pressure-4.13685<=0
%   0<=efficiency<=100                   ||g7: -efficiency<=0 g8: efficiency<=100
%   0<=crr                               ||g9: -crr<=0
% There are no equality conditions in this formulation!
%
% Another input is going to be the trail conditions, in the Trail_Data file
load("Trail_Data.mat");
fields = fieldnames(trailsX);
fields = string(fields);
test_i=35;

% ==Numbers unique to penalty function implementation==
% Initial penalty coefficient, one for ineq and one for eq
r=1;
% alpha value, which will be used to "nudge" r in the right direction 
a=1.25;
% end condition, the minimum change for the loop to continue
e=1e-4;

% Using a matrix "d" where each element is a different variables 
% d(1)=v_roll, d(2)=gr, d(3)=p
di=[5,2.5,2.5];

% Start the loop with 2 incorrect attempts to kickstart the cycle. 
Opt_DV_a=di;
Opt_Phi_a=0;
[Opt_DV_b,Opt_Phi_b]=fminunc(phi_r(r,test_i,trailsTheta.(fields(test_i)), trailsX.(fields(test_i)), m,CdA),di);
while abs(Opt_DV_a(1)-Opt_DV_b(1))>=e || abs(Opt_DV_a(2)-Opt_DV_b(2))>=e || abs(Opt_DV_a(3)-Opt_DV_b(3))>=e
    r=r*a;
    Opt_DV_a=Opt_DV_b;
    Opt_Phi_a=Opt_Phi_b;
    [Opt_DV_b,Opt_Phi_b]=fminunc(phi_r(r,test_i,trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), m,CdA),di);
end
Optimal_Design_Variables=Opt_DV_b;
Optimal_Power_Sections=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), Opt_DV_b(1),Opt_DV_b(2),Opt_DV_b(3),m,CdA);

disp(" ")
disp("  ====== Penalty Method Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to The Clarice")
disp("  Optimal velocity: " + Opt_DV_b(1) + " m/s")
disp("  Optimal gear ratio (calculated): " + Opt_DV_b(2))
disp("  Optimal tire pressure: " + Opt_DV_b(3) + " bars")
disp("  Power used in each section:")

disp("   Section 1: " + Optimal_Power_Sections(1) + " W")
disp("   Section 2: " + Optimal_Power_Sections(2) + " W")
disp("   Section 3: " + Optimal_Power_Sections(3) + " W")
%% Phi defined as a function so r can be modified 
function phi=phi_r(r,test_i,trailsTheta,trailsX, m,CdA)
    phi=@(d) sum(power_total(trailsTheta,trailsX, d(1),d(2),d(3),m,CdA)) + ...
    r*(((1/(4.4704-d(1)))^2)+...
    ((1/(d(1)-8.9408))^2)+...
    ((1/(d(2)-5))^2)+...
    ((1/(-d(2)))^2)+...
    ((1/(2.41317-d(3)))^2)+...
    ((1/(d(3)-4.13685))^2)+...
    ((1/(-eff_eval(d(2))))^2)+...
    ((1/(eff_eval(d(2))-100))^2)+...
    ((1/(-c_roll_resist(d(3),d(1))))^2));
end