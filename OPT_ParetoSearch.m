% fminimax script
clear
clc

% ===Constants===
% total mass
m=70+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
import power_total.*
import c_roll_resist.*
import eff_eval.*

% fminimax() is blessedly simple, we are just constraining all of our
% inputs with an lb and ub. 
% Obj:
%   Power [f(design_varis)=power_total],
%   Energy[f(design_varis)=energy_total)]
% Design Vari's= V_roll, Gear_Ratio, Tire_Pressure
% inequality constraints are as follows: 
%   4.4704<=V_rolling<=8.9408 [m/s]      ||g1:4.4704-V_rolling<=0, g2:V_rolling-8.9408<=0
%   0<=Gear Ratio<=5 [unitless]||g3:Gear_Ratio-5<=0
%   35<=Tire Pressure<=60 [psi]||g4:35-Tire_Pressure<=0,g5:Tire_Pressure-60<=0
%   
% Going to make efficiency a non-linear constraint instead of an inequality.
%
% There are no equality conditions in this formulation!

% Another input is going to be the trail conditions, in the Trail_Data file
load("Trail_Data.mat");
fields = fieldnames(trailsX);
fields = string(fields);
test_i=35;

% Using a matrix "d" where each element is a different variables 
% d(1)=v_roll, d(2)=gr, d(3)=p
di=[5,2.5,2.5];

% Defining the lower and upper bounds of the variables
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];

% blessedly simple fminimax
energy_total_opt=@(d) energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),d(1),d(2),d(3),m);
power_total_opt=@(d) sum(power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), d(1),d(2),d(3),m))
f_opt=@(d) [-energy_total_opt(d),-power_total_opt(d)];
options = optimoptions('paretosearch','Display','iter', ...
    'PlotFcn','psplotparetof', ...
    'InitialPoints',di, ...
    'MaxIterations',1000, ...
    'ParetoSetChangeTolerance',1e-8, ...
    'ConstraintTolerance', 1e-9);
[Opt_DV,Opt_Objs]=paretosearch(f_opt,length(lb),[],[],[],[],lb,ub,@nonlincon,options)
title(['Pareto Front for Trail ',num2str(test_i),' with initial point [',num2str(di),']'])
xlabel('Energy Fxn (J)')
ylabel('Power (W)')

% Now all the code to display the results all pretty-like 
disp(" ")
disp("  ====== Fminimax Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to the Clarice")
disp("  Optimal velocity: " + Opt_DV(1,1) + " m/s")
disp("  Optimal gear ratio (calculated): " + Opt_DV(1,2))
disp("  Optimal tire pressure: " + Opt_DV(1,3) + " bars")
disp("  Power used in each section:")

Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)), trailsX.(fields(test_i)), Opt_DV(1),Opt_DV(2),Opt_DV(3),m);

disp("   Section 1: " + Optimal_Power_sections(1) + " W")
disp("   Section 2: " + Optimal_Power_sections(2) + " W")
disp("   Section 3: " + Optimal_Power_sections(3) + " W")

Optimal_Energy=energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),Opt_DV(1),Opt_DV(2),Opt_DV(3),m);

% We are also defining the efficiency equation to max out at 100ish
function [c,ceq] = nonlincon(d)
    c(1)=eff_eval(d(2))-100;
    c(2)=-eff_eval(d(2));
    c(3)=-c_roll_resist(d(3),d(1));
    ceq=[];
end