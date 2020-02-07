%% 
% This function calculates directivity from pattern data.
%
% Inputs:
%   UU: u-coordinates from meshgrid
%   VV: v-coordinates from meshgrid
%   pat: complex pattern data
% Outputs:
%   D0: max directivity
%
function D0 = calcDirectivity(UU, VV, pat);
    %% Calculate WW
    WW = sqrt(1-UU.^2-VV.^2);
end