%% This function calculates spherical bessel function of the first kind.
%
% Inputs:
%   n: order
%   x: argument
% Outputs:
%   jn: value
%
function jn = sph_besselj(n, x)
    Jn = besselj(n+0.5, x);
    jn = sqrt(pi/2)*1./sqrt(x).*Jn;
    idx_zero = abs(x) < eps(0);
    jn(idx_zero) = 0;
end