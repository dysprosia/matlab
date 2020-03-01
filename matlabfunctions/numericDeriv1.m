%% This function numerically differentiates a 1D data set
%
% Inputs:
%   x: input X.
%   y: input Y.
%   method: [optional] method:forward, backward, central (default central).
%   order: [optional] order of method (default 1).
% Outputs:
%   xd: output X.
%   yd: output Y.
%
function [xd, yd] = numericDeriv1(x, y, method, order)
    % Default method is mid
    if (~exist('method', 'var')), method = 'central'; end
    if (~exist('order', 'var')), order = 1; end
    if (order == 2), error('Second order finite difference not implemented yet!'); end
    
    % Finite difference
    h = diff(x);
    switch (lower(method))
        case 'forward'
            if (order == 1)
                xd = x(1:end-1);
                yd = (y(2:end)-y(1:end-1)) ./ h;
            elseif (order == 2)
                hc2 = nan(1, numel(h)-1);
                for (nn = 1:numel(hc2)), hc2(nn) = h(nn)*h(nn+1); end
                xd = x(1:end-2);
                yd = (y(3:end)-2*y(2:end-1)+y(1:end-2)) ./ hc2;
            end
        case 'backward'
            if (order == 1)
                xd = x(2:end);
                yd = (y(2:end)-y(1:end-1)) ./ h;
            elseif (order == 2)
                hc2 = nan(1, numel(h)-1);
                for (nn = 1:numel(hc2)), hc2(nn) = h(nn)*h(nn+1); end
                xd = x(3:end);
                yd = (y(3:end)-2*y(2:end-1)+y(1:end-2)) ./ hc2;
            end
        case 'central'
            if (order == 1)
                hc = nan(1, numel(h)-1);
                for (nn = 1:numel(hc)), hc(nn) = h(nn)+h(nn+1); end
                xd = x(2:end-1);
                yd = (y(3:end)-y(1:end-2)) ./ hc;
            elseif (order == 2)
                hc2 = nan(1, numel(h)-1);
                for (nn = 1:numel(hc2)), hc2(nn) = h(nn)*h(nn+1); end
                xd = x(2:end-1);
                yd = (y(3:end)-2*y(2:end-1)+y(1:end-2)) ./ h2;
            end
    end
end