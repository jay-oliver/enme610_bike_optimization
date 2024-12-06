% fminimax script
clear
clc
m_Vari=60:1:110; %CdA Variation
for mp=m_Vari
    % ===Constants===
    % total mass
    m=mp+13.6078; %mass for the person, 30lbs (13.6078kg) for a bike
    CdA=1; % Characteristic Area Approximation
    import power_total.*
    import c_roll_resist.*
    import eff_eval.*

    % fminimax() is blessedly simple, we are just constraining all of our
    % inputs with an lb and ub.
    % Obj:
    %   Power [f(design_varis)=power_total],
    %   Energy[f(design_varis)=energy_total)]
    % Design Vari's= V_roll, Gear_Ratio, Tire_Pressure
    % inequality constraints are as follows:
    %   4.4704<=V_rolling<=8.9408 [m/s]      ||g1:4.4704-V_rolling<=0, g2:V_rolling-8.9408<=0
    %   0<=Gear Ratio<=5 [unitless]||g3:Gear_Ratio-5<=0
    %   35<=Tire Pressure<=60 [psi]||g4:35-Tire_Pressure<=0,g5:Tire_Pressure-60<=0
    %
    % Going to make efficiency a non-linear constraint instead of an inequality.
    %
    % There are no equality conditions in this formulation!

    % Another input is going to be the trail conditions, in the Trail_Data file
    load("Trail_Data.mat");
    fields = fieldnames(trailsX);
    fields = string(fields);
    test_i=35;

    % Using a matrix "d" where each element is a different variables
    % d(1)=v_roll, d(2)=gr, d(3)=p
    di=[5,2.5,2.5];
    % Defining the lower and upper bounds
    lb=[4.4704,0,2.41317];
    ub=[8.4908,5,4.13685];

    % blessedly simple fminimax
    energy_total_opt=@(d) energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),d(1),d(2),d(3),m,CdA);
    power_total_opt=@(d) -1*sum(power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), d(1),d(2),d(3),m,CdA))
    f_opt=@(d) [energy_total_opt(d),power_total_opt(d)];
    options=optimset('Algorithm','active-set');
    [Opt_DV,Opt_Objs]=fminimax(f_opt,di,[],[],[],[],lb,ub,@nonlincon,options);

    Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)), trailsX.(fields(test_i)), Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA);
    Optimal_Energy=energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),Opt_DV(1),Opt_DV(2),Opt_DV(3),m,CdA);

    %Chart Optimal Results
    figure(1)
    hold on
    title('Optimal Power v. Person Mass (fminimax)')
    subtitle('Gray is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Power (W)')
    plot(mp,Optimal_Power_sections,...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])

    figure(2)
    hold on
    title('Optimal Energy v. Characteristic Area (fminimax)')
    subtitle('Gray is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Energy (J)')
    plot(mp,Optimal_Energy,...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])

    figure(3)
    hold on
    title('Optimal Velocity v. Person Mass (fminimax)')
    subtitle('Black is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Velocity (m/s)')
    plot(mp,Opt_DV(1),...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])

end

% We are also defining the efficiency equation to max out at 100ish
function [c,ceq] = nonlincon(d)
c(1)=eff_eval(d(2))-100;
c(2)=-eff_eval(d(2));
c(3)=-c_roll_resist(d(3),d(1));
ceq=[];
end