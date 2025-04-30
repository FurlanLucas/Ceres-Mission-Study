clear; close all; clc;
%% GET FILE DATA AND CREATE A DATA .MAT OUTPUT FILE

G = 6.67430e-20; % [m³/kg s²] Gravitational constant
Ms = 1.98855e30; % [kg] Mass of Sun
Me = 5.97219e24; % [kg] Mass of Earth
Mc = 9.3839e20; % [kg] Mass of Ceres
muSun = 1.32712440018e11; % [km³/s²] Gravitational parameter for the sun

files = dir();

for i = 3:length(files)
    [~,name,ext] = fileparts(files(i).name);
    if any(strcmp(ext, {'.mat', '.m', '.asv'})); continue; end
    eval(name + "=struct('A',0,'IN',0,'EC',0,'OM',0,'W',0,'Tp',0);");

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
        eval(name + ".A = " + name + ".A + A/n;");
        eval(name + ".EC = " + name + ".EC + EC/n;");
        eval(name + ".IN = " + name + ".IN + IN/n;");
        eval(name + ".W = " + name + ".W + W/n;");
        eval(name + ".OM = " + name + ".OM + OM/n;");
        eval(name + ".Tp = " + name + ".Tp + Tp/n;");
    end

    %eval(name + ".mu = mu;");
    eval(name + ".Tp = datetime(" + name + ".Tp, 'convertfrom', " + ...
        "'juliandate');");
    eval(name + ".name = '" + upper(name(1)) + lower(name(2:end)) + "';");
    save("data", name, '-append');
end

save("data", 'G', 'Ms', 'Me', 'Mc', '-append');

clear;