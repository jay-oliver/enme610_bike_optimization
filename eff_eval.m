% Function for relating drivetrain efficiency to the gear ratio 
function Efficiency=Eff_Eval(GR)
    % putting an X array in here from 150W
    x=[0.2305,-1.4954,2.3600,91.8599];
    Efficiency=(x(1)*(GR^3) + x(2)*(GR^2)+ x(3)*(GR)+x(4));
end