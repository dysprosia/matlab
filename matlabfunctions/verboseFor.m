%% 
% This function runs for loops in verbose manner wrt time.
%
% Inputs:
%   func: function handle.
%   args: function arguments.
%   verbose: verbose? (i know doesn't really make sense for a function with verbose as the purpose...but...). default true. duh.
% Outputs:
%   out: function outputs.
%
function out = verboseFor(func, args, verbose)
    if (~exist('verbose', 'var')), verbose = true; end
    time_start = tic();
    prev_str_len = 0;
    out = cell(size(args));
    for (n = 1:numel(args))
        arg = args{n};
        if (iscell(arg))
            out(n) = {func(arg{:})};
        else
            out(n) = {func(arg)};
        end
        if (verbose)
            fprintf(repmat('\b', 1, prev_str_len));
            str = sprintf('Finished %d of %d (%0.2f seconds remaining).\n', n, numel(args), toc(time_start)/n*(numel(args)-n));
            prev_str_len = numel(str);
            fprintf(str);
        end
    end
    if (verbose)
        fprintf(repmat('\b', 1, prev_str_len));
        fprintf('Finished (%0.2f seconds taken).\n\n', toc(time_start));
    end
end