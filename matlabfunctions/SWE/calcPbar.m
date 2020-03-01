%% This function gets Pbar. 
%
% Inputs:
%   n: n index
%   m: m index
%   th: theta in radians [0, 2pi]
% Outputs:
%   P0: Pbar as defined in Spherical Near-field Antenna Measurements
%   P1: m/sin(th)*Pbar(cos(th))
%   P2: d(Pbar(cos(th)))/d(th)
%
function [P0, P1, P2] = calcPbar(n, m, th)
    % Setup
    m = abs(m);
    Pnorm = sqrt((2*n+1)/2*factorial(n-m)/factorial(n+m));
    colons = repmat({':'},1,ndims(th));
    
    % P
    mm = (0:n)';
    fac = (-1).^mm;                 % (-1)^m to match with Hansen's definition
    P = fac .* legendre(n, cos(th));        
    
    % P
    P0 = squeeze(P(m+1, colons{:}));
    
    % m/sin(th)*P(cos(th))
    if (m < eps(0))
        P1 = zeros(size(th));
    else
        P1 = 1/2 * cos(th) .* ((n-m+1)*(n+m)*squeeze(P(m, colons{:}))) + m*sin(th).*squeeze(P(m+1, colons{:}));
        if (m < n), P1 = P1 + 1/2*cos(th).*squeeze(P(m+2, colons{:})); end
    end
    
    % d(P(cos(th)))/d(th)
    if (m < eps(0))
        P2 = -squeeze(P(2, colons{:}));
    else
        P2 = 1/2*(n-m+1)*(n+m)*squeeze(P(m, colons{:}));
        if (m < n), P2 = P2 - 1/2*squeeze(P(m+2, colons{:})); end
    end
    
    % Output
    P0 = Pnorm*P0;
    P1 = Pnorm*P1;
    P2 = Pnorm*P2;
end