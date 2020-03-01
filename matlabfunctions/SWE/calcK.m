%% This function calculates the far-field pattern vector, K, as described in Spherical Near-field Antenna Measurements
%
% Inputs:
%   s: s index
%   m: m index
%   n: n index
%   theta: theta observation points in radians
%   phi: phi observation points in radians
% Outputs:
%   K: K vector at theta and phi points
%
function K = calcK(s, m, n, theta, phi)
    % Meshgrid
    [th, ph] = meshgrid(theta, phi);
    
    % Calculate P1 (jm*Pbar(cos(theta))) / sin(theta) and P2 (dP(cos(theta))) / d-theta)
    [~, P1, P2] = calcPbar(n, m, th);
    
    % Calculate K
    K.Theta = reshape(theta, 1, []);
    K.Phi = reshape(phi, [], 1);
    if (s == 1)
        if (abs(m) < eps(0))
            K1const = sqrt(2/n/(n+1)) * exp(1j*m*ph) * (-1j)^(n+1);
        else
            K1const = sqrt(2/n/(n+1)) * (-m/abs(m))^m * exp(1j*m*ph) * (-1j)^(n+1);
        end
        Kth = K1const .* 1j.*P1;
        Kph = -K1const .* P2;
    elseif (s == 2)
        if (abs(m) < eps(0))
            K2const = sqrt(2/n/(n+1)) * exp(1j*m*ph) * (-1j)^(n);
        else
            K2const = sqrt(2/n/(n+1)) * (-m/abs(m))^m * exp(1j*m*ph) * (-1j)^(n);
        end
        Kth = K2const .* P2;
        Kph = K2const .* 1j.*P1;
    end
    
    % Return
    K.Ktheta = Kth;
    K.Kphi = Kph;
end