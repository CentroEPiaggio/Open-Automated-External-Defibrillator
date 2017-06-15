function [SCA, result, values ] = OAED_RhythmEvaluation(ecg, ...
                                                        fs, ...
                                                        PlotEval, ...
                                                        PlotResults, ...
                                                        wl)

    %% set default arguments
    switch nargin
        case 2
            PlotEval = false;
            PlotResults = false;
            wl = 4;
        case 3
            PlotResults = false;
            wl = 4;
        case 4
            wl = 4;
        otherwise
            disp('Input arguments are:')
            disp('*Ecg array 1xn;')
            disp('*fs sampling frequency;')
            disp('Plot Evaluation results (default false);')
            disp('Plot individual results (default false);')
            disp('Window lenght (default 4);')
            disp('* are mandatory')
            return;
    end

    %% init
    m = floor( length(ecg)/(wl*fs) ); % m = number of wl window
    % result init
    TCIm = zeros(1, m);
    VF = zeros(1, m);
    TCSC = zeros(1, m);
    PSR = zeros(1, m);
    HIL = zeros(1, m);
    SCA = zeros(5, m);
    % values init
    TCI = zeros(m, 2*wl - 2);
    TCSCN = zeros(m, 2*wl - 2);
    dPSR = zeros(40, 40, m);
    dHILB = zeros(40, 40, m);
    old = [];       % TCI and TCSC also use the last ecg segment

    %% Evaluate each window
    for k = 1:m
        % Take the k-th, wl ECG window
        ecgw = ecg( (k-1) * wl*fs + 1 : k * wl*fs );

        [SCA(1,k), TCIm(k), tmp] = OAED_TCI([old ecgw], fs);
        if(k == 1)
            TCI(k,:) = [zeros(1, wl) tmp'];
        else
            TCI(k,:) = tmp';
        end
        [SCA(2,k), VF(k)] = OAED_VFfilter(ecgw, fs);
        [SCA(3,k), TCSC(k), tmp] = OAED_TCSC([old ecgw], fs);
        if(k == 1)
            TCSCN(k,:) = [zeros(1, wl) tmp'];
        else
            TCSCN(k,:) = tmp';
        end
        [SCA(4,k), PSR(k), dPSR(:,:,k)] = OAED_PSR(ecgw, fs);
        [SCA(5,k), HILB(k), dHILB(:,:,k)] = OAED_HILB(ecgw, fs);
        old = ecgw;
    end
    %% set result and individual values in a more compact list
    result = {TCIm, VF, TCSC, PSR, HILB};
    values = {TCI, TCSCN, dPSR, dHILB};

    %% plot evaluation
    if( PlotEval )
        te = [ 0 : length(ecg)-1 ]/fs;
        te2 = [ 0 : length(SCA)-1 ];
        scale = 10;
        figure, hold on, grid on,
        plot(te, scale * ecg/max(ecg) ), % ECG
        plot( (te2 + 0.5)*wl, sum(SCA,1), '*', 'LineWidth', 3), % Sum
        plot( (te2 + 0.1)*wl, 5*SCA(1,:), 'o', 'LineWidth', 3), % TCI
        plot( (te2 + 0.3)*wl, 5*SCA(2,:), 'o', 'LineWidth', 3), % VF filter
        plot( (te2 + 0.5)*wl, 5*SCA(3,:), 'o', 'LineWidth', 3), % TCSC
        plot( (te2 + 0.7)*wl, 5*SCA(4,:), 'o', 'LineWidth', 3), % PSR
        plot( (te2 + 0.9)*wl, 5*SCA(5,:), 'o', 'LineWidth', 3), % HILB
        legend('ECG', 'Total positive', 'TCI', 'VF', 'TCSC', 'PSR', 'HILB'),
        set(gca, 'xtick', [0: wl : floor(te(end)) + 1] ),
        set(gca, 'ytick', (0:1:5) ),
        title('Rhythm evaluation results'),
        hold off;
    end

    %% plot individual results
    if( PlotResults )
        te = [ 0 : length(ecg)-1 ]/fs;
        % TCI
        OAED_RecognitionPlot(te, ecg, 0.4, TCIm, 1000);
        title('TCI individual results')
        legend('ECG', 'Threshold', 'TCI');
        % VF filter
        OAED_RecognitionPlot(te, ecg, 0.625, VF, 1);
        title('VF individual results')
        legend('ECG', 'Threshold', 'VF');
        % TCSC
        OAED_RecognitionPlot(te, ecg, 0.48, TCSC, 100);
        title('TCSC individual results')
        legend('ECG', 'Threshold', 'TCSC');
        % PSR
        OAED_RecognitionPlot(te, ecg, 0.2, PSR, 1);
        title('PSR individual results')
        legend('ECG', 'Threshold', 'PSR');
        % HILB
        OAED_RecognitionPlot(te, ecg, 0.25, HILB, 1);
        title('HILB individual results')
        legend('ECG', 'Threshold', 'HILB');
    end

    return;
end
