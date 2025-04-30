clear; close all;
%% Inputs
load(fullfile('data', 'data.mat'));
mu = G*Ms; % Gravitational for space craft
muE = G*(Ms + Me); % Gravitational parameter for Earth
muC = G*(Ms + Mc); % Gravitational parameter for Ceres

%ceres = mars;

% Perform the vector assignements
ndate = 1e2;
iDate = datetime(2025, 1, 1, 1, 0, 0);
fDate = datetime(2030, 1, 1, 1, 0, 0);
nflight = 1e3; % Number of flight time divisions
flightDays = linspace(100, 4*365, nflight); % Time of flight in days

%% Vector operations (Matrix dimenstion opereations)
% Initial date vector
initialDate = iDate+duration(linspace(0,hours(fDate-iDate),ndate),0,0);

% Final date
flightTime = duration(flightDays*24, 0, 0); % Hr, min, Sec

% Create the vectors
[flightTime, initialDate] = meshgrid(flightTime, initialDate);
flightTime = flightTime(:); initialDate = initialDate(:);
finalDate = initialDate + flightTime;
n = nflight*ndate;

%% Main calculations
% Initial and final positions
fprintf("Propagating "+earth.name+" initial positions.\n");
[Rearth0, Vearth0] = propagate(earth, initialDate, muE, true);

% Earth and ceres positions
fprintf("Propagating "+ceres.name+" final positions.\n");
[Rceres1, Vceres1] = propagate(ceres, finalDate, muC, true);

% Spacecraft orbital elements
fprintf("Calling Lambert solver.\n");
[V1, V2] = lambert(Rearth0, Rceres1, flightTime, mu);
mask3 = repmat(vecnorm(V1-Vearth0)<vecnorm(V2-Vearth0), 3, 1);
Vi = V1 .* mask3 + V2 .* ~mask3;
DV = vecnorm(Vi-Vearth0);

%% Solution for dt and initial date scans

[~, idx] = min(DV);
fprintf("Best initial date: %s\n", initialDate(idx));
fprintf("Best flight time: %5.1f days\n", days(flightTime(idx)));
fprintf("Best arraival date: %s\n", finalDate(idx));
fprintf("Delta-V (W.R.T. Earth): %5.2f km/s\n", DV(idx));

% Spacecraft
spacecraft = getElements(Rearth0(:,idx), Vi(:,idx), initialDate(idx), mu);
spacecraft.name = "Spacecraft";

% Figure
fig = plotOrbit([earth, ceres, spacecraft], initialDate(idx), finalDate(idx), ...
    200, mu);
figure(fig); hold on; view(-7, 20.5); fig.Position = [532 226 903 620];
title("Optimal trajectory", Interpreter='latex', FontSize=17);

%% Save data
save('Results', 'finalDate', 'initialDate', 'Vi', 'ndate', 'nflight');