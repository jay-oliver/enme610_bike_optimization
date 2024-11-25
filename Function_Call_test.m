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

% Coeff_Rolling_Resist (made this one arrayable)
import c_roll_resist.*
crr_test=c_roll_resist(p/14.504,v)

% Efficiency Evaluation 
import Eff_Eval.*
Eff_test=Eff_Eval(GR)/100

% Power 
import power_total.*
% v in m/s, GR in unitless, p in bar, m in kg, s in unitless
Power_test=power_total(v,GR,p/14.504,m,s) %Spits out power in W