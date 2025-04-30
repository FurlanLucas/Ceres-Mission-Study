function H = solveKeplerHip(Mh, e)
    % Solves Kepler's Equation: E - e*sin(E) = M for each value of mean
    % anomaly in the vector M
    %
    % INPUTS
    %   M (1 x n or n x 1): Mean anomaly (DEG);
    %   e (scalar): Eccentricity;
    %
    % OUTPUTS
    %   E (1 x n): Eccentric anomaly (deg);

    arguments
        Mh (:,1) double
        e (1,1) double
    end

    %% Main part

    % Tolerance and max iterations
    tol = 1e-16;
    maxIter = 300;

    % Initial guess
    if e < 0.8
        H = Mh;
    else
        H = pi;
    end

    % Newton-Raphson iteration
    for k = 1:maxIter
        f = e*sinh(H) - H - Mh;
        fp = 1 - e*cos(H);
        dH = -f ./ fp;
        H = H + dH;

        if max(abs(dH)) < tol
            break;
        end
    end
end