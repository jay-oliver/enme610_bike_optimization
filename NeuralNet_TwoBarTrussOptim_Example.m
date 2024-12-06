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


function f = NeuralNet_TwoBarTrussOptim_Example
% This is the Main Function (Driver Routine)

f=0;

%  Run the conventional optimization - using actual function calls and no
%  ML methods to speed up the calculations.

% Uncomment this to run the conventional approach
Run_TBT_Conventional(); 
% return;


% Generate Data for Neural Network
Generate_TBTData_NeuralNet(500);


% Develop the Neural Network (NN)
% Open this function script to change any NN related parameters and display
% options.
Prepare_NeuralNetwork();


% Run the same optimization, but this time using the Neural Network for
% prediction of the objective function
Run_TBT_WithNN();
end



function f1 = Run_TBT_Conventional()
% This script runs the example optimization case using the actual function
% calls for the objectives and constraints.

x0 = [1, 1, 1]; 

% These are the original problem bounds as found in the literature
% lb = [1 0 0]; ub = [3, inf, inf];

% We are going to use more realistic (engineering judgement based) values
lb = [1 1E-6 1E-6]; ub = [3, 5, 5];

options = optimset('Algorithm', 'active-set');

[x, f, flag, output0] = fmincon(@TrussNonLinF, x0, [], [], [], [], lb, ub,...
@TrussNonLinCon, options);

% return;
x
f
output0



end



function f3 = Run_TBT_WithNN()


x0 = [1, 1, 1]; 

% These are the original problem bounds as found in the literature
% lb = [1 0 0]; ub = [3, inf, inf];

% We are going to use more realistic (engineering judgement based) values
lb = [1 1E-6 1E-6]; ub = [3, 5, 5];


options = optimset('Algorithm', 'active-set');

load net;

tic;
[x, f, flag, output0] = fmincon(@TrussNonLinF_NN, x0, [], [], [], [], lb, ub,...
@TrussNonLinCon_NN, options, net);

x

f 

output0


fprintf("Done optimization using Neural Network\n");


% Above objective value is the NN predicted value.
% Check for the true value.
objTrue = TrussNonLinF(x);
fprintf("\n True objective value at optimum : %f", objTrue);



end




function f2 = Generate_TBTData_NeuralNet(sampCount)
% Function to generate the source data for developing the neural network
% (i.e., training, verification and validation).
%  The generated data is saved in files. These file names should be
%  consistent with other parts of the code, where they are used again.

% Generate Data using LHS method

nDim = 3;


lb = [1 1E-6 1E-6]; ub = [3, 5, 5];

normDesign = lhsdesign(sampCount,nDim);

actualDesign = lb + (normDesign .* (ub-lb));

objValues = zeros(sampCount,1);

for i=1:sampCount
    objValues(i) = TrussNonLinF(actualDesign(i,:));
end

% Save the input variables and objective function values for later use
writematrix(actualDesign, 'DesignVars.txt');
writematrix(objValues, 'ObjValues.txt');

% Generate more data for random verification, in addition to whatever is
% required for the Neural Net

randNormDesign = rand(sampCount,nDim);

randActualDesign = lb + (randNormDesign .* (ub-lb));

randObjValues = zeros(sampCount,1);

for i=1:sampCount
    randObjValues(i) = TrussNonLinF(randActualDesign(i,:));
end

% Save the random input variables and their objective function values for later use
writematrix(randActualDesign, 'DesignVars_RandomSet.txt');
writematrix(randObjValues, 'RandomObjValues_RandomSet.txt');


end


function f = TrussNonLinF(x)
% Function to evaluate the objective for the problem
sigma = 10^5;
global objCnt;

objCnt = objCnt +1;

% Objective Function with single parameter passing (sigma)

y = x(1); x1 = x(2); x2 = x(3);
f = x1*sqrt(16+y^2)+x2*sqrt(1+y^2);

% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end

function [C,Ceq] = TrussNonLinCon(x)
% Function to evaluate the constraints for the problem.
% Note that this function is in the form required by the built-in
% optimization methods.
sigma = 10^5;

% Constraint Function with single parameter passing (sigma)

y = x(1); x1 = x(2); x2 = x(3);
C(1) = 20*sqrt(16+y^2)-sigma*y*x1;
C(2) = 80*sqrt(1+y^2)-sigma*y*x2;
Ceq = [];

% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end

function f = TrussNonLinF_NN(x, nnModel)
% Function to evaluate the objective for the problem, but using a trained
% Neural Network instead of the actual equations

% Objective Function with single parameter passing (sigma)


f = nnModel(x');

% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end

function [C,Ceq] = TrussNonLinCon_NN(x, nnModel)
% Function to evaluate the constraints for the problem.
% Note that this function is in the form required by the built-in
% optimization methods.
sigma = 10^5;


% Constraint Function with single parameter passing (sigma)

y = x(1); x1 = x(2); x2 = x(3);
C(1) = 20*sqrt(16+y^2)-sigma*y*x1;
C(2) = 80*sqrt(1+y^2)-sigma*y*x2;
Ceq = [];

% Use this line to introduce a delay so simulate a long-running/complex function
% pause(0.5);

end



