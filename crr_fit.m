% Data gotten from bicyclerollingresistance.com 
% Tire is the Schwalbe G-One Ultrabite  Speedgrip 40 
% https://www.bicyclerollingresistance.com/cx-gravel-reviews/schwalbe-g-one-ultrabite
crr = [0.00734 0.00743 0.00779 0.00848];
p = [3.7 3.1 2.6 1.9]; %bar
v = 29; %kph
equations = @(x) x(1) + (1./p)*(x(2) + x(3)*(v/x(4))^2) - crr

x0 = [1, 2, 0, 2];
options = optimoptions('fsolve'); 
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 5000;
y  = fsolve(equations, x0, options)

%Syntax is (tire pressure in bar, rolling speed in kph)
Example_1=c_roll_resist(4,30)

% Defining the coefficient of rolling resistance as a function
function coeff_rolling=c_roll_resist(pressure,velocity)
    x=[0.4898,3.1070,-0.0057,1.0556]; %Coefficients grabbed for mountain bike
    coeff_rolling = x(1) + (1./pressure)*(x(2) + x(3)*(velocity/x(4))^2);
end