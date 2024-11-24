% Penalty Method Script 
clear
clc

% Penalty method turns a constrained problem into an unconstrained problem 
% phi(x,r)=f(x)+r*P(x) where P(x)= sum(max(0,g(x))^2) + sum(h(x)^2))

% To test this, lets use a sample set from class 
f=@(x) (x(1)-1).^2 + (x(2)-2).^2;
g1=@(x) x(1)+x(2)-2;
% Penalty fxn is g(x)^2
% Assuming an unfeasible point, exterior penalty method 
ri=1; %Some initial r value 
phi=@(x) f([x(1),x(2)]) + r*(g1([x(1),x(2)]))^2; 

% constrained for reference 
[sx,sf]=fmincon(f,[0,0],[1,1],2)

xi=[0,0]; % Doing an exterior penalty method, assuming r to be high
options=optimset('MaxFunEval',100);
[x,fx]=fminunc(phi,xi,options)

% Actual function to start modifying the penalty value
% BHJay_Ext_Penalty
% (function, initial input, end_condition, adjustment factor)
function [opt_x,opt_f]=BHJay_Ext_Penalty(func,xi,end_con,alpha)
    eta=end_con;
    a=alpha; 
    
end