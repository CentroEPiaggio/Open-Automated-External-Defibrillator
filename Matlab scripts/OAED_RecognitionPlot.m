function OAED_RecognitionPlot(te, ecg, threshold, c, cmax, wl)
    if(nargin == 4)
        cmax = max(c);
    end
    if(nargin < 6)
        wl = 4;
    end
    figure, hold on;
    plot( te, 2*ecg/max(ecg));
    plot( ones(1, ceil(te(end))) * threshold, 'LineWidth', 3);
    plot( (1:length(c))*wl, c/cmax, 'LineWidth', 2);
    hold off;
    return;
end