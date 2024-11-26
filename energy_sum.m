%% Energy script 
% the energy is just power at each section integrated over time, with the
% offset from the trail added 
% the goal is to have total energy=0
function E_sum=energy_sum(trailsTheta,trailsX,v,gr,p,m)
    import power_total.*
    import trail_time.*
    E_sum=0;
    power=power_total(trailsTheta,v,gr,p,m);
    trail_offset=trail_energy(trailsX,trailsTheta,m,p,v);
    time=trail_time(trailsX,v);
    for i=1:length(trailsTheta)
        E_sum=E_sum+(power(i)*time(i))-trail_offset;
    end
end