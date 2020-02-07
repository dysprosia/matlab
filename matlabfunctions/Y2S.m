%%
% This function converts Y matrix to S matrix for one- or two-port.
%
% Inputs:
%   Y: Y parameter structure
%    .NumPorts: number of ports
%    .Frequencies: frequencies in Hz in Mx1 matrix
%    .Parameters: Y parameters in NxNxM matrix
%    .Admittance: reference admittance
% Outputs:
%   S: sparameter structure
%    .NumPorts: number of ports (must be 1 or 2!)
%    .Frequencies: frequencies in Hz in Mx1 matrix
%    .Parameters: S parameters in NxNxM matrix
%    .Impedance: reference impedance
%
function S = Y2S(Y)
    % Input checking
    if (Y.NumPorts > 2), error('Y-parameters of %d-port device is not supported! Limit to 1 or 2 ports.', Y.NumPorts); end
    
    % Setup
    Y0 = Y.Admittance;
    if (Y.NumPorts ~= 1)
        Y11 = squeeze(Y.Parameters(1, 1, :));
        Y21 = squeeze(Y.Parameters(2, 1, :));
        Y12 = squeeze(Y.Parameters(1, 2, :));
        Y22 = squeeze(Y.Parameters(2, 2, :));
        delY = (Y11+Y0).*(Y22+Y0)-Y12.*Y21;
    end
    
    % Convert to S-parameters
    if (Y.NumPorts == 1)
        S11 = (Y0-Y.Parameters)./(Y0+Y.Parameters);
    else
        S11 = ((Y0-Y11).*(Y0+Y22)+Y12.*Y21) ./ delY;
        S21 = -2*Y21*Y0 ./ delY;
        S12 = -2*Y12*Y0 ./ delY;
        S22 = ((Y0+Y11).*(Y0-Y22)+Y12.*Y21) ./ delY;
    end
    
    % Store into output
    if (Y.NumPorts == 1)
        Smat = S11;
    else
        Smat = nan(size(Y.Parameters));
        Smat(1, 1, :) = S11;
        Smat(2, 1, :) = S21;
        Smat(1, 2, :) = S12;
        Smat(2, 2, :) = S22;
    end
    S = struct('NumPorts', Y.NumPorts, 'Frequencies', Y.Frequencies, 'Parameters', Smat, 'Impedance', 1/Y0);
end