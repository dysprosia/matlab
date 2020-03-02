%% This function calculates the electric field from magnetic field.
%
% Inputs:
%   H: magnetic field
%   eta: [optional] wave impedance of medium (default 120*pi)
% Outputs:
%   E: E vector at theta and phi points
%
function E = calcEfromH(H, eta)
    % Do k, r, eta exist in H?
    fns = fieldnames(H);

    % Eta
    if (~exist('eta', 'var') && ~ismember('eta', fns)), eta = 120*pi;
    elseif (ismember('eta', fns)), eta = H.eta;
    end

    % Calculate
    E = struct('Theta', H.Theta, ...
               'Phi', H.Phi, ...
               'Etheta', eta*H.Hphi, ...
               'Ephi', eta*H.Htheta ...
              );
	if (ismember('k', fns)), E.k = E.k; end
    if (ismember('r', fns)), E.r = E.r; end
    E.eta = eta;
end