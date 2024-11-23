%import crr_calc.m

crr = [0.00231 0.00249 0.00276 0.00327];
p = [8.3 6.9 5.5 4.1];
v = 29;
equations = @(x) x(1) + (1./p)*(x(2) + x(3)*(v/x(4))^2) - crr

x0 = [1, 2, 0, 2];
options = optimoptions('fsolve'); 
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 5000;
y  = fsolve(equations, x0, options)
%y = [0.0014 1.6336 -0.0576 5.4576];
%coefficient = crr(15, 29, y)
