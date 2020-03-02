%% This function calculates the electric field of a spherical mode in the far-field.
% Fields are normalized to represent 1 W of radiated power.
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
%   E: E vector at theta and phi points
%
function E = calcE_FF_sphmode(s, m, n, k, r, theta, phi, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end

    % Calculate K vector field
    K = calcK(s, m, n, theta, phi);
    
    % Calculate E
    const = sqrt(2)*sqrt(eta/4/pi)*exp(-1j*k*r)/r;
    E = struct('Theta', K.Theta, ...
               'Phi', K.Phi, ...
               'Etheta', const*K.Ktheta, ...
               'Ephi', const*K.Kphi, ...
               'k', k, ...
               'r', r, ...
               'eta', eta ...
              );
end