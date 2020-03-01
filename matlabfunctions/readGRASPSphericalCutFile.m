%% This function reads GRASP spherical cut file.
%
% Inputs:
%   icut: filepath to cut file.
% Outputs:
%   out: data structure.
%
function out = readGRASPSphericalCutFile(icut)
    %% Read in file
    fid = fopen(icut, 'r');
    txt = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);
    txt = vertcat(txt{:});
    
    %% Convert to numeric
    % Split on space
    dat = cell(size(txt));
    for (nn = 1:numel(txt)), dat(nn) = {strsplit(txt{nn}, '\s', 'delimitertype', 'regularexpression')}; end
    
    % Convert to numeric
    for (nn = 1:numel(dat)), dat(nn) = {str2double(dat{nn})}; end
    
    %% Split into individual cuts by nan rows (characters)
    % Get indices of nan rows
    idx_nan = false(size(dat));
    for (nn = 1:numel(dat)), idx_nan(nn) = all(isnan(dat{nn})); end
    idx_nan = find(idx_nan);
    
    % Split on nan rows
    cuts = cell(numel(idx_nan), 1);
    for (nn = 1:numel(idx_nan)-1), cuts(nn) = {dat(idx_nan(nn)+1:idx_nan(nn+1)-1)}; end
    cuts(end) = {dat(idx_nan(end)+1:end)};
    
    %% Process cuts
    data = cell(size(cuts));
    for (nn = 1:numel(cuts)), data(nn) = {processCut(cuts{nn})}; end
    data = vertcat(data{:});
    
    %% Concatenate cuts if sweep values are the same
    % Check sweep values are the same
    ctrl_1 = data(1).control(1:3);
    nn = 1;
    bool_match = true;
    while (bool_match && nn <= max(size(data)))
        bool_match = isequal(ctrl_1, data(nn).control(1:3));
        nn = nn+1;
    end
    
    % If the same, concatenate where inner loop variable is columns and outer loop variable is rows
    if (bool_match)
        out.control = cat(2, data(1).control(1:3), nan, data(1).control(5:end));
        fns = fieldnames(data);
        fns = fns(~ismember(fns, {'control', 'Theta', 'Phi'}));
        if (numel(data(1).Phi) == 1)
            ph = cat(1, data.Phi);
            out.Theta = transpose(data(1).Theta);
            out.Phi = ph;
        elseif (numel(data(1).Theta) == 1)
            th = cat(1, data.Phi);
            out.Phi = transpose(data(1).Theta);
            out.Theta = th;
        end
        for (nn = 1:numel(fns))
            fn = fns{nn};
            out.(fn) = transpose(cat(2, data.(fn)));
        end
    else
        out = data;
    end
end

%% User functions
function out = processCut(in)
    %% Split into control values and data values
    ctrl = in{1};
    data = cat(1, in{2:end});
    
    %% Split control values
    v_ini = ctrl(1);
    v_inc = ctrl(2);
    v_num = ctrl(3);
    const = ctrl(4);
    icomp = ctrl(5);
    icut  = ctrl(6);
    ncomp = ctrl(7);
    
    %% Parse data
    x = v_ini:v_inc:(v_num*v_inc-v_inc);
    E1 = complex(data(:, 1), data(:, 2));
    E2 = complex(data(:, 3), data(:, 4));
    if (ncomp == 3), E3 = complex(data(:, 5), data(:, 6)); end
    
    %% Stuff
    % Independent parameter names
    if (icut == 1)
        x_nm = 'Theta';
        y_nm = 'Phi';
    elseif (icut == 2)
        x_nm = 'Phi';
        y_nm = 'Theta';
    end
    
    % Polarization switch
    switch (abs(icomp))
        case (1)
            E1_nm = 'Etheta';
            E2_nm = 'Ephi';
            E3_nm = 'Erho';
        case (2)
            E1_nm = 'ERHC';
            E2_nm = 'ELHC';
            E3_nm = 'Erho';
        case (3)
            E1_nm = 'Eco';
            E2_nm = 'Ecross';
            E3_nm = 'Erho';
        case (4)
            E1_nm = 'Emajor';
            E2_nm = 'Eminor';
            E3_nm = 'Erho';
            E1 = real(E1);
            E2 = real(E2);
        case (5)
            E1_nm = 'XPD_theta_over_phi';
            E2_nm = 'XPD_phi_over_theta';
            E3_nm = 'Erho';
        case (6)
            E1_nm = 'XPD_RHC_over_LHC';
            E2_nm = 'XPD_LHC_over_RHC';
            E3_nm = 'Erho';
        case (7)
            E1_nm = 'XPD_co_over_cross';
            E2_nm = 'XPD_cross_over_co';
            E3_nm = 'Erho';
        case (8)
            E1_nm = 'XPD_major_over_minor';
            E2_nm = 'XPD_minor_over_major';
            E3_nm = 'Erho';
            E1 = real(E1);
            E2 = real(E2);
        case (9)
            E1_nm = 'Power';
            E2_nm = 'Complex_sqrt_RHC_over_LHC';
            E3_nm = 'Erho';
            E1 = real(E1);
    end
    
    % Store
    out = struct('control', ctrl, ...
                 x_nm, {reshape(x, [], 1)}, ...
                 y_nm, const, ...
                 E1_nm, E1, ...
                 E2_nm, E2 ...
                );
    if (ncomp == 3), out.(E3_nm) = E3; end
end
