%%
% This function numerically integrates a 1D data set.
%
% Inputs:
%   x: independent variable
%   y: dependent variable to integrate
%   N: discretization segments.
%   method: method (left, right, midpoint, euler, trapezoidal, Simpson, Kepler, Gauss, Newton-Cotes); default: midpoint.
%   aux: auxillary input (degree or points); required for Newton-Cotes and Guass method.
% Outputs:
%   Q: numeric integration result.
%
function Q = numericIntegrate1(x, y, N, method, aux)
    % Cast inputs x and y into 'function' of its interpolation using spline without extrapolation
    func = @(xx) interp1(x, y, xx, 'spline', nan);
    
    % Compute numeric integration result
    if (~exist('method', 'var')), method = 'mid'; end
    if (~exist('aux', 'var')), aux = nan; end
    Q = numericIntegrateFunc1(func, [min(x) max(x)], N, method, aux);
end