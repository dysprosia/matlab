%% T-*-his function calculates the spherical wave vector, F, as described in Spherical Near-field Antenna Measurements
%
% Inputs:
%   c: c index
%   s: s index
%   m: m index
%   n: n index
%   k: wave number in radians/m
%   r: radius of observation point in meters
%   theta: theta observation points in radians
%   phi: phi observation points in radians
% Outputs:
%   F: F vector at theta and phi points
%
function F = calcF(c, s, m, n, k, r, theta, phi)
    % Meshgrid
    [th, ph] = meshgrid(theta, phi);
    
    % z function
    switch (c)
        case 1, zcn = @(n, kr) sph_besselj(n, kr);
        case 2, zcn = @(n, kr) sph_bessely(n, kr);
        case 3, zcn = @(n, kr) sph_besselh(n, kr, 1);
        case 4, zcn = @(n, kr) sph_besselh(n, kr, 2);
    end
    
    % Calculate z and d/du{u*z(u)}
    z = zcn(n, k*r);
    d_z = -zcn(n+1, k*r) + n/k/r*zcn(n, k*r);
    d_uz = k*r*d_z + z;
    
    % Calculate P1 (jm*Pbar(cos(theta))) / sin(theta) and P2 (dP(cos(theta))) / d-theta)
    [P0, P1, P2] = calcPbar(n, m, th);
    
    % Calculate F
    F.Theta = reshape(theta, 1, []);
    F.Phi = reshape(phi, [], 1);
    if (abs(m) < eps(0))
        Fconst = 1/sqrt(2*pi)/sqrt(n*(n+1));
    else
        Fconst = 1/sqrt(2*pi)/sqrt(n*(n+1)) * (-m/abs(m))^m;
    end
    if (s == 1)
        Frho = zeros(size(th));
        Fth = Fconst * z .* 1j*P1 .* exp(1j*m*ph);
        Fph = Fconst * -z .* P2 .* exp(1j*m*ph);
    elseif (s == 2)
        Frho = -Fconst * n*(n+1)/k/r * z * P0 .* exp(1j*m*ph);
        Fth = -Fconst * 1/k/r * d_uz * P2 .* exp(1j*m*ph);
        Fph = -Fconst * 1/k/r * d_uz * 1j*P1 .* exp(1j*m*ph);
    end
    
    % Return
    F.Frho = Frho;
    F.Ftheta = Fth;
    F.Fphi = Fph;
end