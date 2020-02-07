%%
% This function performs DFT in two-dimensions to compute pattern from element weights.
%
% Inputs:
%   k: wave number (2*pi/lambda)
%   A: element complex weights [1xN]
%   X: element x locations     [Nx1]
%   Y: element y locations     [Nx1]
%   Z: element z locations     [Nx1]
%   U: pattern U sample points [Mx1]
%   V: pattern V sample points [Mx1]
%   W: pattern W sample points [Mx1]
% Outputs:
%   pat: pattern               [1xM]
%
function pat = dft2(k, A, X, Y, Z, U, V, W)
    XYZ = horzcat(X(:), Y(:), Z(:));        % [Nx3]
    UVW = horzcat(U(:), V(:), W(:))';       % [3xM]
    A = A(:)';                              % [1xN]
    pat = A*exp(1j*k*XYZ*UVW);              % [1xM]
end