function f = NeuralNet
% This is the Main Function (Driver Routine)

f=0;
listx = [];
listf= [];
%pass 'trainbr' for Bayesian Regularization, or 'trainlm" for
%Levenberg-Marqhardt
nn_fxn('trainbr');
    for i = 1:10
        [xhat, fhat] = Run_WithNN();
        listx = [listx; xhat];
        listf= [listf; fhat];
    end
        mu1 = sum(listx(:,1))/10;
        mu2 = sum(listx(:,2))/10;
        mu3 = sum(listx(:,3))/10;
        muf = sum(listf)/10;
        std1 = std(listx(:,1));
        std2 = std(listx(:,2));
        std3 = std(listx(:,3));
        stdf = std(listf);
        disp(" ")
disp("  ====== Bayesian Regularization MLAO Optimization Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to the Clarice")
disp("  Optimal mean velocity : " + mu1 + " m/s and standard deviation: " + std1)
disp("  Optimal mean gear ratio (calculated): " + mu2 + " and standard deviation: " + std2)
disp("  Optimal mean tire pressure: " + mu3 + " bars and standard deviation: " + std3)
disp("  Mean sum of Power used in all sections: " + -1*muf + " W and standard deviation: " + stdf)

end

function [x, f] = Run_WithNN()

di=[5,2.5,2.5];

% Defining the lower and upper bounds 
% 1 is v, 2 is GR, 3 is P 
lb=[4.4704,0.5,2.41317];
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
% Now all the code to display the results all pretty-like 
disp(" ")
disp("  ====== Levenberg-Marqhardt MLAO Optimization Results ======")
disp(" ")
disp("  Trail: Graduate Gardens to the Clarice")
disp("  Optimal velocity: " + x(1) + " m/s")
disp("  Optimal gear ratio (calculated): " + x(2))
disp("  Optimal tire pressure: " + x(3) + " bars")
disp("  Sum of Power used in all sections: " + -1*f + " W")

end

function f = y(x, nnModel)
% Function to evaluate the objective for the problem, but using a trained
% Neural Network instead of the actual equations

f = sum(nnModel(x'))

end

function [c,ceq] = NonLinCon_NN(d, nnModel)
% Function to evaluate the constraints for the problem.
    c(1)=eff_eval(d(2))-100;
    c(2)=-eff_eval(d(2));
    c(3)=-c_roll_resist(d(3),d(1));
    ceq=[];
end



