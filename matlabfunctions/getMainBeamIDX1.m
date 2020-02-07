%% This function gets indices of mainbea in one dimenson.
%
% Inputs:
%   th_deg: theta in degrees.
%   pat: pattern magnitude or dB (magnitude works better).
%   steer_deg: expected mainbeam location.
% Outputs:
%   idx: indices of th_deg and pat corresponding to main beam.
%
function idx = getMainBeamIDX1(th_deg, pat, steer_deg)
    % Get 1st and 2nd derivative of pattern
    [th_d1, pat_d1] = numericDeriv1(th_deg, pat);
    
    % Find zeros of 1st derivative by finding sign flips
    th_d1_interp = linspace(min(th_d1), max(th_d1), 10001);
    pat_d1_interp = interp1(th_d1, pat_d1, th_d1_interp, 'spline');
    idx_neg = pat_d1_interp < -eps(0);
    idx_pos = pat_d1_interp > -eps(0);
    idx_zeros = find(diff(idx_neg) | diff(idx_pos));
    
    % Get idx of mainbeam based on steer_deg
    % Get idx of steer_deg
    idx_steer = interp1(th_d1_interp, 1:numel(th_d1_interp), steer_deg, 'linear');
    
    % Get distances from steer_deg to zeros
    dis = idx_zeros-idx_steer;
    
    % Remove minimum distance (actual steer angle)
    [~, idx_minmag] = min(abs(dis));
    dis(idx_minmag) = [];
    idx_zeros(idx_minmag) = [];
    
    % Get indices in dis where sign flips to get two zeros around steer angle
    idx_mb_lo_interp = idx_zeros(find(dis < -eps(0), 1, 'last'));
    idx_mb_hi_interp = idx_zeros(find(dis > -eps(0), 1, 'first'));
    if (isempty(idx_mb_lo_interp)), idx_mb_lo_interp = 1; end
    if (isempty(idx_mb_hi_interp)), idx_mb_hi_interp = numel(th_d1_interp); end
    th_mb_lo_interp = th_d1_interp(idx_mb_lo_interp);
    th_mb_hi_interp = th_d1_interp(idx_mb_hi_interp);
    
    % Translate to input th_deg incdices
    idx_mb_lo = interp1(th_deg, 1:numel(th_deg), th_mb_lo_interp, 'nearest');
    idx_mb_hi = interp1(th_deg, 1:numel(th_deg), th_mb_hi_interp, 'nearest');
    
    % Output
    idx = false(size(th_deg));
    idx(idx_mb_lo:idx_mb_hi) = true;
end