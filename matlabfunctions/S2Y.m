%%
% This function converts S matrix to Y matrix for one- or two-port.
%
% Inputs:
%   S: sparameter object created by sparameters function.
%    .NumPorts: number of ports (must be 1 or 2!)
%    .Frequencies: frequencies in Hz in Mx1 matrix
%    .Parameters: S parameters in NxNxM matrix
%    .Impedance: reference impedance
% Outputs:
%   Y: Y parameter structure
%    .NumPorts: number of ports
%    .Frequencies: frequencies in Hz in Mx1 matrix
%    .Parameters: Y parameters in NxNxM matrix
%    .Admittance: reference admittance
%
function Y = S2Y(S)
    % Input checking
    if (S.NumPorts > 2), error('S-parameters of %d-port device is not supported! Limit to 1 or 2 ports.', S.NumPorts); end
    
    % Setup
    Y0 = 1/S.Impedance;
    if (S.NumPorts == 1)
        S11 = S.Parameters;
    else
        S11 = squeeze(S.Parameters(1, 1, :));
        S21 = squeeze(S.Parameters(2, 1, :));
        S12 = squeeze(S.Parameters(1, 2, :));
        S22 = squeeze(S.Parameters(2, 2, :));
    end
    
    % Calculate Y-parameters
    if (S.NumPorts == 1)
        Y11 = Y0*(1-S11)./(1+S11);
    else
        Y11 = Y0*((1-S11).*(1+S22) + S12.*S21)./((1+S11).*(1+S22) - S12.*S21);
        Y21 = Y0*(-2*S21)./((1+S11).*(1+S22) - S12.*S21);
        Y12 = Y0*(-2*S12)./((1+S11).*(1+S22) - S12.*S21);
        Y22 = Y0*((1+S11).*(1-S22) + S12.*S21)./((1+S11).*(1+S22) - S12.*S21);
    end
    
    % Store into output
    if (S.NumPorts == 1)
        Ymat = Y11;
    else
        Ymat = nan(size(S.Parameters));
        Ymat(1, 1, :) = Y11;
        Ymat(2, 1, :) = Y21;
        Ymat(1, 2, :) = Y12;
        Ymat(2, 2, :) = Y22;
    end
    Y = struct('NumPorts', S.NumPorts, 'Frequencies', S.Frequencies, 'Parameters', Ymat, 'Admittance', Y0);
end