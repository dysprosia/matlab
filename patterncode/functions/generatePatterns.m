%%
% This function calculates patterns (element, array, sub-array, total) given user_inputs and element/sub-array weights.
%
function array = generatePatterns(user_inputs, array)
    %% Speed of light in user-specified units
    switch (upper(user_inputs.units))
        case {'METERS', 'METER', 'M'}
            c0 = user_inputs.c0;
        case {'MILIMETER', 'MILIMETERS', 'MM'}
            c0 = user_inputs.c0*1000;
        case {'INCH', 'INCHES', 'IN'}
            c0 = user_inputs.c0*39.37007874;
        case {'MIL', 'MILS'}
            c0 = user_inputs.c0*39370.07874;
        otherwise
            error('Unit of type ''%s'' not recognized!', user_inputs.units);
    end
    
    %% Wavelength
    lambda = c0/user_inputs.f_oper_GHz/1e9;
    k = 2*pi/lambda;
    
    %% Pattern sample points
    U = linspace(min(user_inputs.pattern.U.span), max(user_inputs.pattern.U.span), user_inputs.pattern.U.num);
    V = linspace(min(user_inputs.pattern.V.span), max(user_inputs.pattern.V.span), user_inputs.pattern.V.num);
    [UU, VV] = meshgrid(U, V);
    WW = sqrt(UU.^2+VV.^2);
    
    %% Element pattern
    phitheta = uv2phitheta(horzcat(UU(:), VV(:))');
    theta = phitheta(2, :);
    pattern_element = cos(theta*pi/180).^user_inputs.element_factor;
    
    %% Array factor
    X = array.geometry.X;
    Y = array.geometry.Y;
    Z = zeros(size(X));
    pattern_array = dft2(k, array.weights.element_cmplx, X(:), Y(:), Z(:), UU(:), VV(:), WW(:));
    pattern_array = pattern_array/max(abs(pattern_array(:)));
    
    %% Sub-array factor
    X = array.geometry.SAX_centers;
    Y = array.geometry.SAY_centers;
    Z = zeros(size(X));
    pattern_SA = dft2(k, array.weights.subarray_cmplx, X(:), Y(:), Z(:), UU(:), VV(:), WW(:));
    pattern_SA = pattern_SA/max(abs(pattern_SA(:)));
    
    %% Total pattern
    pattern_total = pattern_element.*pattern_array.*pattern_SA;
    
    %% Store
    array.patterns = struct('U', UU(:), ...
                            'V', VV(:), ...
                            'element', pattern_element, ...
                            'array', pattern_array, ...
                            'subarray', pattern_SA, ...
                            'total', pattern_total);
end