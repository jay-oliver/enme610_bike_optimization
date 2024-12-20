function nn=nn1_fxn(type)% ===Constants===
% total mass
m=70+13.6078; %70kg for the person, 30lbs (13.6078kg) for a bike 
import power_total.*

% Trail conditions, in the Trail_Data file
load("Trail_Data.mat");
fields = fieldnames(trailsX);
fields = string(fields);
test_i=35;
% Defining the lower and upper bounds of the variables
lb=[4.4704,0,2.41317];
ub=[8.4908,5,4.13685];

%Generate variable values using LHS and scale them to fit in our upper and
%lower bounds
x = lhsdesign(500, 3);
v = x(:,1)*ub(1)/lb(1) + lb(1);
gr = x(:,2)*ub(2) + lb(2);
p = x(:,3)*ub(3)/lb(3) + lb(3);
x = [v gr p];

%Generate total power for trail i given the generated variable values
Y=zeros(500, 3);
for i = 1:length(x)
    Y(i,:) = -1*power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), v(i), gr(i), p(i), m, 1);
end
% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 05-Dec-2024 20:15:39
%
% This script assumes these variables are defined:
%
%   x - input data.
%   Y - target data.

x = x';
t = Y';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest. 
% (Levenberg-Marquardt)
% 'trainbr' takes longer but may be better for challenging problems.
% (Bayesian Regularization)
% 'trainscg' uses less memory. Suitable in low memory situations. 
% (Scaled Conjugate Gradient)
trainFcn = type;  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 50;
net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

save net

% View the Network
%view(net)

switch type 
    case 'trainlm'
        fancy_name='Levenberg-Marqhardt';
    case 'trainbr'
        fancy_name='Bayesian Regularization'
    case 'trainscg'
        fancy_name='Scaled Conjugate Gradient'
end

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% subtitle([fancy_name,' Method'])
% figure, plottrainstate(tr)
% subtitle([fancy_name,' Method'])
% figure, ploterrhist(e)
% subtitle([fancy_name,' Method'])
% figure, plotregression(t,y)
% subtitle([fancy_name,' Method'])
%figure, plotfit(net,x,t)
end