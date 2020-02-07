%%
% This function calculates CP RCS given single-incident data structure with Re/Im Theta/Phi extracted by readFEKOFFEFile function.
%
function CP = calcFEKOCP(data)
    %% Check fields for Re_Theta_, Im_Theta_, Re_Phi_, and Im_Phi_
    fns_check = {'Re_Etheta_', 'Im_Etheta_', 'Re_Ephi_', 'Im_Ephi_'};
    idx_present = isfield(data, fns_check);
    if (any(~idx_present)), error('Fields %s not found!', strjoin(fns_check(~idx_present), ', ')); end
    
    %% Calculate CP E-fields
    Eph = complex(data.Re_Ephi_, data.Im_Ephi_);
    Eth = complex(data.Re_Etheta_, data.Im_Etheta_);
    ERHCP = (Eph + exp(-1j*pi/2)*Eth)/sqrt(2);
    ELHCP = (Eph + exp(+1j*pi/2)*Eth)/sqrt(2);
    
    %% Calculate axial ratio
    tau = angle(ERHCP./ELHCP)/2;
    Ex = Eph.*cos(tau) - Eth.*sin(tau);
    Ey = Eph.*sin(tau) + Eth.*cos(tau);
    AR = abs(Ex./Ey);
    
    %% Calculate CP RCS
    RCS_RHCP = 4*pi*abs(ERHCP).^2/2;
    RCS_LHCP = 4*pi*abs(ELHCP).^2/2;
    
    %% Store
    CP = struct('E_RHCP', {ERHCP}, 'E_LHCP', {ELHCP}, 'AR', {AR}, 'RCS_LHCP', {RCS_LHCP}, 'RCS_RHCP', {RCS_RHCP});
end