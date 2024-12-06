%% Function call test 
% This script just test calls all of the functions to make sure they work
clear
clc
% constants to test with 
%v = 12; % mph, target rolling velocity 
%v = v/2.237; % m/sz
v=5;
GR=2.5; % Gear Ratio 
p=2.5; %bar 
m=90+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
CdA=1; %Characteristic area, found to be =1 for most cases

% Loading the trail data file, to then pull out individual trails
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
    % This is all compressed into "Trail_Data.mat"
load('Trail_Data.mat');
fields = fieldnames(trailsX);
fields = string(fields);
test_i=10;


% Coeff_Rolling_Resist (made this one arrayable)
import c_roll_resist.*
crr_test=c_roll_resist(p,v)
cplot=@(x,y) c_roll_resist(x,y)
%fsurf(cplot,[2.41317,4.13685,4.47,8.49])

% Efficiency Evaluation 
import eff_eval.*
Eff_test=eff_eval(GR)/100

% Power, in Watts
% power_total(Trail angle data (degrees), Trail distance data (m), velocity (m/s), gear ratio, tire
% pressure (bar), mass (kg),Characteristic Area (m^2))
import power_total.*
Power_test=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),v,GR,p,m,CdA) %Spits out power in W

% Trail energy, the energy needed to get over our trails 
import trail_energy.*
% m is in kg, p is in psi, v is in m/s, value spits out as Joules
TE_Ex=trail_energy(trailsX.(fields(1)),trailsTheta.(fields(1)),m,p,v) 

% Time for each section of the trail 
import trail_time.*
%trails_time
time_Ex=trail_time(trailsX.(fields(test_i)),v)

% Energy test 
import energy_sum.*
% total energy sum for a route, in joules
energy_ex=energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),v,GR,p,m,CdA)

% Normalizing test 
import power_total.*
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];
esum=0;
for i=lb(1):0.1:ub(1)
    sz(1)=length(i);
    for j=lb(2):0.1:ub(2)
        sz(2)=length(j);
        for k=lb(3):0.1:ub(3)
            sz(3)=length(k);
            esum=esum+energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),v,GR,p,m,CdA);
        end
    end
end
e_avg=esum/(sz(1)*sz(2)*sz(3))