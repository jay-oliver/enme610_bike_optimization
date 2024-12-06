% Vector optimization script 
clear
clc

% ===Constants===
% total mass
m=70+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
CdA=1; %Characteristic area, found to be =1 for most cases
import power_total.*
import c_roll_resist.*
import eff_eval.*

% We will be going with a scalarization approach due to our constrained
% design domain which allows us to normalize the functions for weighting. 
%
% Objs:
%   Power [f(design_varis)=power_total],
%   Energy[f(design_varis)=energy_total)]
%
% Design Vari's= V_roll, Gear_Ratio, Tire_Pressure
% inequality constraints are as follows: 
%   4.4704<=V_rolling<=8.9408 [m/s]      ||g1:4.4704-V_rolling<=0, g2:V_rolling-8.9408<=0
%   0<=Gear Ratio<=5 [unitless]||g3:Gear_Ratio-5<=0
%   35<=Tire Pressure<=60 [psi]||g4:35-Tire_Pressure<=0,g5:Tire_Pressure-60<=0
%   
% Going to make efficiency and crr a non-linear constraint instead of an inequality.
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
% Defining the lower and upper bounds 
lb=[4.4704,0.5,2.41317];
ub=[8.4908,5,4.13685];

% cursedly non-simple normalization and scalarization
% sloppy normalization, but it works for our fxns
energy_total_opt=@(v,g,p) energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),v,g,p,m,CdA);
esum=0;
for i=lb(1):0.1:ub(1)
    sz(1)=length(i);
    for j=lb(2):0.1:ub(2)
        sz(2)=length(j);
        for k=lb(3):0.1:ub(3)
            sz(3)=length(k);
            esum=esum+energy_total_opt(i,j,k);
        end
    end
end
e_avg=esum/(sz(1)*sz(2)*sz(3));

power_total_opt=@(v,g,p) -1*sum(power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), v,g,p,m,CdA))
psum=0;
for i=lb(1):0.1:ub(1)
    sz(1)=length(i);
    for j=lb(2):0.1:ub(2)
        sz(2)=length(j);
        for k=lb(3):0.1:ub(3)
            sz(3)=length(k);
            psum=psum+power_total_opt(i,j,k);
        end
    end
end
p_avg=psum/(sz(1)*sz(2)*sz(3));

f_opt=@(d) (5e-1*(1/e_avg)*energy_total_opt(d(1),d(2),d(3)))+(5e-1*(1/p_avg)*power_total_opt(d(1),d(2),d(3)))
options=optimset('PlotFcn','optimplotFval');
[Opt_DV,Opt_Objs]=fmincon(f_opt,di,[],[],[],[],lb,ub,@nonlincon,options)

Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA)
Optimal_Energy=energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA)
TP=sum(Optimal_Power_sections)
TE=sum(Optimal_Energy)
disp(" ")
disp("  ====== Scalarization Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to The Clarice")
disp("  Optimal velocity: " + Opt_DV(1) + " m/s")
disp("  Optimal gear ratio (calculated): " + Opt_DV(2))
disp("  Optimal tire pressure: " + Opt_DV(3) + " bars")
disp("  Power used in each section:")

disp("   Section 1: " + Optimal_Power_sections(1) + " W")
disp("   Section 2: " + Optimal_Power_sections(2) + " W")
disp("   Section 3: " + Optimal_Power_sections(3) + " W")
% We are also defining the efficiency equation to max out at 100ish
function [c,ceq] = nonlincon(d)
    c(1)=eff_eval(d(2))-100;
    c(2)=-eff_eval(d(2));
    c(3)=-c_roll_resist(d(3),d(1));
    ceq=[];
end