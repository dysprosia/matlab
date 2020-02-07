%%
% This function generates array weights given user options passed in.
%
function array = generateArrayWeights(user_inputs, array)
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
    
    %% Phase-shifter type setup
    ps_weight = [0, user_inputs.f_tune_GHz/user_inputs.f_oper_GHz, 1];  % no PS, PS (squint off-tune), TDU
    
    %% Element weights
    % Calculate amplitude weights
    switch (upper(user_inputs.taper.X.type))
        case 'TAYLOR'
            ampX_lin = taylorwin(user_inputs.array.geometry.nx, user_inputs.taper.X.nbar, user_inputs.taper.X.SLL_dB)';
        case 'UNIFORM'
            ampX_lin = ones(1, user_inputs.array.geometry.nx);
    end
    switch (upper(user_inputs.taper.Y.type))
        case 'TAYLOR'
            ampY_lin = taylorwin(user_inputs.array.geometry.ny, user_inputs.taper.Y.nbar, user_inputs.taper.Y.SLL_dB);
        case 'UNIFORM'
            ampY_lin = ones(user_inputs.array.geometry.ny, 1);
    end
    amp_lin = ampY_lin*ampX_lin;
    
    % Calculate phase weights
    % Convert steer angle to UV
    switch (upper(user_inputs.steer_angle.CS))
        case 'UV'
            u = user_inputs.steer_angle.dim1;
            v = user_inputs.steer_angle.dim2;
        case 'PHITHETA'
            uv = phitheta2uv(vertcat(user_inputs.steer_angle.dim1, user_inputs.steer_angle.dim2));
            u = uv(1);
            v = uv(2);
        case 'AZEL'            
            uv = azel2uv(vertcat(user_inputs.steer_angle.dim1, user_inputs.steer_angle.dim2));
            u = uv(1);
            v = uv(2);
        otherwise
            error('Coordinate system of type ''%s'' not recoginzed!', user_inputs.steer_angle.CS);
    end
    
    % Calculate element phase weights
    ps_factor = user_inputs.array.phase_shifter.element+1;
    phsX_cmplx = exp(1j*k*array.geometry.X*u*ps_weight(ps_factor));
    phsY_cmplx = exp(1j*k*array.geometry.Y*v*ps_weight(ps_factor));
    phs_cmplx = phsY_cmplx*phsX_cmplx;
    
    % Element weights
    element_weights = amp_lin.*phs_cmplx;
    element_weights = element_weights/max(abs(element_weights(:)));
    
    %% Sub-array weights
    % Calculate phase weights
    ps_factor = user_inputs.array.phase_shifter.subarray+1;
    phsX_cmplx = exp(1j*k*array.geometry.SAX_centers*u*ps_weight(ps_factor));
    phsY_cmplx = exp(1j*k*array.geometry.SAY_centers*v*ps_weight(ps_factor));
    phs_cmplx = phsY_cmplx*phsX_cmplx;
    phs_cmplx = phs_cmplx/max(abs(phs_cmplx(:)));
    
    % Sub-array weights
    SA_weights = phs_cmplx;
    
    %% Store
    array.weights = struct('element_cmplx', element_weights, ...
                           'subarray_cmplx', SA_weights);
end