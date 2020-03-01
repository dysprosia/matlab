%% This function calculates spherical bessel function of the third kind.
%
% Inputs:
%   n: order
%   x: argument
%   k: [optional] kind of hankel function (default 1)
% Outputs:
%   hn: value
%
function hn = sph_besselh(n, x, k)
    if (~exist('k', 'var')), k = 1; end
    if (k == 1)
        hn = sph_besselj(n, x) + 1j*sph_bessely(n, x);
    elseif (k == 2)
        hn = sph_besselj(n, x) - 1j*sph_bessely(n, x);
    end
end