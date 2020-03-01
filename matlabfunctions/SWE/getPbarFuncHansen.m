%% This function gets Pbar as a function pointer. Functions are give in Spherical Near-Field Antenna Measurements tables in Appendix A1.
%
% Inputs:
%   n: n index
%   m: m index
% Outputs:
%   P1: function pointer for m/sin(th)*Pbar(cos(th))
%   P2: function pointer for d(Pbar(cos(th)))/d-th
%
function [P1, P2] = getPbarFuncHansen(n, m)
    warning('This function is deprecated. Use calcPbar(n, m, th) instead.');
    if (abs(n) > eps(0))
        PA = {@(th) zeros(size(th))             @(th) zeros(size(th))               @(th) zeros(size(th))                       @(th) zeros(size(th))                               @(th) zeros(size(th));
              @(th) sqrt(3)/2*ones(size(th))    @(th) sqrt(15)/2*cos(th)            @(th) sqrt(42)/16*(5*cos(2*th)+3)           @(th) 3*sqrt(10)/32*(7*cos(3*th)+9*cos(th))         @(th) sqrt(165)/128*(21*cos(4*th)+28*cos(2*th)+15);
              @(th) nans(size(th))              @(th) sqrt(15)/2*sin(th)            @(th) sqrt(105)/4*sin(2*th)                 @(th) 3*sqrt(5)/16*(7*sin(3*th)+3*sin(th))          @(th) sqrt(1155)/32*(3*sin(4*th)+2*sin(2*th));
             };
        PB = {@(th) -sqrt(6)/2*sin(th)          @(th) -3*sqrt(10)/4*sin(2*th)       @(th) -3*sqrt(14)/16*(5*sin(3*th)+sin(th))  @(th) -15*sqrt(2)/32*(7*sin(4*th)+2*sin(2*th))      @(th) -15*sqrt(22)/256*(21*sin(5*th)+7*sin(3*th)+2*sin(th));
              @(th) sqrt(3)/2*cos(th)           @(th) sqrt(15)/2*cos(2*th)          @(th) sqrt(42)/32*(15*cos(3*th)+cos(th))    @(th) 3*sqrt(10)/16*(7*cos(4*th)+cos(2*th))         @(th) sqrt(165)/256*(105*cos(5*th)+21*cos(3*th)+2*cos(th));
              @(th) nans(size(th))              @(th) sqrt(15)/4*sin(2*th)          @(th) sqrt(105)/16*(3*sin(3*th)-sin(th))    @(th) 3*sqrt(5)/16*(7*sin(4*th)-2*sin(2*th))        @(th) sqrt(115)/128*(15*sin(5*th)-3*sin(3*th)-2*sin(th));
             };
        P1 = PA{abs(m)+1, n};
        P2 = PB{abs(m)+1, n};
    else
        P1 = @(th) ones(size(th));
        P2 = @(th) zeros(size(th));
    end
end