%% This function calculates the magnetic field from electric field.
%
% Inputs:
%   E: electric field
%   eta: [optional] wave impedance of medium (default 120*pi)
% Outputs:
%   H: H vector at theta and phi points
%
function H = calcHfromE(E, eta)
    % Do k, r, eta exist in E?
    fns = fieldnames(E);

    % Eta
    if (~exist('eta', 'var') && ~ismember('eta', fns)), eta = 120*pi;
    elseif (ismember('eta', fns)), eta = E.eta;
    end

    % Calculate
    H = struct('Theta', E.Theta, ...
               'Phi', E.Phi, ...
               'Htheta', -1/eta*E.Ephi, ...
               'Hphi', 1/eta*E.Etheta ...
              );
	if (ismember('k', fns)), H.k = E.k; end
    if (ismember('r', fns)), H.r = E.r; end
    H.eta = eta;
end