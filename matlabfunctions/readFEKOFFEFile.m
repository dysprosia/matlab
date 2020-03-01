%%
% This function reads FEKO ffe file.
%
% Inputs:
%   ipath: filepath to ffe file.
%   verbose: boolean to set output. default false.
% Outputs:
%   data: data in structure.
%
function data = readFEKOFFEFile(ipath, verbose)
    %% Input handling
    if (nargin == 1), verbose = false; end
    
    %% Read in data
    fid = fopen(ipath, 'r');
    txt = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);
    txt = vertcat(txt{:});
    
    %% Break into header-delimited chunks (split on empty lines)
    idx_empty = cellfun(@isempty, txt);
    txt(idx_empty) = {'SpLiThErE'};
    txt = strjoin(txt, '\n');
    txt = regexprep(txt, '(SpLiThErE\n)+', 'SpLiThErE\n');
    chunks = strsplit(txt, 'SpLiThErE\n')';
    chunks = cellfun(@(x) strsplit(x, '\n')', chunks, 'uni', 0);
    
    %% Process chunks
    chunks_args = arrayfun(@(x) x, chunks, 'uni', 0);
    chunks_processed = verboseFor(@processChunk, chunks_args, verbose);
    chunks_processed = vertcat(chunks_processed{:});
    
    %% Post-processing
    idx_header = ismember({chunks_processed.type}', 'header');
    data = struct('file', ipath, 'header', arrayfun(@(s) s.data, chunks_processed(idx_header), 'uni', 0), 'data', arrayfun(@(s) s.data, chunks_processed(~idx_header)));
end

%% Process chunk
function out = processChunk(in)
    % Pre-process
    idx_empty = cellfun(@isempty, in);
    in(idx_empty) = [];
    
    % Determine if FFE header or data block
    if (any(~cellfun(@isempty, strfind(in, 'Configuration Name: '))))      % then data block
        % Get indices
        idx_data = cellfun(@isempty, (regexp(in, '^#', 'once')));         % get index of data
%         idx_data = numel(in);                                                               % data is last line
        idx_header = 1:(find(idx_data,1,'first')-2);                      % header is first to two before data line
        idx_col = find(idx_data, 1, 'first')-1;                           % column headers is right before data line
        
        % Convert header lines to struct
        pre_pre_header = cellfun(@(t) strtrim(strsplit(strrep(t, '#', ''), ':')), in(idx_header), 'uni', 0);
        pre_header = cellfun(@(h) {matlab.lang.makeValidName(h{1}) h{2}}, pre_pre_header, 'uni', 0);
        pre_header = horzcat(pre_header{:});
        header = struct(pre_header{:});
        
        % Convert column header to varnames
        pre_col = strtrim(strsplit(regexprep(in{idx_col}, '[#"]', ''), '\s', 'delimitertype', 'regularexpression'));
        pre_col(cellfun(@isempty, pre_col)) = [];
        col = matlab.lang.makeValidName(pre_col);
        
        % Convert data to numeric
        pre_num = cellfun(@(d) str2double(strtrim(strsplit(d, '\s', 'delimitertype', 'regularexpression'))), in(idx_data), 'uni', 0);
        num = vertcat(pre_num{:});
        numcell = mat2cell(num, size(num, 1), ones(1, size(num, 2)));
        
        % Data as struct
        pre_data = vertcat(col, numcell);
        data = struct(pre_data{:});
        
        % Output
        pre_out = struct('header', header, 'data', data);
        out = struct('type', 'data', 'data', {pre_out});
    else        % else FFE header
        out = struct('type', 'header', 'data', {in});
    end
end