% ===Constants===
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
    Y(i,:) = power_total(trailsTheta.(fields(test_i)),trailsX.(fields(test_i)), v(i), gr(i), p(i), m, 1);
end




