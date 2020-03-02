%%
% This function synthesizes electric and magnetic fields provided complex mode coefficients such that:
%
%   Prad = 1/2*sum(abs(Q(:)).^2).
%
% Inputs:
%   theta: observation theta in radians.
%   phi: observation phi in radians.
%   k: wave number in radians/meter.
%   r: radius of observation sphere in meters.
%   Q: [I x 1] complex mode coefficients. order should be as described in Spherical Near-field Antenna Measurements, single index.
%   wtype: [optional] type of wave function used. default 'K'.
%           'F': spherical wave vector. may give r component.
%           'K': far-field wave vector. TEM mode.
%   eta: [optional] wave impedance of medium. default 120*pi ohms.
% Outputs:
%   E: electric field.
%    .Theta [rad]
%    .Phi [rad]
%    .Erho [V/m]
%    .Etheta [V/m]
%    .Ephi [V/m]
%    .k [rad/m]
%    .r [m]
%    .eta [ohms]
%   H: magnetic field.
%    .Theta [rad]
%    .Phi [rad]
%    .Hrho [A/m]
%    .Htheta [A/m]
%    .Hphi [A/m]
%    .k [rad/m]
%    .r [m]
%    .eta [ohms]
%
function [E, H] = synthFields(theta, phi, k, r, Q, wtype, eta)
    % Input handling
    if (~exist('wtype', 'var')), wtype = 'K'; end
    if (~exist('eta', 'var')), eta = 120*pi; end
    
    % Number of entries
    TP = {numel(phi) numel(theta)};
    
    % Calculate spherical wave functions
    T = cell(size(Q));
    for (ii = 1:numel(Q))
        % Decompose single index into smn
        s = mod(ii+1, 2)+1;
        n = floor(sqrt((ii-s)/2+1));
        m = (ii-s)/2 + 1 - n*(n+1);
        
        switch (upper(wtype))
            case 'K'
                T(ii) = {calcK(s, m, n, theta, phi)};
            case 'F'
                T(ii) = {calcF(4, s, m, n, k, r, theta, phi)};
        end
    end
    
    % Swap s=1 and s=2 for H calculation
    T_E = T;
    T_H = horzcat(T(2:2:end), T(1:2:end-1))';
    T_H = T_H(:);
    
    % Synthesize fields
    switch (upper(wtype))
        % Far-field vector
        case 'K'
            const = sqrt(eta/4/pi)*exp(-1j*k*r)/r;
            Eth = zeros(TP{:});
            Eph = zeros(TP{:});
            for (nn = 1:numel(T_E))
                Eth = Eth + Q(nn)*T_E{nn}.Ktheta;
                Eph = Eph + Q(nn)*T_E{nn}.Kphi;
            end
            Eth = const*Eth;
            Eph = const*Eph;
            E = struct('Theta', theta, ...
                       'Phi', phi, ...
                       'Etheta', Eth, ...
                       'Ephi', Eph, ...
                       'k', k, ...
                       'r', r, ...
                       'eta', eta ...
                      );
                  
            % Calculate H field through the curl of E
            H = calcHfromE(E, eta);
            
        % Spherical wave vector
        case 'F'
            % E field
            constE = k*sqrt(eta);
            Erh = zeros(TP{:});
            Eth = zeros(TP{:});
            Eph = zeros(TP{:});
            for (nn = 1:numel(T_E))
                Erh = Erh + Q(nn)*T_E{nn}.Frho;
                Eth = Eth + Q(nn)*T_E{nn}.Ftheta;
                Eph = Eph + Q(nn)*T_E{nn}.Fphi;
            end
            Erh = constE*Erh;
            Eth = constE*Eth;
            Eph = constE*Eph;
            E = struct('Theta', theta, ...
                       'Phi', phi, ...
                       'Erho', Erh, ...
                       'Etheta', Eth, ...
                       'Ephi', Eph, ...
                       'k', k, ...
                       'r', r, ...
                       'eta', eta ...
                      );
            
            % H field
            constH = -1j*k/sqrt(eta);
            Hrh = zeros(TP{:});
            Hth = zeros(TP{:});
            Hph = zeros(TP{:});
            for (nn = 1:numel(T_H))
                Hrh = Hrh + Q(nn)*T_H{nn}.Frho;
                Hth = Hth + Q(nn)*T_H{nn}.Ftheta;
                Hph = Hph + Q(nn)*T_H{nn}.Fphi;
            end
            Hrh = constH*Hrh;
            Hth = constH*Hth;
            Hph = constH*Hph;
            H = struct('Theta', theta, ...
                       'Phi', phi, ...
                       'Hrho', Hrh, ...
                       'Htheta', Hth, ...
                       'Hphi', Hph, ...
                       'k', k, ...
                       'r', r, ...
                       'eta', eta ...
                      );
    end
end