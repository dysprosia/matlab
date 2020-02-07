%%
% This function calculates normalized finite dipole field pattern.
%
% Inputs:
%   l: length in lambda.
% Outputs:
%   th: theta from -180 to 180 in degrees.
%   pat: normalized dipole pattern.
%
function [th, pat] = calcFiniteDipolePattern(l)
    th = -180:1:180;
    k = 2*pi;
    kl = k*l;
%     Ef = (cos(kl/2*cos((th-90)*pi/180))-cos(kl/2)) ./ sin((th-90)*pi/180);
    Ef = (cos(kl/2*-sin(th*pi/180))-cos(kl/2)) ./ cos(th*pi/180);
    idx_zero = abs(sin((th-90)*pi/180)) < eps(0);
    Ef(idx_zero) = 0;
    idx_nan = isnan(Ef);
    Ef(idx_nan) = 0;
%     pat = Ef.^2;
    pat = Ef;
    pat = pat / max(pat);
end