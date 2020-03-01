%% This function calculates the electric field from magnetic field.
%
% Inputs:
%   H: magnetic field
%   eta: [optional] wave impedance of medium (default 120*pi)
% Outputs:
%   E: E vector at theta and phi points
%
function E = calcEfromH(H, eta)
    % Eta
    if (~exist('eta', 'var')), eta = 120*pi; end

    % Calculate
    E = struct('Theta', H.Theta, ...
               'Phi', H.Phi, ...
               'Etheta', eta*H.Hphi, ...
               'Ephi', eta*H.Htheta ...
              );
end