%% Main function for pattern code where user can set options
%% Initialize workspace
fclose('all');
delete(get(0, 'children'));
clear();
clc();

%% Paths
addpath(genpath('.\functions\'));
addpath('C:\Users\Songyi\OneDrive\Documents\gradschool\CUBoulder\workspace\matlab\matlabfunctions\');

%% Initialize pattern code
user_inputs = init();

%% User settings
user_inputs.units = 'meters';       % meter/meters/m, milimeter/milimeters/mm, mils/mil, inch/inches/in
user_inputs.array.geometry = struct('nx', 10, ...           % number of elements in X
                                    'dx', 0.00375, ...        % element spacing in X
                                    'ny', 10, ...           % number of elements in Y
                                    'dy', 0.00375, ...        % element spacing in Y
                                    'nSAx', 1, ...          % number of sub-arrays in X. must evenly divide NX! !!! NEED TO FIX; KEEP AT 1 !!!
                                    'nSAy', 1);             % number of sub-arrays in Y. must evenly divide NY! !!! NEED TO FIX; KEEP AT 1 !!!
user_inputs.array.phase_shifter.element = 1;            % 0: none, 1: phase-shifter, 2: TDU
user_inputs.array.phase_shifter.subarray = 0;           % 0: none, 1: phase-shifter, 2: TDU
user_inputs.f_oper_GHz = 10;        % operating frequency in GHz
user_inputs.f_tune_GHz = 10;        % tune frequency in GHz
user_inputs.element_factor = 1.7;   % element pattern cosine rolloff factor (cos(theta)^factor)
user_inputs.steer_angle = struct('CS', 'UV', ...        % coordinate system: UV, phitheta, AzEl
                                 'dim1', 0, ...         % U, phi, Az
                                 'dim2', sind(10), ...         % V, theta, El
                                 'squint1', 0, ...      % U, phi, Az
                                 'squint2', 0);         % V, theta, El
user_inputs.taper.X = struct('type', 'Uniform', ...      % Taylor, Uniform
                             'SLL_dB', -30, ...         % side-lobe level
                             'nbar', 4);                % nbar
user_inputs.taper.Y = struct('type', 'Uniform', ...      % Taylor, Uniform
                             'SLL_dB', -30, ...         % side-lobe level
                             'nbar', 4);                % nbar
user_inputs.pattern.U = struct('span', [-1 1], ...      % U span
                               'num', 501);             % U num points
user_inputs.pattern.V = struct('span', [-1 1], ...      % V span
                               'num', 501);             % V num points   
user_inputs.plots = struct('geometry', true, ...            % element locations and sub-array overlay
                           'weights', true, ...             % element and SA weights
                           'element_factor', true, ...      % element factor
                           'array_factor', true, ...        % array factor
                           'SA_factor', true, ...           % sub-array factor
                           'total_pattern', true, ...       % total pattern
                           'cuts', true);                   % pattern cuts
                             
%% Run pattern code
array = generateArrayGeometry(user_inputs);
array = generateArrayWeights(user_inputs, array);
array = generatePatterns(user_inputs, array);
figs = plotStuff(user_inputs, array);