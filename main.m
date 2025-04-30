clc; clear; close all;
%% Inputs
load(fullfile('data', 'data.mat'));
initialDate = datetime(2007, 9, 1, 10, 12, 28); % Yr, Mon, Day, Hr, Min, Sec
flightTime = duration(3.4*365*24, 0, 0); % Hr, Min, Sec

% Initial and final positions
[Rearth0, Vearth0] = propagate(earth, initialDate);

% Final date
finalDate = initialDate + flightTime;

[Rceres1, Vceres1] = propagate(ceres, finalDate);
[Rearth1, Vearth1] = propagate(earth, finalDate);

% Spacecraft orbital elements
Vi = lambert(Rearth0, Rceres1, flightTime, earth.mu);
spacecraft = getElements(Rearth0, Vi(:,1), initialDate, earth.mu);
spacecraft.name = 'Spacecraft';

% Propagate and test final position
[Rspacecraft1, Vspacecraft1] = propagate(spacecraft, finalDate);

% Figure
fig = plotOrbit([earth, ceres, spacecraft], initialDate, finalDate, 2000);
figure(fig); hold on; view(-7, 20.5); fig.Position = [532 226 903 620];

