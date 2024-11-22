% = This is to tie the power and gear ratio to the efficiency of the
% drivetrain 
% = Peep the google doc
clear
clc

% Yes this is sloppy, stfu
% Define arrays with all the good stuff 
Gear_Ratio=[0.6471,0.8462,0.9412,1.1000,1.2308,1.2941,1.3750,1.6000,1.6923,1.8333,2.0000,2.2000,2.6667,2.7500,3.6667];
Gear_Ratio=[Gear_Ratio,Gear_Ratio,Gear_Ratio];
Power_i=[80,150,200];
Power=[];
for i=1:15
    Power=[Power,Power_i];
end
Efficiency=[93.1,94.6,95.0,92.8,94.6,94.5,89.4,92.9,93.6,92.6,94.5,94.2,90.0,92.5,93.1,92.1,93.9,94.2,91.7,93.8,93.9,89.5,93.0,93.6,91.0,93.6,93.9,90.7,91.8,91.9,90.9,93.0,93.8,94.3,95.0,95.9,86.9,91.0,91.4,93.8,94.8,95.5,91.1,93.3,93.7];

% Make me rows, to make it work 
 Gear_Ratio=Gear_Ratio'; Power=Power'; Efficiency=Efficiency';

% Assuming polynomial form, pascals triangle 
x0=[0,0,0,0,0];

Eff_Eq=@(x)( ...
    x(1)*Gear_Ratio.^3 + ...
    x(2)*(Gear_Ratio.^2).*Power + ...
    x(3)*Gear_Ratio.*(Power.^2)+ ...
    x(4)*Power.^3 + ...
    x(5) - ...
    Efficiency)

options = optimset('MaxFunEvals',1000);
[x,resnorm] = lsqnonlin(Eff_Eq,x0,[],1,[],[]);
format short

% Efficiency Evaluation(Coefficients, Gear Ratio (unitless), Input Power (W))
Ex1=Eff_Eval(x,1.25,200)
Ex2=Eff_Eval(x,4.25,80)


% Testing Eval 
function Efficiency=Eff_Eval(x,GR,P)
    Efficiency=(x(1)*GR^3 + ...
        x(2)*(GR^2)*P + ...
        x(3)*GR*(P^2)+ ...
        x(4)*P^3 + ...
        x(5));
end
