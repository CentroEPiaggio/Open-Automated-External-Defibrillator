function [SCA, d, di] = OAED_HILB(ecg, fs, echo)

    if(nargin == 2)
        echo = false;
    end
    d0 = 0.25;
    n = 40;

    %%
    ecg = 2^31*ecg/max(ecg);
    ecgh = hilbert(ecg, 2^ceil(log2(4*fs)));
    ecg1 = ecgh - min(real(ecgh)) - min(imag(ecgh))*1i;
    deltax = ceil(max(real(ecg1)+1)/n);
    deltay = ceil(max(imag(ecg1)+1)/n);
    
    %%
    di = zeros(n);
    for k = 1:length(ecg1)
        zx = 1 + floor( real(ecg1(k))/deltax );
        zy = 1 + floor( imag(ecg1(k))/deltay );
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
