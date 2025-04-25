clear; close all; clc;
%% GET FILE DATA AND CREATE A DATA .MAT OUTPUT FILE
files = dir();

for i = 3:length(files)
    [~,name,ext] = fileparts(files(i).name);
    if any(strcmp(ext, {'.mat', '.m'})); continue; end
    eval(name + "=struct('IN',0,'EC',0,'OM',0,'W',0,'A',0,'Tp',0);");

    lines = readlines(name);
    SOE = find(strcmp(lines, "$$SOE"), true) + 1; % Start of elements
    EOE = find(strcmp(lines, "$$EOE"), true); % End of elements
    n = (EOE - SOE)/5;

    for j = 1:n
        for k = 1:4
            tokens = regexp(lines{SOE + (j-1)*5 + k}, ...
                '(\w+)\s*=\s*([-\d.Ee+]+)', 'tokens');
            for l = 1:length(tokens)
                eval(tokens{l}{1} + "=" + tokens{l}{2} + ";");
            end
        end
        eval(name + ".IN = " + name + ".IN + IN/n;");
        eval(name + ".EC = " + name + ".EC + EC/n;");
        eval(name + ".OM = " + name + ".OM + OM/n;");
        eval(name + ".W = " + name + ".W + W/n;");
        eval(name + ".A = " + name + ".A + A/n;");
        eval(name + ".Tp = " + name + ".Tp + Tp/n;");
    end

    save("data", name, '-append');
end

%% Other paramaters
mu = 1.32712440018e11; % [km³/s²] Gravitational parameter for the sun
save("data", mu, '-append');

clear;