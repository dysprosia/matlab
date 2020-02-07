%% 
% This function runs for loops in verbose manner wrt time.
%
% Inputs:
%   func: function handle.
%   args: function arguments.
% Outputs:
%   out: function outputs.
%
function out = verboseFor(func, args)
    time_start = tic();
    prev_str_len = 0;
    out = cell(size(args));
    for (n = 1:numel(args))
        arg = args{n};
        out(n) = {func(arg{:})};
        fprintf(repmat('\b', 1, prev_str_len));
        str = sprintf('Finished %d of %d (%0.2f seconds remaining).\n', n, numel(args), toc(time_start)/n*(numel(args)-n));
        prev_str_len = numel(str);
        fprintf(str);
    end
    fprintf(repmat('\b', 1, prev_str_len));
    fprintf('Finished (%0.2f seconds taken).\n\n', toc(time_start));
end