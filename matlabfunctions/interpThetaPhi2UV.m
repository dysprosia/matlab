%%
% This function interpolates Theta-phi field data to UV. Assumes forward hemisphere defined normal to Z-axis (abs(theta) <= 90).
%
% Inputs:
%   th: theta in degrees.
%   ph: phi in degrees.
%   in: field in complex.
%   method: interpolation method (none, complex, mag, dB). default: none.
% Outputs:
%   U: u in sines.
%   V: v in sines.
%   out: field data. format specified by method.
%
function [U, V, out] = interpThetaPhi2UV(th, ph, in, method)
    %% Input handling
    if (nargin<4)
        method = 'none';
    end
    switch (upper(method))
        case 'COMPLEX'
        case 'NONE'
            in = in;
        case 'MAG'
            in = abs(in);
        case 'DB'
            in = 20*log10(abs(in));
    end
    
    %% Keep forward hemisphere only
    % Only keep forward hemisphere
    idx_fh = 90-abs(th) > -eps(0);
    ph = ph(idx_fh);
    th = th(idx_fh);
    in = in(idx_fh);
    
    % Reshape into grid
    ph = reshape(ph, numel(unique(th)), numel(unique(ph)));
    th = reshape(th, numel(unique(th)), numel(unique(ph)));
    in = reshape(in, numel(unique(th)), numel(unique(ph)));
    
    %% UV
    u = linspace(-1, 1, 101);
    v = linspace(-1, 1, 101);
    [UU, VV] = meshgrid(u, v);
    U = UU(:);
    V = VV(:);
    
    % Only keep real-space
    idx_keep = 1-sqrt(U.^2 + V.^2) > -eps(0);
    U = U(idx_keep);
    V = V(idx_keep);
    
    % Convert to phi theta
    pt = uv2phitheta(vertcat(reshape(U, 1, []), reshape(V, 1, [])));
    ph2 = pt(1, :);
    th2 = pt(2, :);
    
    % Add 360 to phi values less than 0
    idx_ph2neg = ph2 < -eps(0);
    ph2(idx_ph2neg) = ph2(idx_ph2neg) + 360;
    
    %% Interpolate
    out = interp2(ph, th, in, ph2, th2, 'spline');
end