% 20240404 - Vikrant C. Aute, Shapour Azarm
% ENME 410 Spring 2024 University of Maryland
% Two-bar truss optimization problem formulation with example of parameter passing
% and the use of Neural Networks to demonstrate
% approximation-assisted-optimization using Machine Learning Methods
% This is the main function


% Prerequisites
%    There are two script files for this demo. This file and the
%    Prepare_NeuralNetwork.m file. The second file is created using the
%    code generation feature in the nftool
%    All files must be in the same folder, including any intermediate
%    generated files.

% Refer to Matlab documentation for explanation of Matlab Functions


function f = NeuralNet
% This is the Main Function (Driver Routine)

f=0;

% Develop the Neural Network (NN)
% Open this function script to change any NN related parameters and display
% options.
nn1();


% Run the same optimization, but this time using the Neural Network for
% prediction of the objective function
Run_WithNN();

end

function f3 = Run_WithNN()

di=[5,2.5,2.5];

% Defining the lower and upper bounds 
% 1 is v, 2 is GR, 3 is P 
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];

options = optimset('Algorithm', 'active-set');

load net;

tic;
[x, f, flag, output0] = fmincon(@y, di, [], [], [], [], lb, ub,...
@NonLinCon_NN, options, net);

x

f 

output0


fprintf("Done optimization using Neural Network\n");


end



function f = y(x, nnModel)
% Function to evaluate the objective for the problem, but using a trained
% Neural Network instead of the actual equations

% Objective Function with single parameter passing (sigma)


[f; g; h] = nnModel(x');


% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end

function [C,Ceq] = NonLinCon_NN(d, nnModel)
% Function to evaluate the constraints for the problem.
% Note that this function is in the form required by the built-in
% optimization methods.
    c(1)=eff_eval(d(2))-100;
    c(2)=-eff_eval(d(2));
    c(3)=-c_roll_resist(d(3),d(1));
    ceq=[];

% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end



