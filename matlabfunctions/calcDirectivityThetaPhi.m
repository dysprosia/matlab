%%
% This function calculates directivity from field data in theta phi.
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
%   varargin:
%     'k': wave number in radians/meter. default 2*pi radians/meter.
%     'r': radius of observtion sphere in meters. default 1000 meters.
%     'eta': wave impedance in ohms. default 120*pi ohms.
% Outputs:
%   D: directivity.
%    .Theta: theta in radians.
%    .Phi: phi in radians.
%    .Dtheta: theta directivity.
%    .Dphi: phi directivity.
%    .Dtotal: total directivity.
%    .k: wave number in radians/meter.
%    .r: observation sphere radius in meters.
%    .eta: wave impedance in ohms.
%
function D = calcDirectivityThetaPhi(C, varargin)
    %% Input handling
    name = lower(varargin(1:2:end-1));
    value = varargin(2:2:end);
    for (nn = 1:numel(name))
        switch (lower(name{nn}))
            case 'r', r = value{nn};
            case 'k', k = value{nn};
            case 'eta', eta = value{nn};
        end
    end
    
    % If DNE, default    
    fns = fieldnames(C);
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
    
    % Determine field type
    if (ismember('Etheta', fns)), ftype = 'E'; const = 1/eta;
    elseif (ismember('Htheta', fns)), ftype = 'H'; const = eta;
    end
    
    % Extract sample points and fields
    theta = C.Theta;
    phi = C.Phi;
    [th, ~] = meshgrid(theta, phi);
    Ctheta = C.(horzcat(ftype, 'theta'));
    Cphi = C.(horzcat(ftype, 'phi'));
    
    % Calculate total power radiated using Poynting theorem
    U = 1/2*const*r^2*(abs(Ctheta).^2 + abs(Cphi).^2);
    Prad = numericIntegrate2(theta, phi, U.*sin(th));
    
    % Calculate directivity
    Dth = 1/2*const*r^2*abs(Ctheta).^2*4*pi/Prad;
    Dph = 1/2*const*r^2*abs(Cphi).^2*4*pi/Prad;
    Dtot = 1/2*const*r^2*abs(Ctheta+Cphi).^2*4*pi/Prad;
    
    % Store
    D = struct('Theta', C.Theta, ...
               'Phi', C.Phi, ...
               'Dtheta', Dth, ...
               'Dphi', Dph, ...
               'Dtotal', Dtot, ...
               'k', k, ...
               'r', r, ...
               'eta', eta ...
              );
end