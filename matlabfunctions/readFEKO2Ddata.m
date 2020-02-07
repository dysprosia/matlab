%%
% This function reads FEKO 2D data exported as dat.
%
% Inputs:
%   icsv: path to input DAT.
% Outputs:
%   data: data in struct format.
%
function data = readFEKO2Ddata(idat)
    %% Read data
    fid = fopen(idat, 'r');
    txt = textscan(fid, '%s', 'delimiter', '\n', 'headerlines', 1);
    fclose(fid);
    txt = vertcat(txt{:});
    
    %% Parse data
    dat = cellfun(@(l) strsplit(l, '\t', 'delimitertype', 'regularexpression'), txt, 'uni', 0);
    header = cellfun(@parseFEKOHeader, dat{1}, 'uni', 0);
    
    tbl = dat(2:end);
    tbl = vertcat(tbl{:});
    tbl = cellfun(@str2double, tbl);
    idx_nan = isnan(tbl);
    col_nan = all(idx_nan);
    tbl(:, col_nan) = [];
    
    %% Output
    data = struct('header', {horzcat(header{:})}, 'data', {tbl});
end