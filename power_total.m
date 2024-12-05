% This is the total of power, assuming the acceleration is equal to 0.
function total_power=power_total(trailTheta_Array, trailX_Array, V_roll, Gear_Ratio, Tire_Pressure, m_total)
    import c_roll_resist.*
    import eff_eval.*

    rho=1.225; %kg/m3 , air pressure at stp
    g=9.81; %m/s2
    total_power=zeros(1,3);
    
    for i=1:1:3
        if trailX_Array(i) == 0
            V_roll = 0;
        end
        % Power for acceleration (should we aim for this to be zero)
        accel=0; %Acceleration set to 0, we're just keeping formulation for reading reasons
        Pa = V_roll .* m_total * accel;
        % Power needed to roll
        Pr = V_roll.* m_total * g .* c_roll_resist(Tire_Pressure,V_roll);
        % Power to overcome drag (Cd * A may be ~=1)
        Cd=1;
        A=1;
        Pd = (1/2) .* rho .* V_roll.^3 .* Cd .* A;
        % Power needed to go on a slope (s>0 means uphill)
        s=tand(trailTheta_Array(i));
        Ps = V_roll.* m_total .* g .* s;
        % Total power assembly, with user power
        % Pa==(P_user*(Eff_Eval(Gear_Ratio)/100)) - (Pd + Ps + Pr)
        % Assuming we want acceleration to be 0, here it the formulation to
        % minimize user power input
        total_power(1,i)=((Pd + Ps + Pr + Pa)/(eff_eval(Gear_Ratio)*(1/100)));
    end
end