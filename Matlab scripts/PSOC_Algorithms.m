function [SCA, EvalTime ] = PSOC_Algorithms(psoc, ecg, fs)
    %% Params
    if(nargin == 2)
        fs = 500;
    elseif( fs ~=500 )
        nf = floor(fs/500);
        ecg2 = zeros(length(ecg)*2, 1);


        % Optional - Scale up values
        ecg2(1:2:end) = int16( 2^15* ecg/max(ecg) );
        %ecg2(1:2:end) = int16(ecg);
        for k = 2:2:length(ecg2)-2
            ecg2(k) = ecg2(k-1) + ecg2(k+1);
            ecg2(k) = ecg2(k)/2;
        end
        ecg2 = ecg2';
        fs = 500;
    else
        ecg2 = ecg;
    end

    %% Init
    n = length(ecg2);
    m = 4 * 500;

    ns = floor(n/m);

    EvalTime = zeros(1,ns);
    SCA = zeros(5,ns);

    %% Transfer
    psoc.reload;
    for k = 1:ns
        psoc.message = ecg2( 1 + (k-1)*m : k*m );
        psoc.send;
        pause(0.1);
        %TCI1(k,:) = psoc.receive;
        %TCI2(k,:) = psoc.receive;
        SCA(:,k) = psoc.receive;
        EvalTime(k) = psoc.receive;


        % Feedback
        if(k == floor(ns/10))
            disp('10%');
        elseif( k == floor(ns*1/4))
            disp('25%');
        elseif( k == floor(ns/2))
            disp('50%');
        elseif( k == floor(ns*3/4))
            disp('75%');
        elseif( k == floor(ns*9/10))
            disp('90%');
        end

    end

end
