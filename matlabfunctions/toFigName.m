function out = toFigName(in)
    out = strrep(strrep(strrep(strrep(strrep(strrep(regexprep(in, '[\s@;:,\(\)]', '_'), '=', ''), ' ', '_'), '\circ', 'deg'), '\theta_{inc}', 'thetainc'), '\phi_{inc}', 'phiinc'), '.', 'p');
end