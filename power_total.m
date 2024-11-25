function total_power=power_total(V_roll, Gear_Ratio, Tire_Pressure,m_total,s)
    import c_roll_resist.*
    import Eff_Eval.*
    rho=1.225; %kg/m3 , air pressure at stp 
    g=9.81; %m/s2
    % Power for acceleration (should we aim for this to be zero) 
    accel=0; %Acceleration set to 0, we're just keeping formulation for reading reasons
    Pa = V_roll * m_total * accel;
    % Power needed to roll 
    Pr = V_roll * m_total * g * c_roll_resist(Tire_Pressure,V_roll);
    % Power to overcome drag (Cd * A may be ~=1) 
    Cd=1;
    A=1; 
    Pd = (1/2) * rho * V_roll^3 * Cd * A;
    % Power needed to go on a slope (s>0 means uphill)
    Ps = V_roll * m_total * g * s;
    % Total power assembly, with user power 
    % Pa==(P_user*(Eff_Eval(Gear_Ratio)/100)) - (Pd + Ps + Pr)
    % Assuming we want acceleration to be 0, here it the formulation to
    % minimize user power input 
    total_power=(Pd + Ps + Pr + Pa)/(Eff_Eval(Gear_Ratio)*(1/100));
end