function [y] = OAED_ContinuousPlot(s1)
fh = figure;
lh = animatedline;
n = 0;
x = 0;

lh.Color = 'red';
lh.LineWidth = 0.1;

fwrite(s1,'C');

try
    while(isvalid(fh))
        while(s1.BytesAvailable == 0)
        end

        t = tic;
        data = fread(s1,s1.BytesAvailable);
        l = length(data);
        y(1 : floor(l/2) ) = byte2word(data);
        n = n + l/2;
        x = x(end) + (1:length(y))/4000;
        [xx,yy] = getpoints(lh);
        if(length(xx)>50000)
            clearpoints(lh);
            addpoints(lh,[xx(end-4000:end) x], [yy(end-4000:end) y]);
        else
            addpoints(lh,x,y)
        end
        xlim([ x(end)-1 x(end)]);
        drawnow limitrate
        toc(t)
    end
    fwrite(s1,'C');
catch
    fwrite(s1,'C');
end

end