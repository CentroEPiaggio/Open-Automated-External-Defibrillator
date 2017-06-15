function [SCA, TCIm, TCI] = OAED_TCI(ecg, fs, echo)
%% find n

    if(nargin == 2)
        echo = false;
    end
    nl = length(ecg);
    nsec = 1 * fs;
    n = nl/nsec;

%% find maximum

    maxECG = zeros(n,1);
    ecg2 = zeros(n,nsec);
    for k = 1:n
        ecg2(k,:) = ecg(1+ nsec*(k-1) : nsec*(k));
        maxECG(k) = max( ecg2(k,:) );
    end

%% binarize the ecg signal

    binaryECG = zeros(n,nsec);
    for k = 1:n
        if(maxECG(k) > 0)
            binaryECG(k,:) = ( ecg(1+ nsec*(k-1) : nsec*(k)) > (0.2 * maxECG(k)) );
        else
            binaryECG(k,:) = ( ecg(1+ nsec*(k-1) : nsec*(k)) > (1.8 * maxECG(k)) );
        end
    end

%	for k=1:4 TC([1:fs]+(k-1)*fs) = binaryECG(k,:); end
%	figure, hold on, plot([1:1000]/250,2*ecg/max(ecg),'LineWidth', 1), plot([1:1000]/250,TC,'LineWidth', 2)

%% t evaluation

    t = zeros(k,4);
    for k = 1:n
        if(binaryECG(k,1) == 1)
            t(k,2) = 0;
        else
            t(k,2) = (find(binaryECG(k,:) == 1, 1, 'first')-1) / fs ;
        end
        if(binaryECG(k,end) == 1)
            t(k,3) = 0;
        else
            t(k,3) = (nsec - find(binaryECG(k,:) == 1, 1, 'last')+1) / fs;
        end

        if ( k == 1 )
            continue;
        end
        t(k,1) = t(k-1,3);
        t(k-1,4) = t(k,2);
    end

%% N evaluation

    N = zeros(n-2,1);
    for k = 2:(n-1)
        for z = 1:nsec-1
            if( binaryECG(k,z) ~= binaryECG(k,z+1) )
                N(k-1) = N(k-1) + 1;
            end
        end
        N(k-1) = ceil(N(k-1)/2);
        if(t(k,2) == 0 && t(k,3) == 0)
            N(k-1) = N(k-1)+1;
        end
    end

%% TCI evaluation

    TCI = zeros(n-2,1);
    for k = 2:(n-1)
        if(t(k,1) ~= 0)
            t12 = t(k,2)/( t(k,1)+t(k,2) );
        else
            t12 = 0;
        end
        if(t(k,3) ~= 0)
            t34 = t(k,3)/( t(k,3)+t(k,4) );
        else
            t34 = 0;
        end
        TCI(k-1) = 1000 / ( N(k-1)-1 + t12 + t34 );
    end

%% Rhythm evaluation
    TCIm = mean(TCI);
    TCIcrit = 400; % TCI > 400ms => normal sinus rhythm (NSR)
    if(TCIm <= TCIcrit)
        muvf = 105;
        sigmavf = 6.5;

        muvt = 220;
        sigmavt = 16.5;

        alfa = 1 / 100;
        beta = 1 / 100;

        F = (1/sigmavf^2) * sum((TCI - muvf).^2) - (1/sigmavt^2) * sum((TCI - muvt).^2);
        FVT = 2*log((1-beta)/alfa) + 2*(k-2)*log(sigmavt/sigmavf);
        FVF = 2*log(beta/(1-alfa)) + 2*(k-2)*log(sigmavt/sigmavf);

        if(F >= FVT)
            if(echo)
                disp('VT confirmed');
            end
            SCA = true;
        elseif(F <= FVF)
            if(echo)
                disp('VF confirmed');
            end
            SCA = true;
        else
            if(echo)
                disp('Not enough data');
            end
            SCA = false;
        end
    else
        if(echo)
            disp('Normal sinus rhythm');
        end
        SCA = false;
    end
end
