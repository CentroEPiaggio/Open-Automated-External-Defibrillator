function [SCA, l] = OAED_VFfilter (ecg, fs, echo)
%% Period evaluation

    if(nargin == 2)
        echo = false;
    end

    %T = 2*pi * (sum(abs(ecg))/ sum( abs(ecg - [0 ecg(1:end-1)]) ) );
    T = floor(1 + 2*pi * (sum(abs(ecg))/ sum( abs(ecg - [0 ecg(1:end-1)] ))));

%% Leakage evaluation
    %nt = floor(T * fs/1000);
    nt = floor(T/2);
    l = sum(abs( ecg(nt+1:end) + ecg(1:end-nt) ));
    l = l/ (sum( abs(ecg(nt+1:end)) + abs(ecg(1:end-nt)) ));

%% rhythm evaluation
    l0 = 0.625;
    if(l>l0)
        if(echo)
            disp('Normal rhythm')
        end
        SCA = false;
    else
        if(echo)
            disp('VF confirmed')
        end
        SCA = true;
    end
end
