function [body, T2] = getElements(R, V, t0, mu)
    % Get orbital elements from position and velocity vectors.
    arguments
        R (3,1) double
        V (3,1) double
        t0 (1,1) datetime
        mu (1,1) double
    end

    h = cross(R, V); ih = h/vecnorm(h);
    e = cross(V, h)/mu - R/vecnorm(R); 
    ecc = vecnorm(e); ie = e/ecc;
    a = 1/(2/vecnorm(R) - vecnorm(V)^2/mu);
    p = vecnorm(h)^2/mu;

    n = cross([0;0;1], h)/vecnorm(cross([0;0;1], h));
    P_vec = p*cross(h, e)/(vecnorm(h)*ecc);

    % Right ascention of ascending node
    OM = atan2(n(2),n(1)); OM = mod(OM, 2*pi);
    if (OM < 0); OM = OM + 2*pi; end

    % Inclination
    i = atan2(h(1)/sin(OM), h(3)); i = mod(i, 2*pi);
    %if (i < 0); i = i + 2*pi; end
    if (i<0)
        i = 2*pi-i; n = -n;
        OM = atan2(n(2),n(1)); OM = mod(OM, 2*pi);
        if (OM < 0); OM = OM + 2*pi; end
    end

    % Periapsis argument
    w = atan2(dot(ih, cross(n, ie)), dot(ie, n)); w = mod(w, 2*pi);
    if (w < 0); w = w + 2*pi; end
    
    % True anomaly
    TA = atan2(dot(R,P_vec)/(vecnorm(R)*p), ...
        (p-vecnorm(R))/(ecc*vecnorm(R)));
    if (TA < 0); TA = TA + 2*pi; end

    if (ecc-1<1e-7) % Ellipse
        E0 = 2*atan(sqrt((1-ecc)/(1+ecc))*tan(TA/2));
        n = sqrt(mu/(a^3));
        Tp = t0 - seconds((E0-ecc*sin(E0))/n);
        T2 = (E0-ecc*sin(E0))/n;
    elseif(ecc-1>1e-6) % Hiperbole
        H0 = 2*atanh(sqrt((ecc-1)/(ecc+1))*tan(TA/2));
        num = ecc*sinh(H0) - H0;
        den = ((ecc^2-1)^(3/2))*sqrt(mu/(p^3));
        Tp = t0 - seconds(num/den);
        T2 = num/den;
    else % Parabole
        Tp = t0 - seconds(((1/6)*tan(TA/2)^3 + tan(TA/2)/2)/sqrt(mu/(p^3)));
        T2 = ((1/6)*tan(TA/2)^3 + tan(TA/2)/2)/sqrt(mu/(p^3));
    end

    body = struct('A', a, 'IN', rad2deg(i), 'EC', norm(e), ...
        'OM', rad2deg(OM), 'W', rad2deg(w), 'Tp', Tp, 'mu', mu);

end