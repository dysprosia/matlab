%%
% This function reads HFSS 2D data exported as CSV.
%
% Inputs:
%   icsv: path to input CSV.
% Outputs:
%   data: data in struct format.
%
function data = readHFSS2Ddata(icsv)
    %% Read data
    fid = fopen(icsv, 'r');
    txt = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);
    txt = vertcat(txt{:});
    
    %% Parse data
    dat = cellfun(@(l) strsplit(l, ','), txt, 'uni', 0);
    header = cellfun(@parseHFSSHeader, dat{1}, 'uni', 0);
    
    tbl = dat(2:end);
    tbl = vertcat(tbl{:});
    tbl = cellfun(@str2double, tbl);
    
    %% Output
    data = struct('header', {horzcat(header{:})}, 'data', {tbl});
end