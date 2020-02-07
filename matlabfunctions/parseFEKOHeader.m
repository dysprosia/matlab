%% 
% This function parses FEKO header.
%
% Inputs:
%   str: FEKO header string.
% Outputs:
%   out: output structure.
%
function out = parseFEKOHeader(str)
    str = strrep(str, '"', '');
    parts = regexp(str, '^(?<param>[^\s]+)\s*\[(?<unit>[^\]]*)\]\s*$', 'names');
    out = parts;
end