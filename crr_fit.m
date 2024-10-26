
crr = [0.00231 0.00249 0.00276 0.00327];
p = [8.3 6.9 5.5 4.1];
v = 29;
equations = @(x) [x(1) + (1/p(1))*(x(2) + x(3)*(v/x(4))^2) - crr(1);
                x(1) + (1/p(2))*(x(2) + x(3)*(v/x(4))^2) - crr(2);
                x(1) + (1/p(3))*(x(2) + x(3)*(v/x(4))^2) - crr(3);
                x(1) + (1/p(4))*(x(2) + x(3)*(v/x(4))^2) - crr(4)];
x0 = [1, 2, 0, 2];
options = optimoptions('fsolve'); 
options.MaxIterations = 1000;
options.MaxFunctionEvaluations = 5000;
y  = fsolve(equations, x0, options)
%y = [0.0014 1.6336 -0.0576 5.4576];
coefficient = crr_calc(15, 29, y)
