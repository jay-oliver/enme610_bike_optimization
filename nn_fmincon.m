% fmincon() Script 
clear
clc

% ===Constants===
% total mass
m=90+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
CdA=1; %Characteristic area, found to be =1 for most cases
import power_total.*

%% Leven Marqhardt fmincon()
% fmincon() on the results of the two neural network approximations for
% power
nn1_fxn('trainlm');
load net

% Another input is going to be the trail conditions, in the Trail_Data file
load("Trail_Data.mat");
fields = fieldnames(trailsX);
fields = string(fields);
test_i=35;

% Using a matrix "d" where each element is a different variables 
% d(1)=v_roll, d(2)=gr, d(3)=p
di=[5,2.5,2.5];

% Defining the lower and upper bounds 
% 1 is v, 2 is GR, 3 is P 
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];

%Generate variable values using LHS and scale them to fit in our upper and
%lower bounds
x = lhsdesign(500, 3);
v = x(:,1)*ub(1)/lb(1) + lb(1);
gr = x(:,2)*ub(2) + lb(2);
p = x(:,3)*ub(3)/lb(3) + lb(3);
x = [v gr p];

%Generate total power for trail i given the generated variable values
Y=zeros(500, 3);
for i = 1:length(x)
    Y(i,:) = power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), v(i), gr(i), p(i), m, 1);
end
options=optimset('Algorithm','active-set');

% Opt_DV(1) is velocity
% Opt_DV(2) is gear ratio
% Opt_DV(3) is tire pressure
[Opt_DV,Opt_Power]=fmincon(@n_net1,di,[],[],[],[],lb,ub,@nonlincon,options,net);

disp(" ")
disp("  ====== Leven-Marqhardt FminCon Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to The Clarice")
disp("  Optimal velocity: " + Opt_DV(1) + " m/s")
disp("  Optimal gear ratio (calculated): " + Opt_DV(2))
disp("  Optimal tire pressure: " + Opt_DV(3) + " bars")
disp("  Power used in each section:")

Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA);

disp("   Section 1: " + Optimal_Power_sections(1) + " W")
disp("   Section 2: " + Optimal_Power_sections(2) + " W")
disp("   Section 3: " + Optimal_Power_sections(3) + " W")

%% Bayesion Regulation Implementation 
% fmincon() on the results of the two neural network approximations for
% power
nn1_fxn('trainbr');
load net

% Another input is going to be the trail conditions, in the Trail_Data file
load("Trail_Data.mat");
fields = fieldnames(trailsX);
fields = string(fields);
test_i=35;

% Using a matrix "d" where each element is a different variables 
% d(1)=v_roll, d(2)=gr, d(3)=p
di=[5,2.5,2.5];

% Defining the lower and upper bounds 
% 1 is v, 2 is GR, 3 is P 
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];

%Generate variable values using LHS and scale them to fit in our upper and
%lower bounds
x = lhsdesign(500, 3);
v = x(:,1)*ub(1)/lb(1) + lb(1);
gr = x(:,2)*ub(2) + lb(2);
p = x(:,3)*ub(3)/lb(3) + lb(3);
x = [v gr p];

%Generate total power for trail i given the generated variable values
Y=zeros(500, 3);
for i = 1:length(x)
    Y(i,:) = power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), v(i), gr(i), p(i), m, 1);
end
options=optimset('Algorithm','active-set');

% Opt_DV(1) is velocity
% Opt_DV(2) is gear ratio
% Opt_DV(3) is tire pressure
[Opt_DV,Opt_Power]=fmincon(@n_net1,di,[],[],[],[],lb,ub,@nonlincon,options,net);

disp(" ")
disp("  ====== Bayesian Regulation FminCon Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to The Clarice")
disp("  Optimal velocity: " + Opt_DV(1) + " m/s")
disp("  Optimal gear ratio (calculated): " + Opt_DV(2))
disp("  Optimal tire pressure: " + Opt_DV(3) + " bars")
disp("  Power used in each section:")

Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA);

disp("   Section 1: " + Optimal_Power_sections(1) + " W")
disp("   Section 2: " + Optimal_Power_sections(2) + " W")
disp("   Section 3: " + Optimal_Power_sections(3) + " W")



%% Function Dump 
% We are also defining the efficiency equation to bottom out at 100ish
function [c,ceq] = nonlincon(d, NN_Model)
    c(1)=eff_eval(d(2))-100;
    c(2)=-eff_eval(d(2));
    c(3)=-c_roll_resist(d(3),d(1));
    ceq=[];
end

function nnet1 = n_net1(d, net)
     nnet1 = sum(net(d'));
end

