% Penalty Method Script
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

    % Penalty method turns a constrained problem into an unconstrained problem
    % Going to use exterior inverse penalty model, summing (1/g)^2
    % Obj:Power [f(design_varis)=power_total]
    % Design Vari's= V_roll, Gear_Ratio, Tire_Pressure
    % inequality constraints are as follows:
    %   4.4704<=V_rolling<=8.9408 [m/s]      ||g1:4.4704-V_rolling<=0, g2:V_rolling-8.9408<=0
    %   0<=Gear Ratio<=5 [unitless]          ||g3:GR-5<=0, g4:-GR<=0
    %   2.41317<=Tire Pressure<=4.13685 [bar]||g5:2.41317-Tire_Pressure<=0, g6:Tire_Pressure-4.13685<=0
    %   0<=efficiency<=100                   ||g7: -efficiency<=0 g8: efficiency<=100
    %   0<=crr                               ||g9: -crr<=0
    % There are no equality conditions in this formulation!
    %
    % Another input is going to be the trail conditions, in the Trail_Data file
    load("Trail_Data.mat");
    fields = fieldnames(trailsX);
    fields = string(fields);
    test_i=35;

    % ==Numbers unique to penalty function implementation==
    % Initial penalty coefficient, one for ineq and one for eq
    r=1;
    % alpha value, which will be used to "nudge" r in the right direction
    a=1.25;
    % end condition, the minimum change for the loop to continue
    e=1e-4;

    % Using a matrix "d" where each element is a different variables
    % d(1)=v_roll, d(2)=gr, d(3)=p
    di=[5,2.5,2.5];

    % Start the loop with 2 incorrect attempts to kickstart the cycle.
    Opt_DV_a=di;
    Opt_Phi_a=0;
    [Opt_DV_b,Opt_Phi_b]=fminunc(phi_r(r,test_i,trailsTheta.(fields(test_i)), trailsX.(fields(test_i)), m,CdA),di);
    while abs(Opt_DV_a(1)-Opt_DV_b(1))>=e || abs(Opt_DV_a(2)-Opt_DV_b(2))>=e || abs(Opt_DV_a(3)-Opt_DV_b(3))>=e
        r=r*a;
        Opt_DV_a=Opt_DV_b;
        Opt_Phi_a=Opt_Phi_b;
        [Opt_DV_b,Opt_Phi_b]=fminunc(phi_r(r,test_i,trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), m,CdA),di);
    end
    Optimal_Design_Variables=Opt_DV_b;
    Optimal_Power_sections=power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), Opt_DV_b(1),Opt_DV_b(2),Opt_DV_b(3),m,CdA);
    Optimal_Energy=energy_sum(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)),Opt_DV_b(1),Opt_DV_b(2),Opt_DV_b(3),m,CdA);
    
    figure(1)
    hold on
    title('Optimal Power v. Person Mass (Penalty Method)')
    subtitle('Gray is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Power (W)')
    plot(mp, Optimal_Power_sections, ...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])

    figure(2)
    hold on
    title('Optimal Energy v. Person Mass (fmincon)')
    subtitle('Gray is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Energy (J)')
    plot(mp,Optimal_Energy,...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])

    figure(3)
    hold on
    title('Optimal Velocity v. Person Mass (fmincon)')
    subtitle('Gray is mp=60, White is mp=110')
    xlabel('Person Mass (kg)')
    ylabel('Optimal Energy (m/s)')
    plot(mp,Opt_DV_b(1),...
        'o', ...
        'MarkerEdgeColor','black', ...
        'MarkerFaceColor',[(1/110)*mp,(1/110)*mp,(1/110)*mp])
end
%% Phi defined as a function so r can be modified
function phi=phi_r(r,test_i,trailsTheta,trailsX, m,CdA)
phi=@(d) sum(power_total(trailsTheta,trailsX, d(1),d(2),d(3),m,CdA)) + ...
    r*(((1/(4.4704-d(1)))^2)+...
    ((1/(d(1)-8.9408))^2)+...
    ((1/(d(2)-5))^2)+...
    ((1/(-d(2)))^2)+...
    ((1/(2.41317-d(3)))^2)+...
    ((1/(d(3)-4.13685))^2)+...
    ((1/(-eff_eval(d(2))))^2)+...
    ((1/(eff_eval(d(2))-100))^2)+...
    ((1/(-c_roll_resist(d(3),d(1))))^2));
end