clear
close all
clc

d = dir('*.mat');

n = 0;
in = input('giorno (gg-mm) : ','s');
for kk = 1:length(d)
    if(d(kk).name(3) == '-')
        if(~strcmp(d(kk).name(1:5),in) || length(d(kk).name) ~= 14)
            continue;
        end
        if(n ~= 0)
            if( strcmp( d(kk).name(1:10) , nfile(n,1:10) ) )
                continue;
            end
        end
        
        n = n+1;
        nfile(n,:) = d(kk).name(:);
        disp([num2str(n) ' - ' nfile(n,:)]);
        
    end
end

sav = in;
in = input('ora di inizio (hhmm) : ');
sav = [sav '-' num2str(in) '-' num2str(nfile(end,7:10)) '.mat'];

n = 0;
for kk = 1:length(nfile)
    if(nfile(kk,3) == '-')
        if( str2num(nfile(kk,7:10)) < in )
            continue;
        end
        lo = load(nfile(kk,:));
        n = n+1;
        serie(n).name = nfile(kk,7:10);
        serie(n).ecg = lo.ecg;
        serie(n).raw = lo.recg;
    end
end
save(sav,'serie');
clear d n in kk lo nfile