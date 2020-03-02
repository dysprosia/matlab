%%
% This function numerically integrates give data in 2 dimensions using trapezoidal rule. Requires uniform sampling.
%
% Inputs:
%   x: [1 x N] horizontal axis.
%   y: [M x 1] vertical axis.
%   z: [M x N] values to integrate.
% Outputs:
%   Q: numeric integration result.
%
function Q = numericIntegrate2(x, y, z)
    % unique x and y
    x = unique(x);
    y = unique(y);
    
    % h
    hx = mean(diff(x));
    hy = mean(diff(y));
    
    % weighting
    w = ones(size(z));
    w(2:end-1, 1:end) = 2 * w(2:end-1, 1:end);
    w(1:end, 2:end-1) = 2 * w(1:end, 2:end-1);
    
    % Q
    Q = 1/4*hx*hy * sum(w(:) .* z(:));
end