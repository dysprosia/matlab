%%
% This function robustly plots patterns.
%
% Inputs:
%   X: x-coordinates.
%   Y: y-coordinates.
%   pat: complex pattern.
%   varagin:
%     scale: [numeric] scale to plot patterns over. nan lets matlab autoscale (default: nan).
%     norm/normalize: [boolean] to normalize or not normalize pattern to peak (default: false).
%     unit/unitcircle: [boolean] truncate data to unit circle (default: false).
%     thresh/threshold: [numeric] data below threshold value set to nan (default: -inf).
%     func/plotfunc: [string] plot function to use (surf, imagesc, trisurf, auto) (default: auto).
%     cmap/colormap: [string] colormap to use (default: jet).
%     shading: [string] shading style (interp, flat, etc.) (default: flat).
% Outputs:
%   h: plot handle.
%
function h = plotPattern(X, Y, pat, varargin)
    %% Process varargin
    % Format verification    
    if (mod(numel(varargin), 2) == 1), error('Odd number of varargin! Please enter varargin in Name-Value pairs.'); end
    
    % Separate into name and value lists
    names = varargin(1:2:end);
    vals = varargin(2:2:end);
    
    % Scale
    scale = nan;
    idx = ismember(upper(names), 'SCALE');
    if (sum(idx)), scale = vals{idx}; end
    
    % Normalize
    norm = false;
    idx = ismember(upper(names), 'NORM') | ismember(upper(names), 'NORMALIZE');
    if (sum(idx)), norm = vals{idx}; end
    
    % Unit-circle
    unitc = false;
    idx = ismember(upper(names), 'UNIT') | ismember(upper(names), 'UNITCIRCLE');
    if (sum(idx)), unitc = vals{idx}; end
    
    % Threshold
    thresh = -inf;
    idx = ismember(upper(names), 'THRESH') | ismember(upper(names), 'THRESHOLD');
    if (sum(idx)), thresh = vals{idx}; end
    
    % Plot function
    plotfunc = 'auto';
    idx = ismember(upper(names), 'FUNC') | ismember(upper(names), 'PLOTFUNC');
    if (sum(idx)), plotfunc = vals{idx}; end
    
    % Colormap
    cmap = 'jet';
    idx = ismember(upper(names), 'CMAP') | ismember(upper(names), 'COLORMAP');
    if (sum(idx)), cmap = vals{idx}; end
    
    % Shading
    shad = 'flat';
    idx = ismember(upper(names), 'SHADING');
    if (sum(idx)), shad = vals{idx}; end
    
    %% dims
    if (numel(X) ~= numel(pat)), [XX, YY] = meshgrid(X, Y);
    else, XX = X; YY = Y;
    end
    
    %% Complex handling (convert to dB)
    if (~isreal(pat)), pat = 20*log10(abs(pat)); end
    
    %% Normalize
    if (norm), pat = pat-max(pat(:)); end
    
    %% Threshhold
    pat = pat(:);
    pat_max = max(pat);
    pat(pat-thresh < -eps(0)) = nan;
    
    %% Unit-circle
    if (unitc)
        idx_keep = sqrt(XX.^2+YY.^2)-1 < eps(0);
        pat(~idx_keep) = nan;
    end
    
    %% Determine plot function (surf, imagesc, trisurf)
    switch (upper(plotfunc))
        case 'AUTO'
            X = unique(XX);
            Y = unique(YY);
            if (min(size(pat))==1), pat = reshape(pat, numel(Y), numel(X)); end
            func = @surf;
            iarg = {X, Y, pat};
        case 'SURF'
            X = unique(XX);
            Y = unique(YY);
            if (min(size(pat))==1), pat = reshape(pat, numel(Y), numel(X)); end
            func = @surf;
            iarg = {X, Y, pat};
        case 'IMAGESC'
            X = unique(XX);
            Y = unique(YY);
            if (min(size(pat))==1), pat = reshape(pat, numel(Y), numel(X)); end
            func = @imagesc;
            iarg = {X, Y, pat};
        case 'TRISURF'
            func = @trisurf;
            iarg = {delaunay(XX(:), YY(:)), XX(:), YY(:), pat};
        otherwise
            error('Unrecognized plot function: ''%s''!', plotfunc);
    end
    
    %% Plot
    h = func(iarg{:});
    set(gca,'YDir','normal')
    shading(shad);
    colormap(cmap);
    colorbar();
    try
        if (~isnan(scale)), caxis([pat_max-scale pat_max]); end
    catch
    end
    view(2);
end