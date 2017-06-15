function [ecgf] = OAED_FiltECG(ecg, fs, hp, lp, notch)
    %% Default parameters
    if(nargin < 5)
        notch = false;
    end
    if(nargin < 4)
        lp = 40;
    end
    if(nargin < 3)
        hp = 3;
    end
    if(nargin < 2)
        return;
    end

    %% apply biquad HP iir filter
    [zhi,phi,khi] = butter(2, hp/(2*fs),'high'); % 2nd order
    soshi = zp2sos(zhi,phi,khi);
    ecgf = sosfilt(soshi, ecg);

    %% apply biquad LP iir filter
    [zhi,phi,khi] = butter(4, lp/(2*fs),'low'); % 4th order
    soshi = zp2sos(zhi,phi,khi);
    ecgf = sosfilt(soshi, ecgf);

    return; % notch still need testing
    %% apply biquad notch iir filter
    if(notch)
        [zhi,phi,khi] = butter(2, [40 60]/(2*fs),'stop'); % 2nd order
        soshi = zp2sos(zhi,phi,khi);
        ecgf = sosfilt(soshi, ecgf);
    end

end
