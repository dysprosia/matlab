%%
% This function performs spherical wave expansion on a given electric or magnetic field.
%
% Inputs:
%   C: field structure
%    .Theta: unique theta values in radians.
%    .Phi: unique phi values in radians.
%    .Crho: rho component of field where 'C' gives the type of field: E or H. if present,
%           uses spherical wave function with rho dependence (and thus rho component). 
%           otherwise, uses spherical far-field wave function (no rho dependence and component).
%    .Ctheta: theta component of field where 'C' gives the type of field: E or H.
%    .Cphi: phi component of field where 'C' gives the type of field: E or H.
%    .k: wave number in radians/meter.
%    .r: radius of observation sphere in meters.
%    .eta: wave impedance in ohms.
%   N: maximum number of degrees to consider. total modes considered given by I = 2N(N+2).
%   varargin:
%     'format': coefficient format: 'Q' or 'AB'. default 'Q'.
%     'k': wave number in radians/meter. default 2*pi radians/meter.
%     'Prad': radiated power in watts. default 4*pi W.
%     'r': radius of observtion sphere in meters. default 1000 meters.
%     'eta': wave impedance in ohms. default 120*pi ohms.
%     'wtype': wave type: 'K' or 'F'. default determine based on presence of Crho in C.
% Outputs:
%   cfx: [X x Y] matrix of complex mode coefficients:
%          [X x Y] = [I   x 1] if 'Q'.
%          [X x Y] = [I/2 x 2] if 'AB'. rows contain s: [1 2] coefficients.
%        Decompose L into smn through:
%          s: 1 if i odd, 2 if i even.
%          n: integer(sqrt((i-s)/2+1)).
%          m: (i-s)/2+1-n(n+1).
%
function cfx = sphereWaveExpand(C, N, varargin)
    %% Input handling
    name = lower(varargin(1:2:end-1));
    value = varargin(2:2:end);
    for (nn = 1:numel(name))
        switch (lower(name{nn}))
            case 'format', format = value{nn};
            case 'prad', Prad = value{nn};
            case 'r', r = value{nn};
            case 'k', k = value{nn};
            case 'eta', eta = value{nn};
            case 'wtype', wtype = value{nn};
        end
    end
    
    % Determine field type
    fns = fieldnames(C);
    if (ismember('Etheta', fns)), ftype = 'E';
    elseif (ismember('Htheta', fns)), ftype = 'H';
    end
    
    % If DNE, default
    % format
    if (~exist('format', 'var')), format = 'Q'; end
    
    % Prad
    if (~exist('Prad', 'var')), Prad = 4*pi; end
    
    % k
    if (~exist('k', 'var') && ~ismember('k', fns)), k = 2*pi;
    elseif (ismember('k', fns)), k = C.k;
    end
    
    % r
    if (~exist('r', 'var') && ~ismember('r', fns)), r = 1000; 
    elseif (ismember('r', fns)), r = C.r;
    end
    
    % eta
    if (~exist('eta', 'var') && ~ismember('eta', fns)), eta = 120*pi;
    elseif (ismember('eta', fns)), eta = C.eta;
    end
    
    % wtype
    if (~exist('wtype', 'var'))
        if (ismember(horzcat(ftype, 'rho'), fns)), wtype = 'F';
        else, wtype = 'K';
        end
    end
    
    % Extract sample points and fields
    theta = C.Theta;
    phi = C.Phi;
    [th, ~] = meshgrid(theta, phi);
    if (strcmpi(wtype', 'F')), Crho = C.(horzcat(ftype, 'rho')); end
    Ctheta = C.(horzcat(ftype, 'theta'));
    Cphi = C.(horzcat(ftype, 'phi'));
    
    % Number of modes
    I = 2*N*(N+2);
    
    % Calculate total power radiated using Poynting theorem
    switch (upper(ftype))
        case 'E'
            U = 1/2/eta*r^2*(abs(Ctheta).^2 + abs(Cphi).^2);
        case 'H'
            U = 1/2*eta*r^2*(abs(Ctheta).^2 + abs(Cphi).^2);
    end
    Prad_p = numericIntegrate2(theta, phi, U.*sin(th));
    if (abs(Prad_p-Prad) > 1e-4)            % if calculated Prad does not match set Prad, calculate radial distance for calculated Prad and issue warning
        f = Prad/Prad_p;
        rp = sqrt(f)*r;
        warning('Power radiated by provided fields, %g W, at radial distance %g meters does not match provided power radiated of %g W! Distance should be %g meters.', Prad_p, r, Prad, rp);        
    end
    
    %% Calculate complex mode coefficients in Q format
    Qp = nan(I, 1);
    for (ii = 1:I)
        % Decompose single index into smn
        s = mod(ii+1, 2)+1;
        n = floor(sqrt((ii-s)/2+1));
        m = (ii-s)/2 + 1 - n*(n+1);
%         fprintf('%d%d%d\n', s, m, n);

        % Get mode vector and take inner product with field to get un-normalized Q coefficient
        if (strcmpi(wtype, 'K'))
            K = calcK(s, m, n, theta, phi);
            Qp(ii) = sum(Ctheta(:).*K.Ktheta(:) + Cphi(:).*K.Kphi(:));
        elseif (strcmpi(wtype, 'F'))
            F = calcF(4, s, m, n, k, r, theta, phi);
            Qp(ii) = sum(Crho(:).*F.Frho(:) + Ctheta(:).*F.Ftheta(:) + Cphi(:).*F.Fphi(:));
        end
    end
    
    %% Calculate power normalized Q such that Prad = 1/2*sum(abs(Qn)^2)
    Pp = 1/2*sum(abs(Qp(:)).^2);
    f = Prad/Pp;
    Q = sqrt(f)*Qp;
    
    %% Format Q to requested format ('Q' or 'AB')
    if (strcmpi(format, 'AB'))
        cfx = horzcat(reshape(Q(1:2:end-1), [], 1), reshape(Q(2:2:end), [], 1));
    elseif (strcmpi(format, 'Q'))
        cfx = Q;
    end
end