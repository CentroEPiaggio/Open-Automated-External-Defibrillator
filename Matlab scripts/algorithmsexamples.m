load data.mat

%% TCI
%% Starting data
f1 = figure; plot(t, ecg)
grid on, set(gca, 'xtick', [0:4:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('ECG - Normal sinus rhythm (NSR)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')

f2 = figure; plot(t, patecg)
grid on, set(gca, 'xtick', [0:4:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('ECG - Sudden Cardiac Arrest (SCA)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')

pause();

%% Specific windows
ecgw = ecg(8000:9999);
patecgw = patecg(8000:9999);
tw = 16+[0:1999]/500;

figure(f1), hold on, plot(tw, ecgw), hold off
savefig(f1, [f1.CurrentAxes.Title.String '2'])
saveas(f1, [f1.CurrentAxes.Title.String '2'], 'png')
figure(f2), hold on, plot(tw, patecgw), hold off
savefig(f2, [f2.CurrentAxes.Title.String '2'])
saveas(f2, [f2.CurrentAxes.Title.String '2'], 'png')
pause();

figure(f1), plot(tw, ecgw)
grid on, set(gca, 'xtick', [0:1:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('NSR - 4 second window (TCI)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')

figure(f2), plot(tw, patecgw)
grid on, set(gca, 'xtick', [0:1:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('SCA - 4 second window (TCI)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')

pause();

%% Threshold
figure(f1), hold on
figure(f2), hold on

for k = 1:4
    maxnsr(k) = max( ecgw(1 + (k-1)*500:k*500 ) );
    maxpat(k) = max( patecgw(1 + (k-1)*500:k*500 ) );
    figure(f1), plot( 16 + [k-1 k], [1 1] * maxnsr(k)*0.2, 'g', ...
        'LineWidth', 2),
        plot( tw( find(maxnsr(k) == ecgw) ) , maxnsr(k), 'r*' )
    figure(f2), plot( 16 + [k-1 k], [1 1] * maxpat(k)*0.2, 'g', ...
        'LineWidth', 2),
        plot( tw( find(maxpat(k) == patecgw) ) , maxpat(k), 'r*' )
end

figure(f1), hold off
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('NSR - Binarization (TCI)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')

figure(f2), hold off
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('SCA - Binarization (TCI)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')

pause();

%% Binarization
binnsr = ecgw*0;
binpat = ecgw*0;
for k = 1:4
    binnsr(1+(k-1)*500:k*500) = (ecgw(1 + (k-1)*500:k*500 ) > (0.2*maxnsr(k)) );
    binpat(1+(k-1)*500:k*500) = (patecgw(1 + (k-1)*500:k*500 ) > 0.2*maxpat(k) );
end

figure(f1), plot(tw, binnsr), ylim([0 1.2])
grid on, set(gca, 'xtick', [0:1:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('Binary [a.u.]')
xlabel('time [s]')
title('NSR - Binary ECG (TCI)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(tw, binpat), ylim([0 1.2])
grid on, set(gca, 'xtick', [0:1:36] ), set(gca, 'ytick', [] )
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
ylabel('Binary [a.u.]')
xlabel('time [s]')
title('SCA - Binary ECG (TCI)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')

pause()
%% END of TCI


%% VF
Tnsr = floor(1 + 2*pi * (sum(abs(ecgw))/ sum( abs(ecgw - [0 ecgw(1:end-1)] ))));
Tpat = floor(1 + 2*pi * (sum(abs(patecgw))/ sum( abs(patecgw - [0 patecgw(1:end-1)] ))));

Tnsr = Tnsr/2; Tpat = Tpat/2;

VFnsr = abs( ecgw(Tnsr+1:end) + ecgw(1:end-Tnsr) );
VFnsr = VFnsr/sum( abs(ecgw(Tnsr+1:end)) + abs(ecgw(1:end-Tnsr)) );
VFpat = abs( patecgw( Tpat+1:end) + patecgw(1:end-Tpat) );
VFpat = VFpat/sum( abs ( patecgw( Tpat+1:end)) + abs(patecgw(1:end-Tpat)) );

figure(f1), plot(tw(Tnsr+1:end), VFnsr)
ylabel('Residual values [a.u.]')
xlabel('time [s]')
title('NSR - VF filter')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(tw(Tpat+1:end), VFpat)
ylabel('Residual values [a.u.]')
xlabel('time [s]')
title('SCA - VF filter')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')

pause()
figure(f1), hold on, plot(tw(Tpat+1:end),VFpat,'r'), hold off
ylabel('Residual values [a.u.]')
xlabel('time [s]')
title('Comparison between SCA and NSR ECG (VF filter)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
pause();
%% End of VF


%% TCSC
ecgw = ecg(8000:9499);
patecgw = patecg(8000:9499);
tw = 16+[0:1499]/500;

figure(f1), plot(tw, ecgw)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('NSR - 3 second window (TCSC)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(tw, patecgw)
ylabel('ECG [a.u.]')
xlabel('time [s]')
title('SCA - 3 second window (TCSC)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause();

figure(f1), plot(tw, abs(ecgw))
ylabel('|ECG| [a.u.]')
xlabel('time [s]')
title('NSR - Absolute values 3 second window (TCSC)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(tw, abs(patecgw))
ylabel('|ECG| [a.u.]')
xlabel('time [s]')
title('SCA - Absolute values 3 second window (TCSC)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause();

figure(f1), hold on
plot(tw(find(abs(ecgw) == max(abs(ecgw)))), max(abs(ecgw)), 'r*')
plot( [16 19], [1 1] * max(abs(ecgw))*0.2, 'g', 'LineWidth', 2)
title('NSR - Binarization (TCSC)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
hold off
figure(f2), hold on
plot(tw(find(abs(patecgw) == max(abs(patecgw)))), max(abs(patecgw)), 'r*')
plot( [16 19], [1 1] * max(abs(patecgw))*0.2, 'g', 'LineWidth', 2)
title('SCA - Binarization (TCSC)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
hold off
pause();

binnsr = (abs(ecgw) > ( 0.2*max(abs(ecgw)) ) );
binpat = (abs(patecgw) > ( 0.2*max(abs(patecgw)) ) );

figure(f1), plot(tw, binnsr), ylim([0 1.2])
ylabel('Binary [a.u.]')
xlabel('time [s]')
title('NSR - Binary ECG (TCSC)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(tw, binpat), ylim([0 1.2])
ylabel('Binary [a.u.]')
xlabel('time [s]')
title('SCA - Binary ECG (TCSC)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause()
%% End of TCSC


%% PSR
ecgw = ecg(8000:2:9999);
patecgw = patecg(8000:2:9999);
tw = 16+[0:1999]/250;
tau = 250*0.5;

figure(f1), plot(ecgw(1:end-tau), ecgw(tau+1:end))
xlabel('ECG(t) [a.u.]')
ylabel('ECG(t+\tau) [a.u.]')
title('NSR - Phase space diagram (PSR)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(patecgw(1:end-tau), patecgw(tau+1:end))
xlabel('ECG(t) [a.u.]')
ylabel('ECG(t+\tau) [a.u.]')
title('SCA - Phase space diagram (PSR)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause()

figure(f1), grid on
xlim([min(ecgw) max(ecgw)]), ylim([min(ecgw) max(ecgw)])
set(gca, 'xtick', [min(ecgw):(max(ecgw)-min(ecgw))/40:max(ecgw)] )
set(gca, 'xticklabel', [])
set(gca, 'ytick', [min(ecgw):(max(ecgw)-min(ecgw))/40:max(ecgw)] )
set(gca, 'yticklabel', [])
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
title('NSR - Phase space diagram with 40x40 grid (PSR)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), grid on
xlim([min(patecgw) max(patecgw)]), ylim([min(patecgw) max(patecgw)])
set(gca, 'xtick', [min(patecgw):(max(patecgw)-min(patecgw))/40:max(patecgw)] )
set(gca, 'xticklabel', [])
set(gca, 'ytick', [min(patecgw):(max(patecgw)-min(patecgw))/40:max(patecgw)] )
set(gca, 'yticklabel', [])
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
title('SCA - Phase space diagram with 40x40 grid (PSR)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause()

[SCA, d, di] = OAED_PSR(ecgw, 250);
figure(f1), image(di'*255)
set(gca,'YDir','normal')
title('NSR - Binary representation (PSR)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
[SCA, d, di] = OAED_PSR(patecgw, 250);
figure(f2), image(di'*255)
set(gca,'YDir','normal')
title('SCA - Binary representation (PSR)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
clear SCA d di
pause();
%% END of PSR


%% HILB
hecgw = hilbert(ecgw, 1024);
hpatecgw = hilbert(patecgw, 1024);
figure(f1), plot(hecgw)
xlabel('ECG(t) [a.u.]')
ylabel('ECG_{H}(t) [a.u.]')
title('NSR - Analytic signal (HILB)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), plot(hpatecgw)
xlabel('ECG(t) [a.u.]')
ylabel('ECG_{H}(t) [a.u.]')
title('SCA - Analytic signal (HILB)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause()

figure(f1), grid on
xlim([min(real(hecgw)) max(real(hecgw))])
ylim([min(imag(hecgw)) max(imag(hecgw))])
set(gca, 'xtick', [min(real(hecgw)):(max(real(hecgw)) ...
    - min(real(hecgw)))/40:max(real(hecgw))] )
set(gca, 'xticklabel', [])
set(gca, 'ytick', [min(imag(hecgw)):(max(imag(hecgw)) ...
    - min(imag(hecgw)))/40:max(imag(hecgw))] )
set(gca, 'yticklabel', [])
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
title('NSR - Analytic signal with 40x40 grid (HILB)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
figure(f2), grid on
xlim([min(real(hpatecgw)) max(real(hpatecgw))])
ylim([min(imag(hpatecgw)) max(imag(hpatecgw))])
set(gca, 'xtick', [min(real(hpatecgw)):(max(real(hpatecgw)) ...
    - min(real(hpatecgw)))/40:max(real(hpatecgw))] )
set(gca, 'xticklabel', [])
set(gca, 'ytick', [min(imag(hpatecgw)):(max(imag(hpatecgw)) ...
    - min(imag(hpatecgw)))/40:max(imag(hpatecgw))] )
set(gca, 'yticklabel', [])
set(gca, 'GridAlpha', 0.50), set(gca, 'LineWidth', 1.50)
title('SCA - Analytic signal with 40x40 grid (HILB)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause()

[SCA, d, di] = OAED_HILB(ecgw, 250);
figure(f1), image(di'*255)
set(gca,'YDir','normal')
title('NSR - Binary representation (HILB)')
savefig(f1, [f1.CurrentAxes.Title.String])
saveas(f1, [f1.CurrentAxes.Title.String], 'png')
[SCA, d, di] = OAED_HILB(patecgw, 250);
figure(f2), image(di'*255)
set(gca,'YDir','normal')
title('SCA - Binary representation (HILB)')
savefig(f2, [f2.CurrentAxes.Title.String])
saveas(f2, [f2.CurrentAxes.Title.String], 'png')
pause();
%% END of HILB

clear
close all
