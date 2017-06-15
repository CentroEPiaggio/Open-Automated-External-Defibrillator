% Custom plot function
function ecg_plot(ecg, name)
    n = size(ecg,1);
    te = [1:2000]/500;
    
    if(n == 1)
        plot(te,ecg);
        return;
    end
    
    for l = 1:ceil(n/6)
        figure
        m = (l-1)*6;
        for k = 1:min([6 n-m])
            subplot(3,2,k), plot(te,ecg(k+m,:))
            title([name '-' num2str((k+m))])
        end
    end
    return;
end