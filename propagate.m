function [R, V] = propagate(body, time, mu, print)
    % Propagates the orbit of body to each time given in the vector time.

    % Inputs
    if nargin==3
        print = false;
    end
    n = length(time);
    R = zeros([3,n]);
    V = zeros([3,n]);

    % Main
    if print; fprintf("\tProgress:         "); end
    
    counter = 0;
    for i = 1:n
        [R(:,i), V(:,i)] = propagate_one(body, time(i), mu);

        if (mod(i,1e3)==counter) && print
            fprintf(repmat('\b',[1,8])+"%6.2f %%", (i-1)*100/(n-1));
        end
    end
    if print; fprintf("\n"); end
end

