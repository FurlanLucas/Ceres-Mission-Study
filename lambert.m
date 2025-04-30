function v1 = lambert(r1, r2, dt, mu)
    % Function to solve for the lambert problem. For each value of R1 and
    % R2 (space positions), find a orbit that passes thought both points
    % with a flight time of dt.
    %
    % INPUTS
    %   r1 (3xn vector): Matrix of n R1 positions to be analysed in km;
    %   r2 (3xn vector): Matrix of n R2 positions to be analysed in km;
    %   dt (1xn vector): Vector of n flight times in s; 
    %   mu (1xn vector): Vector of n gravitational parameters in km³/s²;
    %
    % OUTPUTS
    %   v1 (3xn vector): Vector of velocity solutions for the point R1;

    arguments
        r1 (3,:) double
        r2 (3,:) double
        dt (1,:) duration
        mu (1,:) double
    end

    %% Main
    input_filename = fullfile("lambert", "lambert_input.dat");
    output_file = fullfile("lambert", "lambert_output.dat");

    % Write the input files
    file_id = fopen(input_filename, 'w');
    for i = 1:length(dt)
        fprintf(file_id, "%.15e, %.15e, %.15e, %.15e, %.15e, %.15e, " + ...
            "%.15e, %.9e\n", r1(:,i), r2(:,i), seconds(dt(i)), mu);
    end
    fclose(file_id);

    % Solve the Lambert problem
    !lambert\lambert_solver.exe

    % Take the output results
    v1 = importdata(output_file)';
end
