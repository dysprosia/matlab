%% This function calculates the magnetic field of a spherical mode.
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
%   H: H vector at theta and phi points
%
function H = calcH_FF_sphmode(s, m, n, k, r, theta, phi, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end

    % Calculate K vector field
    K = calcK(s, m, n, theta, phi);
    
    % Calculate E
    const = sqrt(2)*sqrt(1/eta/4/pi)*exp(-1j*k*r)/r;
    H = struct('Theta', K.Theta, ...
               'Phi', K.Phi, ...
               'Htheta', -const*K.Kphi, ...
               'Hphi', const*K.Ktheta ...
              );
end