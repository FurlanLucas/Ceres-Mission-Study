function [R, V] = propagate(body, time)
    % Propagates the orbit of body to a time given by time, and returns the
    % position X and volocity V, i.e., gets the position and velocity of
    % body in the instant time. If time is a vector of instants, calculates
    % its position and velocity at each instant element.

    % Find 2D position (True anomaly in DEG)
    e = body.EC;
    a = body.A;
    tau = body.Tp;
    mu = body.mu;

    % Main
    p = a * (1 - e^2);                   % semi-latus rectum
    dt = seconds(time - tau);

    if (e<1) % Ellipse
        n = sqrt(mu/(a^3));
        M = n*dt;
        E = solveKepler(M, e);
        TA = 2*atand(sqrt((1+e)/(1-e))*tan(E/2));
    elseif (e>1) % Hiperbole
        Mh = ((e^2-1)^(3/2)) * (dt) * sqrt(mu/(p^3));
        H = solveKeplerHip(Mh, e);
        TA = 2*atand(sqrt((e+1)/(e-1))*tanh(H/2));
    elseif (e==1)
        Mp = sqrt(mu/p^3)*dt;
        TA = 2*atand((3*Mp + sqrt(1+9*Mp^2))^(1/3) - ...
            (3*Mp + sqrt(1+9*Mp^2))^(-1/3));
    end
    
    % Ajust true anomaly
    idx = TA < 0; 
    TA(idx) = TA(idx) + 360*floor(1-TA(idx)/360);    
    idx = TA >= 360;
    TA(idx) = TA(idx) - 360*floor(TA(idx)/360);

    % Compute the distance (r)
    r = p / (1 + e*cosd(TA));  % radius at true anomaly
    
    % Position in perifocal coordinates
    R = [r*cosd(TA); r*sind(TA); 0];
    
    % Velocity in perifocal coordinates
    V = sqrt(body.mu/p) * [-sind(TA); e + cosd(TA); 0];

    % Transformation matrix
    Cw = [cosd(body.W),  sind(body.W), 0 
          -sind(body.W), cosd(body.W), 0 
          0,             0,            1];

    Ci = [1, 0,             0
          0, cosd(body.IN),  sind(body.IN) 
          0, -sind(body.IN), cosd(body.IN)];

    CW = [cosd(body.OM),  sind(body.OM), 0 
          -sind(body.OM), cosd(body.OM), 0 
          0,             0,            1];

    tt = (Cw*Ci*CW)';
    % Changing coordenates
    R = tt*R;
    V = tt*V;
end

