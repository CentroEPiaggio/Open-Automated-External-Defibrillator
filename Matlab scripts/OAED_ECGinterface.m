%clc

%%
n = 0;
m = 0;
if (1 ~= exist('ECG'))
    ECG = [];
end
while(true)

    in = input('in ');

    if(~psoc.reload)
        disp('Cannot reload psoc');
        break;
    end

    for k = 1:in
        psoc.message = 'a';
        psoc.send;
        pause(0.1);

        tmp = psoc.receive;
        ECG = [ECG tmp];
        tmp = psoc.receive;
        ECG = [ECG tmp];

%        tmp = psoc.receive;
%        Z = [Z tmp];
%        tmp = psoc.receive;
%        Z = [Z tmp];

        tmp = psoc.receive;
        disp(tmp);
        n = n+1;

        if(psoc.message == 'A')
            tmp = psoc.receive;
            raw = [raw tmp];
            m = m+1;
        end

        disp(n);
        t = [1:length(ECG)]/4000;
        plot(t, ECG)
    end

    break;
end

clear m n in k tmp
