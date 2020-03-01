%% This function calculates the fields of a Hertzian dipole for 1W of radiated power
%
% Inputs:
%   k: wave number in radians/m
%   r: radius of observation sphere in meters
%   theta: theta of observation sphere in radians
%   phi: phi of observation sphere in radians
%   eta: [optional] wave impedance of medium (default 120*pi)
%   Prad: [optional] radiated power (default 1 W)
% Outputs:
%   E: electric field
%   H: electric field
%
function [E, H] = calcHertzianEdipoleFields(k, r, theta, phi, eta, Prad)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end
    if (~exist('Prad', 'var')), Prad = 1; end
    
    % I0*l
    Il = 2/k*sqrt(Prad/40);            % Current amplitude times length to yield Prad W of time averatged radiated power
    
    % Meshgrid
    theta = reshape(theta, 1, []);
    phi = reshape(phi, [], 1);
    [th, ~] = meshgrid(theta, phi);
    
    % E fields
    E = struct('Theta', theta, ...
               'Phi', phi, ...
               'Erho', eta*Il*cos(th)/2/pi/r^2 * (1 + 1/1j/k/r) * exp(-1j*k*r), ...
               'Etheta', 1j*eta*k*Il*sin(th)/4/pi/r * (1 + 1/1j/k/r - 1/(k*r)^2) * exp(-1j*k*r), ...
               'Ephi', zeros(size(th)) ...
              );
          
    H = struct('Theta', theta, ...
               'Phi', phi, ...
               'Hrho', zeros(size(th)), ...
               'Htheta', zeros(size(th)), ...
               'Hphi', 1j*k*Il/4/pi/r*sin(th) * (1 + 1/1j/k/r) * exp(-1j*k*r) ...
              );
end