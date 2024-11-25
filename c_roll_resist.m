% Defining the coefficient of rolling resistance as a function
function coeff_rolling=c_roll_resist(pressure,velocity)
    % Syntax is c_roll_resist(tire pressure (bar), rolling velocity (kph))
    velocity=velocity*(3600/1000); % convert from m/s 
    x=[0.0102    1.5410   -0.0016    0.9387]; %Coefficients grabbed for mountain bike
    coeff_rolling = x(1) + (1./pressure).*(x(2) + x(3)*(velocity./x(4)).^2);
end