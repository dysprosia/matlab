%% This function calculates the directivity of a spherical mode.
%
% Inputs:
%   s: s index
%   m: m index
%   n: n index
%   k: wave number in radians/m
%   r: radial distance in meters
%   theta: theta observation points in radians
%   phi: phi observation points in radians
%   eta: [optional] wave impedance of medium (default 120pi for free space)
% Outputs:
%   D: directivity
%
function D = calcD_sphmode(s, m, n, k, r, theta, phi, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end
    
    % Calculate E in the far-field
    E = calcE_FF_sphmode(s, m, n, k, r, theta, phi, eta);

    % Calculate directivity
    D = struct('Theta', E.Theta, ...
               'Phi', E.Phi, ...
               'Dtheta', 1/2/eta * r^2 * abs(E.Etheta).^2 * 4*pi * 2, ...
               'Dphi', 1/2/eta * r^2 * abs(E.Ephi).^2 * 4*pi * 2, ...
               'Dtotal', 1/2/eta * r^2 * abs(E.Etheta+E.Ephi).^2 * 4*pi * 2 ...
              );
end