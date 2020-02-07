%%
% This function performs iDFT in two-dimensions to compute element weights from pattern
%
% Inputs:
%   k: wave number (2*pi/lambda)
%   pat: pattern               [Mx1]
%   X: element x locations     [Nx1]
%   Y: element y locations     [Nx1]
%   Z: element z locations     [Nx1]
%   U: pattern U sample points [Mx1]
%   V: pattern V sample points [Mx1]
%   W: pattern W sample points [Mx1]
% Outputs:
%   A: element weights         [Nx1]
%
function A = idft2(k, pat, X, Y, Z, U, V, W)
    XYZ = horzcat(X(:), Y(:), Z(:));        % [Nx3]
    UVW = horzcat(U(:), V(:), W(:))';       % [3xM]
    pat = pat(:);                           % [Mx1]
    A = exp(-1j*k*XYZ*UVW)*pat;             % [Nx1]
end