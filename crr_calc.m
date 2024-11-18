%coefficients
y = [0.0014 1.6336 -0.0576 5.4576];
%velocity in km/hr
v = 29; 
%pressure in bars
p = 5;
c = y(1) + (1/p(1))*(y(2) + y(3)*(v/y(4))^2)

