%% This function calculates spherical bessel function of the second kind.
%
% Inputs:
%   n: order
%   x: argument
% Outputs:
%   yn: value
%
function yn = sph_bessely(n, x)
    Yn = bessely(n+0.5, x);
    yn = sqrt(pi/2)*1./sqrt(x).*Yn;
    idx_zero = abs(x) < eps(0);
    if (mod(n, 2) == 1)
        yn(idx_zero) = -inf;
    else
        yn(idx_zero) = inf;
    end
end