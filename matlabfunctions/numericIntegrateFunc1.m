%% This function numerically integrates a 1D function
%
% Inputs:
%   func: function handle of exact expression to evaluate3.
%   domain: range of input values to integrate over.
%   N: discretization segments.
%   method: method (left, right, midpoint, euler, trapezoidal, Simpson, Kepler, Gauss, Newton-Cotes); default: midpoint.
%   aux: auxillary input (degree or points); required for Newton-Cotes and Guass method.
% Outputs:
%   Q: numeric integration result.
%
function Q = numericIntegrateFunc1(func, domain, N, method, aux)
    % Input handling
    if (nargin < 4), method = 'midpoint';
    elseif (nargin < 5), aux = nan;
    end
    
    % Setup
    a = min(domain);
    b = max(domain);
    h = (b-a) / N;      % segment length
    x = a + (0:N)*h;      % sample points
    
    % Evaluate
    switch (upper(method))
        case {'LEFT'}
            % Evaluate function at left points
            f = func(x(1:end-1));
            
            % Compute Q
            Q = h*sum(f);
        case 'RIGHT'
            % Evaluate funciton at right points
            f = func(x(2:end));
            
            % Compute Q 
            Q = h*sum(f);
        case {'MIDPOINT', 'MID', 'EULER'}
            % If Euler
            if (strcmpi(method, 'EULER')), warning('Midpoint method assumed for Euler method.'); end
            
            % Take midpoint of defined sample points
            x_mid = (x(1:end-1)+x(2:end)) / 2;
            
            % Evaluate function at midpoints
            f = func(x_mid);
            
            % Compute Q
            Q = h * sum(f);
        case {'TRAPEZOIDAL', 'TRAP'}
            % Evaluate function at x
            f = func(x);
            
            % Compute Q
            Q = h/2*(f(1)+f(end)) + h/2*sum(2*f(2:end-1));
        case {'SIMPSON', 'SIMPSONS', 'KEPLER', 'KEPLERS'}
            % Check that N is even
            if (mod(N, 2)), error('Number of segments must be even for Simpson''s rule!'); end
            
            % Evaluate function at x
            f = func(x);
            
            % Simpson's rule Q = h/3 * (f_0 + 4*sum(f_odd) + 2*sum(f_even) + f_end)
            Q = h/3 * (f(1) + 4*sum(f(2:2:end-1)) + 2*sum(f(3:2:end-2)) + f(end));
        case 'NEWTON-COTES'
            % Recursvively call this with appropriate method based on degree
            if (aux == 0), Q = numericIntegrateFunc1(func, domain, N, 'euler');
            elseif (aux == 1), Q = numericIntegrateFunc1(func, domain, N, 'trapezoidal');
            elseif (aux == 2), Q = numericIntegrateFunc1(func, domain, N, 'simpon');
            elseif (isnan(aux)), error('Degree input required for Newton-Cotes rule!');
            else, error('Degree %d not supported with Newton-Cotes rule!', aux);
            end
        case 'GAUSS'
            % Requires auxillary input for n-points
            if (isnan(aux)), error('Order required for Gauss-Legendre method!'); end
            
            % Compute Q, recursing if N > 1
            if (N == 1)
                % Force function to [-1 1] domain
                f = @(u) (b-a)/2*func((b-a)/2*u + (a+b)/2);
                
                % Compute Q
                switch (aux)
                    case 1
                        xi = 0;
                        wi = 2;
                        Q = sum(arrayfun(@(w, x) w*f(x), wi, xi));
                    case 2
                        xi = [-1 1]*sqrt(1/3);
                        wi = ones(1, 2);
                        Q = sum(arrayfun(@(w, x) w*f(x), wi, xi));
                    case 3
                        xi = nan(1, N); wi = nan(1, N);
                        xi(1) = 0;
                        wi(1) = 8/9;
                        xi(2:3) = [-1; 1]*sqrt(3/5);
                        wi(2:3) = 5/9 * ones(1, 2);
                        Q = sum(arrayfun(@(w, x) w*f(x), wi, xi));
                    case 4
                        xi = nan(1, N); wi = nan(1, N);
                        xi(1:2) = [-1 1]*sqrt(3/7-2/7*(sqrt(6/5)));
                        wi(1:2) = (18+sqrt(30))/36 * ones(1, 2);
                        xi(3:4) = [-1 1]*sqrt(3/7+2/7*(sqrt(6/5)));
                        wi(3:4) = (18-sqrt(30))/36 * ones(1, 2);
                        Q = sum(arrayfun(@(w, x) w*f(x), wi, xi));
                    case 5
                        xi = nan(1, N); wi = nan(1, N);
                        xi(1) = 0;
                        wi(1) = 128/225;
                        xi(2:3) = [-1 1] * 1/3*(sqrt(5-2*sqrt(10/7)));
                        wi(2:3) = (322+13*sqrt(70))/900 * ones(1, 2);
                        xi(4:5) = [-1 1] * 1/3*(sqrt(5+2*sqrt(10/7)));
                        wi(4:5) = (322-13*sqrt(70))/900 * ones(1, 2);
                        Q = sum(arrayfun(@(w, x) w*f(x), wi, xi));
                    otherwise
                        error('%d-point Gaussian method not supported!', aux);
                end
            else
                Q = sum(arrayfun(@(aa, bb) numericIntegrateFunc1(func, [aa bb], 1, 'gauss', aux), x(1:end-1), x(2:end)));
            end 
        otherwise
            error('Selected method ''%s'' is not supported!', method);
    end
end