% Trail Energy Offset 
function TE=trail_energy(trailsX,trailsTheta,m,p,v)
    g=9.81; %m/s^2, gravity constant 

    % ==Trails== %
    crr=c_roll_resist(p,v);
    crr_a = crr;
    crr_c = 0.5 * crr;
    crr_g = 2 * crr;
    
    % x from trailsX, theta from trailsTheta
    % Work = x*m*g*(crr*cosd(theta(1)) + sind(theta(1))) + x*m*g*(crr*cosd(theta(2)) + sind(theta(2))) + x*m*g*(crr*cosd(theta(3)) + sind(theta(3)));
    % Get energy required by each trail
    TE=0;
    for i=1:length(trailsX)
        TE=TE+trailsX(i)*m*g*(crr*cosd(trailsTheta(i)) + sind(trailsTheta(i)));
    end
end