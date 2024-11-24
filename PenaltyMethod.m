% Penalty Method Script 
clear
clc
%% Little sandbox to see how changing r works (Delete before submission)
% Penalty method turns a constrained problem into an unconstrained problem 
% phi(x,r)=f(x)+r*P(x) where P(x)= sum(g(x)^2) + sum(h(x)^2))

% To test this, lets use a sample set from class 
f=@(x) (x(1)-1).^2 + (x(2)-2).^2;
g1=@(x) x(1)+x(2)-2;
% Penalty fxn is g(x)^2
% Assuming an unfeasible point, exterior penalty method 
ri=1000; %Some initial r value 
phi=@(x) f([x(1),x(2)]) + ri*(g1([x(1),x(2)]))^2; 

% constrained for reference 
[sx,sf]=fmincon(f,[0,0],[1,1],2)

xi=[0,0]; % Doing an exterior penalty method, assuming r to be high
[x,fx]=fminunc(phi,xi)

%% Actual thing