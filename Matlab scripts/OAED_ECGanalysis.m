function [SCA, results, values, ecgf] = OAED_ECGanalysis(dat_list, n, suppress_plot)
%% Default parameters
if(nargin == 1)
    n = size(dat_list, 1);
end
if(nargin < 3)
    suppress_plot = false;
end

%% Loop
for k = 1:n
    time = tic;
    %% Load next signal
    disp([num2str(toc(time)) ' : Loading ' dat_list(k).name]);
    [ecg, fs, te] = rdsamp(dat_list(k).name, 1);
    ecg = ecg';
    te = te';
    disp([num2str(toc(time)) ' : Loaded']);

    %% apply biquad iir filter
    disp([num2str(toc(time)) ' : Filtering']);
    [ecgf] = OAED_FiltECG(ecg, fs, 3, 40);

    %% Perform rhythm evaluation
    disp([num2str(toc(time)) ' : Evaluating rhythm']);
    t = tic;
    [SCA, results, values] = OAED_RhythmEvaluation(ecgf, fs,...
                                                ~suppress_plot, ~suppress_plot);
    exectime = toc(t);
    disp([num2str(toc(time)) ' : Done']);

    %% Display numeric result
    disp([num2str(toc(time)) ' : Results']);
    disp(['Total execution time : ' num2str(toc(time))]);
    disp(['TCI                  : ' num2str(sum(SCA(1,:)))]);
    disp(['VF filter            : ' num2str(sum(SCA(2,:)))]);
    disp(['TCSC                 : ' num2str(sum(SCA(3,:)))]);
    disp(['PSR                  : ' num2str(sum(SCA(4,:)))]);
    disp(['HILB                 : ' num2str(sum(SCA(5,:)))]);
    disp(['SCA evauation'])
    disp(['At least 2 positive  : ' num2str(length(find(sum(SCA) >= 2)))])
    disp(['At least 3 positive  : ' num2str(length(find(sum(SCA) >= 3)))])
    disp(['At least 4 positive  : ' num2str(length(find(sum(SCA) >= 4)))])
    disp(['5 positive           : ' num2str(length(find(sum(SCA) == 5)))])

    if( k ~= n)
        disp('Press enter to move to the next signal');
    else
        disp('Press enter to finish');
    end
    pause();

end
