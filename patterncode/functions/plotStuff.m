function figs = plotStuff(user_inputs, array)
    %% Setup
    UU = array.patterns.U;
    VV = array.patterns.V;
    U = unique(UU);
    V = unique(VV);
    pat_ele = reshape(array.patterns.element, numel(V), numel(U));
    pat_arr = reshape(array.patterns.array, numel(V), numel(U));
    pat_SA = reshape(array.patterns.subarray, numel(V), numel(U));
    pat_tot = reshape(array.patterns.total, numel(V), numel(U));
    idx_fh = sqrt(UU.^2+VV.^2)-1 < eps(0);
    pat_ele(~idx_fh) = nan;
    pat_arr(~idx_fh) = nan;
    pat_SA(~idx_fh) = nan;
    pat_tot(~idx_fh) = nan;
    % Convert steer angle to UV
    switch (upper(user_inputs.steer_angle.CS))
        case 'UV'
            u = user_inputs.steer_angle.dim1;
            v = user_inputs.steer_angle.dim2;
        case 'PHITHETA'
            uv = phitheta2uv(vertcat(user_inputs.steer_angle.dim1, user_inputs.steer_angle.dim2));
            u = uv(1);
            v = uv(2);
        case 'AZEL'            
            uv = azel2uv(vertcat(user_inputs.steer_angle.dim1, user_inputs.steer_angle.dim2));
            u = uv(1);
            v = uv(2);
        otherwise
            error('Coordinate system of type ''%s'' not recoginzed!', user_inputs.steer_angle.CS);
    end
    figs = {};
    
    %% Array geometry
    if (user_inputs.plots.geometry)
    end
    
    %% Array weights
    if (user_inputs.plots.weights)
    end
    
    %% Element factor
    if (user_inputs.plots.element_factor)
        fig = figure(); hold('on'); grid('on');
        plotPattern(UU, VV, pat_ele, 'norm', true, 'scale', 50, 'shading', 'interp', 'func', 'surf', 'unit', true);
        axis('equal');
        axis([-1 1 -1 1]);
        xticks(-1:0.25:1);
        yticks(-1:0.25:1);
        xlabel('U');
        ylabel('Y');
        title('Element factor (dB)');
        figs(numel(figs)+1) = {fig};
    end
    
    %% Array factor
    if (user_inputs.plots.array_factor)
        fig = figure(); hold('on'); grid('on');
        plotPattern(UU, VV, pat_arr, 'norm', true, 'scale', 50, 'shading', 'interp', 'func', 'surf', 'unit', true);
        axis('equal');
        axis([-1 1 -1 1]);
        xticks(-1:0.25:1);
        yticks(-1:0.25:1);
        xlabel('U');
        ylabel('Y');
        title('Array factor (dB)');
        figs(numel(figs)+1) = {fig};
    end
    
    %% Sub-array factor
    if (user_inputs.plots.SA_factor)
        fig = figure(); hold('on'); grid('on');
        plotPattern(UU, VV, pat_SA, 'norm', true, 'scale', 50, 'shading', 'interp', 'func', 'surf', 'unit', true);
        axis('equal');
        axis([-1 1 -1 1]);
        xticks(-1:0.25:1);
        yticks(-1:0.25:1);
        xlabel('U');
        ylabel('Y');
        title('Sub-array factor (dB)');
        figs(numel(figs)+1) = {fig};
    end
    
    %% Total pattern
    if (user_inputs.plots.total_pattern)
        fig = figure(); hold('on'); grid('on');
        plotPattern(UU, VV, pat_tot, 'norm', true, 'scale', 50, 'shading', 'interp', 'func', 'surf', 'unit', true);
        axis('equal');
        axis([-1 1 -1 1]);
        xticks(-1:0.25:1);
        yticks(-1:0.25:1);
        xlabel('U');
        ylabel('Y');
        title('Total pattern (dB)');
        figs(numel(figs)+1) = {fig};
    end
    
    %% Pattern cuts
    if (user_inputs.plots.cuts)
        % Get indices for cuts through peak
        [~, idx] = max(array.patterns.total);
        U_max = UU(idx);
        V_max = VV(idx);
        idx_Vcut = abs(UU-U_max) < eps(0);
        idx_Ucut = abs(VV-V_max) < eps(0);
        
        % U-cut
        figU = figure(); hold('on'); grid('on');
        plot(UU(idx_Ucut), 20*log10(abs(pat_ele(idx_Ucut))), '--k', 'linewidth', 1);
        plot(UU(idx_Ucut), 20*log10(abs(pat_arr(idx_Ucut))), '-b', 'linewidth', 1.5);
        plot(UU(idx_Ucut), 20*log10(abs(pat_SA(idx_Ucut))), '-r', 'linewidth', 1.5);
        plot(UU(idx_Ucut), 20*log10(abs(pat_tot(idx_Ucut))), '-k', 'linewidth', 3);
        plot([u u], [-1000 1000], '-k', 'linewidth', 1);
        axis([-1 1 -50 0]);
        xticks(-1:0.25:1);
        xlabel('U');
        ylabel('dB');
        title(sprintf('U-cut (V=%0.2f)', V_max));
        legend({'EF', 'AF', 'SAF', 'Total', 'Command steer'}, 'location', 'best');
        
        % V-cut
        figV = figure(); hold('on'); grid('on');
        plot(VV(idx_Vcut), 20*log10(abs(pat_ele(idx_Vcut))), '--k', 'linewidth', 1);
        plot(VV(idx_Vcut), 20*log10(abs(pat_arr(idx_Vcut))), '-b', 'linewidth', 1.5);
        plot(VV(idx_Vcut), 20*log10(abs(pat_SA(idx_Vcut))), '-r', 'linewidth', 1.5);
        plot(VV(idx_Vcut), 20*log10(abs(pat_tot(idx_Vcut))), '-k', 'linewidth', 3);
        plot([v v], [-1000 1000], '-k', 'linewidth', 1);
        axis([-1 1 -50 0]);
        xticks(-1:0.25:1);
        xlabel('V');
        ylabel('dB');
        title(sprintf('V-cut (U=%0.2f)', U_max));
        legend({'EF', 'AF', 'SAF', 'Total', 'Command steer'}, 'location', 'best');
        
        % Store figures into output
        figs(numel(figs)+1) = {figU};
        figs(numel(figs)+1) = {figV};
    end
end