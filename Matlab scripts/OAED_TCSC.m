function [SCA, Na, N] = OAED_TCSC(ecg, fs, echo)
%%

    if(nargin == 2)
        echo = false;
    end
    Ls = 3;
    Le = length(ecg)/fs;
    ns = Ls * fs;
    m = Le - Ls + 1;
    %ne = length(ecg);

%% Split signals
    ECGsplitted = zeros(m,ns);
    for k = 0:m-1
        ECGsplitted(1+k,:) = ecg( 1 + k*fs : (k+Ls) * fs );
    end

%% Cosine window
    Lw = 0.25;
    nw = floor(Lw*fs);
    W1 = 0.5*(1 - cos(4*pi*(0:1/fs:Lw-1/fs)));
    W2 = 0.5*(1 - cos(4*pi*(1/fs+Ls-Lw:1/fs:Ls)));

    ECGfiltered = ECGsplitted;
    for k = 1:m
        ECGfiltered(k, 1:nw) = ECGsplitted(k, 1:nw).*W1;
        ECGfiltered(k, end-nw +1:end) = ECGsplitted(k, end-nw +1:end).*W2;
    end

%% Binarization
    binaryECG = zeros(m,ns);
    for k = 1:m
        binaryECG(k,:) = ( abs(ECGfiltered(k,:)) > 0.2 * max( abs(ECGfiltered(k,:)) ) );
    end

%% N calculus
    N = zeros(m,1);
    for k = 1:m
        N(k) = sum(binaryECG(k,:))/ns * 100;
    end
    Na = sum(N)/(m);

%% Rhythm evaluation
    % 25 < Nd < 35 for more sensibility
    Nd = 48; % High specificity
    if( Na>=Nd )
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
