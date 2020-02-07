%% This function numerically differentiates a 1D data set
%
% Inputs:
%   x: input X.
%   y: input Y.
%   method: method (left, right, mid). default mid.
% Outputs:
%   xd: output X.
%   yd: output Y.
%
function [xd, yd] = numericDeriv1(x, y, method)
    % Default method is mid
    if (~exist('method', 'var')), method = 'mid'; end
    
    % Differentiate
    x_diff = diff(x);
    y_diff = diff(y);
    yd = y_diff ./ x_diff;
    
    % Set xd according to method
    switch (upper(method))
        case 'LEFT'
            xd = x(1:end-1);
        case 'RIGHT'
            xd = x(2:end);
        case 'MID'
            xd = arrayfun(@(a, b) (a+b)/2, x(1:end-1), x(2:end));
        otherwise
            error('Method ''%s'' is not understood! Options are ''left'', ''right'', and ''mid''.', method);
    end
end