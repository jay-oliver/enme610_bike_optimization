crr = [0.00231 0.00249 0.00276 0.00327]
p = [8.3 6.9 5.5 4.1]
v = 29
equations = @(x) [x(1) + (1/p(1))*(x(2) + x(3)*(v/x(4))^2) - crr(1);
                x(1) + (1/p(2))*(x(2) + x(3)*(v/x(4))^2) - crr(2);
                x(1) + (1/p(3))*(x(2) + x(3)*(v/x(4))^2) - crr(3);
                x(1) + (1/p(4))*(x(2) + x(3)*(v/x(4))^2) - crr(4)];
x0 = [1, 1, 1, 1];
y  = fsolve(equations, x0)

function c = crr_calc(v, p)
    c = y(1) + (1/p(1))*(y(2) + y(3)*(v/y(4))^2)
end