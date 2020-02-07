%%
% This function generates array geometry given user options passed in.
%
function array = generateArrayGeometry(user_inputs)
    %% Input verification
    if (mod(user_inputs.array.geometry.nx, user_inputs.array.geometry.nSAx) > eps(0))
        error('Number of elements in X is not evenly divisible by number of sub-arrays!');
    end
    if (mod(user_inputs.array.geometry.ny, user_inputs.array.geometry.nSAy) > eps(0))
        error('Number of elements in Y is not evenly divisible by number of sub-arrays!');
    end
    
    %% Generate element locations
    tempX = (1:user_inputs.array.geometry.nx)-1;
    X = (tempX-mean(tempX))*user_inputs.array.geometry.dx;
    tempY = (1:user_inputs.array.geometry.ny)-1;
    Y = (tempY-mean(tempY))*user_inputs.array.geometry.dy;
    [XX, YY] = meshgrid(X, Y);
    
    %% Generate sub-array center locations
    nx = user_inputs.array.geometry.nx/user_inputs.array.geometry.nSAx;
    ny = user_inputs.array.geometry.ny/user_inputs.array.geometry.nSAy;
    SAX_cells = mat2cell(XX, ny*ones(1, user_inputs.array.geometry.nSAy), nx*ones(1, user_inputs.array.geometry.nSAx));
    SAX_centers = cellfun(@(x) mean(x(:)), SAX_cells);
    SAX_all = SAX_cells;
    for (n = 1:numel(SAX_all)), SAX_all{n}(:) = SAX_centers(n); end
    SAX1 = SAX_cells{1}-SAX_centers(1);
    SAY_cells = mat2cell(YY, ny*ones(1, user_inputs.array.geometry.nSAy), nx*ones(1, user_inputs.array.geometry.nSAx));
    SAY_centers = cellfun(@(y) mean(y(:)), SAY_cells);
    SAY_all = SAY_cells;
    for (n = 1:numel(SAY_all)), SAY_all{n}(:) = SAY_centers(n); end
    SAY1 = SAY_cells{1}-SAY_centers(1);
    
    %% Output
    array.geometry = struct('X', {XX}, ...
                            'Y', {YY}, ...
                            'SAX', {SAX1}, ...
                            'SAY', {SAY1}, ...
                            'SAX_all', {cell2mat(SAX_all)}, ...
                            'SAY_all', {cell2mat(SAY_all)}, ...
                            'SAX_cells', {SAX_cells}, ...
                            'SAY_cells', {SAY_cells}, ...
                            'SAX_centers', {SAX_centers}, ...
                            'SAY_centers', {SAY_centers});
end