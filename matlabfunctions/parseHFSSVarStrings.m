%% 
% This function parses HFSS variable strings.
%
% Inputs:
%   str: HFSS variable string.
% Outputs:
%   out: output structure.
%
function out = parseHFSSVarStrings(str)
    str = strrep(str, '''', '');
    dat = strsplit(str, ' ');
    dat = cellfun(@(d) strsplit(d, '='), dat, 'uni', 0);
    dat = horzcat(dat{:});
    if (~isempty(dat))
        out = struct(dat{:});
    else
        out = 'none';
    end
end