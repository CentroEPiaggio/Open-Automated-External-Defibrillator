function [SCA, d, di] = OAED_PSR (ecg, fs, echo)

    if(nargin == 2)
        echo = false;
    end
    tau = floor(fs * 0.5);
    d0 = 0.2;
    n = 40;

    %%
    ecg2 = ecg - min(ecg);
    ecg2 = 2^31*ecg2/max(ecg2);
    delta = ceil(max(ecg2+1)/n);

    %%
    di = zeros(n);
    for k = 1:length(ecg)-tau
        zx = 1 + floor( ecg2(k)/delta );
        zy = 1 + floor( ecg2(k + tau)/delta );
        %di(zx,zy) = di(zx,zy) + 1;
        di(zx,zy) = 1;
    end

    d = sum(sum(di))/(n*n);

    %%
    if(d>d0)
        if(echo)
            disp('VF confirmed');
        end
        SCA = true;
    else
        if(echo)
            disp('Normal sinus rhythm');
        end
        SCA = false;
    end

end
