function [R, V] = propagate(body, time, mu)
    % Propagates the orbit of body to each time given in the vector time.

    n = length(time);
    R = zeros([3,n]);
    V = zeros([3,n]);

    for i = 1:n
        [R(:,i), V(:,i)] = propagate_one(body, time(i), mu);
    end
end

