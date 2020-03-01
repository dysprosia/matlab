%% 
% This function calculates the electric and magnetic field of a spherical mode in the near-field.
% Fields are normalized to represent 1 W of radiated power.
%
% Inputs:
%   c: c index
%   s: s index
%   m: m index
%   n: n index
%   k: wave number in radians/m
%   r: radial distance in meters
%   theta: theta observation points in radians
%   phi: phi observation points in radians
%   eta: [optional] wave impedance of medium (default 120pi for free space)
% Outputs:
%   E: E vector at theta and phi points for given rho
%   H: H vector at theta and phi points for given rho
%
function [E, H] = calcEH_NF_sphmode(c, s, m, n, k, r, theta, phi, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end

    % Calculate F vector field
    FE = calcF(c, s, m, n, k, r, theta, phi);
    FH = calcF(c, 3-s, m, n, k, r, theta, phi);
    
    % Calculate E
    const = k*sqrt(eta)*sqrt(2);
    E = struct('Theta', FE.Theta, ...
               'Phi', FE.Phi, ...
               'Erho', const*FE.Frho, ...
               'Etheta', const*FE.Ftheta, ...
               'Ephi', const*FE.Fphi ...
              );
    
    % Calculate H
    const = -1j*k/sqrt(eta)*sqrt(2);
    H = struct('Theta', FH.Theta, ...
               'Phi', FH.Phi, ...
               'Hrho', const*FH.Frho, ...
               'Htheta', const*FH.Ftheta, ...
               'Hphi', const*FH.Fphi ...
              );
end