% Data gotten from bicyclerollingresistance.com 
% Tire is the Schwalbe G-One Ultrabite  Speedgrip 40 
% https://www.bicyclerollingresistance.com/cx-gravel-reviews/schwalbe-g-one-ultrabite
crr = [0.00734 0.00743 0.00779 0.00848];
p = [3.7 3.1 2.6 1.9]; %bar
v = 29; %kph
equations = @(x) x(1) + (1./p)*(x(2) + x(3)*(v/x(4))^2) - crr

x0 = [1, 1, 0, 1];
options = optimoptions('fsolve'); 
options.MaxIterations = 10000;
options.MaxFunctionEvaluations = 50000;
y  = fsolve(equations, x0, options)
crr_t=y(1) + (1./p(1))*(y(2) + y(3)*(v/y(4))^2)

%Syntax is (tire pressure in bar, rolling speed in kph)
% Test calling the function 
clear
import c_roll_resist.*
tp=[35,40,45,50]; %psi 
tp=tp./14.504; %bar
tv=[29 29 29 29]; %kph
tv=tv./(3600/1000); %m/s
Ex1=c_roll_resist(tp,tv)

