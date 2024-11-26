%% Function call test 
% This script just test calls all of the functions to make sure they work
clear
clc
% constants to test with 
v = 18; % mph, target rolling velocity 
v = v/2.237; % m/s
GR=2.5; % Gear Ratio 
p=60; %psi 
m=70+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
s=0.05; % slope, used for characterizing hills

% Loading the trail data file, to then pull out individual trails
load('Trail_Data.mat');
fields = fieldnames(trailsX);
fields = string(fields);

% Coeff_Rolling_Resist (made this one arrayable)
import c_roll_resist.*
crr_test=c_roll_resist(p,v)

% Efficiency Evaluation 
import eff_eval.*
Eff_test=eff_eval(GR)/100

% Power 
import power_total.*
% v in m/s, GR in unitless, p in bar, m in kg
Power_test=power_total(trailsTheta.(fields(10)),v,GR,p,m) %Spits out power in W

% Trail energy, the energy needed to get over our trails 
import trail_energy.*
% m is in kg, p is in psi, v is in m/s
TE_Ex=trail_energy(m,p,v)

% Time for each section of the trail 
import trail_time.*
%trails_time
