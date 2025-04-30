function [DV, spacecraft] = findMinDvByTime(earth, ceres, initialDate, ...
    dt, mu, muE, muC)
    % Find the minimum Delta-V value for Earth-Ceres transfer orbit, givin
    % a initial time from departing Earth and a range of flight times.
    %
    % INPUTS
    %   earth: body struct with orbital elements;
    %   ceres: body struct with orbital elements;
    %   initialDate: 
    %
    % OUTPUTS
    %% Inputs

    % Create the vectors
    finalDate = initialDate + dt;
    n = length(dt);
    
    %% Main calculations
    % Initial and final positions
    %fprintf("Propagating Earth initial positions.\n");
    [Rearth0, Vearth0] = propagate(earth, initialDate, muE);
    Rearth = 

    % Earth and ceres positions
    %fprintf("Propagating Ceres final positions.\n");
    [Rceres1, ~] = propagate(ceres, finalDate, muC);
    %fprintf("Propagating Earth final positions.\n");
    %[Rearth1, ~] = propagate(earth, finalDate, muE);
    
    % Spacecraft orbital elements
    [V1, V2] = lambert(Rearth0, Rceres1, flightTime, mu);
    mask3 = repmat(vecnorm(V1-Vearth0)<vecnorm(V2-Vearth0), 3, 1);
    Vi = V1 .* mask3 + V2 .* ~mask3;
    DV = vecnorm(Vi-Vearth0);
    
    % Figure
    plot(hours(flightTime)/(24*365), DV);
    grid minor;
    xlabel("Time (anos)", Interpreter='latex', FontSize=17);
    ylabel("DV (km/s)", Interpreter='latex', FontSize=17);

