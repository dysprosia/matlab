%% This function calculates the magnetic field from electric field.
%
% Inputs:
%   E: electric field
%   eta: [optional] wave impedance of medium (default 120*pi)
% Outputs:
%   H: H vector at theta and phi points
%
function H = calcHfromE(E, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end

    % Calculate
    H = struct('Theta', E.Theta, ...
               'Phi', E.Phi, ...
               'Htheta', -1/eta*E.Ephi, ...
               'Hphi', 1/eta*E.Etheta ...
              );
end