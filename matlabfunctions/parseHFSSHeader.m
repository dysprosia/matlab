%% 
% This function parses HFSS header.
%
% Inputs:
%   str: HFSS header string.
% Outputs:
%   out: output structure.
%
function out = parseHFSSHeader(str)
    str = strrep(str, '"', '');
    parts = regexp(str, '^(?<param>[^\s]+)\s\[(?<unit>[^\]]*)\](\s-\s)?(?<variables>.*)$', 'names');
    parts.variables = parseHFSSVarStrings(parts.variables);
    out = parts;
end