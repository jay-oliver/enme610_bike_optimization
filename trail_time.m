%Finds the time taken on each section of trail, given a desired velocity
function time = trails_time(trail, velocity)
%TRAILS_T trail is a struct entry from trailsX, velocity is in m/s
    time = [trails(1)/velocity trails(2)/velocity trails(3)/velocity];
end

