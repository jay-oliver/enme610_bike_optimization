% Trail Energy Offset 
function TE=trail_energy(m,p,v)
    g=9.81; %m/s^2, gravity constant 
    % Trail Data 
    % B -- Berwyn
    % UP -- University Park
    % MS -- Metro Station
    % WH -- Washington Hall
    % LP -- La Plata
    % GG -- Graduate Gardens
    % MRR -- Metzerott Road Residences
    % Each array of three corresponds to three sections of a trail, 0s are used
    % where a trail has fewer than three sections. For example
    % trailsTheta.B_clark[1] is the theta value for the first cosd(theta) and
    % sind(theta), trailsTheta.B_clark[2] corresponds to the second, etc
    % This is all compressed into "Trail_Data.mat"
    load('Trail_Data.mat')
    TE = zeros([42, 1]);
    
    % ==Trails== %
    crr=c_roll_resist(p,v);
    crr_a = crr;
    crr_c = 0.5 * crr;
    crr_g = 2 * crr;
    
    % x from trailsX, theta from trailsTheta
    % Work = x*m*g*(crr*cosd(theta(1)) + sind(theta(1))) + x*m*g*(crr*cosd(theta(2)) + sind(theta(2))) + x*m*g*(crr*cosd(theta(3)) + sind(theta(3)));
    % Get energy required by each trail
    fields = fieldnames(trailsX);
    fields = string(fields);
    for i = 1:length(fields)
        name=fields(i);
        TE(i) = trailsX.(name)(1)*m*g*(crr*cosd(trailsTheta.(name)(1)) + ...
        sind(trailsTheta.(name)(1))) + ...
        trailsX.(name)(2)*m*g*(crr*cosd(trailsTheta.(name)(2)) + ...
        sind(trailsTheta.(name)(2))) + ...
        trailsX.(name)(3)*m*g*(crr*cosd(trailsTheta.(name)(3)) + ...
        sind(trailsTheta.(name)(3)));
    end
end