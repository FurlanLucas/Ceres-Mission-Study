function fig = plotOrbit(bodies, ti, tf, nt, mu)
    % Plot the orbit in space of body, between the instants ti and tf,
    % dividing the time interval in nt points.

    %% Inputs
    sunColor = [1, 0.655, 0.243];
    sunColorEdge = [1, 0.867, 0.039];
    bodiesColor = ['b', 'm', 'g', 'k'];

    %% Main
    t = linspace(ti, tf, nt);

    % Figure (initial config)
    fig = figure;
    plot3(0, 0, 0, 'o', MarkerEdgeColor=sunColor, ...
        MarkerFaceColor=sunColorEdge, DisplayName='Sun'); hold on;

    for j = 1:length(bodies)
        pos = zeros(3, nt);
        for i = 1:nt
            pos(:,i) = propagate(bodies(j), t(i), mu);
        end
        plot3(pos(1,:)/1e6, pos(2,:)/1e6, pos(3,:)/1e6, bodiesColor(j), ...
            DisplayName=bodies(j).name);

        % Initial
        plot3(pos(1,1)/1e6, pos(2,1)/1e6, pos(3,1)/1e6, ...
            bodiesColor(j), MarkerFaceColor=bodiesColor(j), ...
            Marker='s', HandleVisibility='off');

        % Final
        plot3(pos(1,end)/1e6, pos(2,end)/1e6, pos(3,end)/1e6, ...
            bodiesColor(j), MarkerFaceColor=bodiesColor(j), ...
            Marker='o', HandleVisibility='off');
    end

    plot3(NaN, NaN, NaN, 'k', DisplayName='Initial position', ...
        Marker='s', MarkerFaceColor='k');
    plot3(NaN, NaN, NaN, 'k', DisplayName='Final position', Marker='o', ...
        MarkerFaceColor='k');
    
    % Figure (final config)
    hold off; axis equal; 
    legend(Location = 'North', Interpreter='latex', FontSize=17);
    xlabel('X position [$10^6$ km]', Interpreter='latex', FontSize=17);
    ylabel('Y position [$10^6$ km]', Interpreter='latex', FontSize=17);
    zlabel('Z position [$10^6$ km]', Interpreter='latex', FontSize=17);

end