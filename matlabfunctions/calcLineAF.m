%% 
% This function calculates normalized array factor for a uniform line array using:
%
% AFn = 1/N * sin(N*\psi/2) / sin(\psi/2), \psi = kdsin(\theta_0)+\beta
%
% Inputs:
%   d: spacing of elements in lambda.
%   N: number of elements
%   th0: scan angle in degrees.
% Outputs:
%   th: theta in degrees chosen by num(th) = max(4*(2N-2), 361) with a range from -180 to 180.
%   AFn: normalized array factor.
%
% Notes:
%   To get AF in directivity, multiple AFn by D0 = 2Nd/\lambda.
%   Guideline for large arrays is at least four sample points per lobe, with the number of lobes equal to 2N-2 in the full 360deg.
%
function [th, AFn] = calcLineAF(d, N, th0)
    %% Get theta out
    th_num = max(8*(2*N-2), 361);
    th = linspace(-180, 180, th_num);
    
    %% Calculate \psi
    k = 2*pi;        % wave number in rad/s/lambda
    beta = -k*d*sin(th0*pi/180);        % phase delta between elements to scan to th0 in rad
    psi = k*d*sin(th*pi/180)+beta;      % psi in rad
    
    %% Calculate AFn
    AFn = 1/N * sin(N*psi/2) ./ sin(psi/2);         % equation
    
    % Handling for peak when denominator is 0
    idx_peak = abs(sin(psi/2)) < eps(0);
    AFn(idx_peak) = 1;
    
    % Redundant handling, but just in case numerical issues arise
    idx_nan = isnan(AFn);
    AFn(idx_nan) = 1;
end