function filtered = PSOC_Filter(signal)

    %% Init
    n = length(signal);
    time = tic;
    s1 = serial('COM6', 'Baudrate', 9600);
    fopen(s1);
    try
        fwrite(s1,'s');
    catch
        fclose(s1);
        delete(s1);
        filtered = NaN;
        return;
    end
    disp([int2str(toc(time)) ' : Waiting for a reply']);
    
    %% Wait for a reply
    t = tic;
    while(s1.BytesAvailable ~= 0)
        % Timeout 6sec
        if(toc(t) > 6)
            filtered = NaN;
            % Received no reply
            fclose(s1);
            delete(s1);
            return;
        end
    end
    disp([int2str(toc(time)) ' : Psoc is ready']);
    
    % Psoc is ready
    
    %% Start transmitting
    for k = 1:n
        try
            fwrite(s1, signal(k),'int16');
        catch
            fclose(s1);
            filtered = NaN;
            delete(s1);
            return;
        end
        while(s1.BytesAvailable ~= 0)
        end
    end
    
    disp([int2str(toc(time)) ' : Data transmitted correctly']);
    
    %% Start riceiving
    t = tic;
    while(s1.BytesAvailable == 0)
        % Wait for data processing
        
        % Timeout 10sec
        if(toc(t) > 10)
            filtered = NaN;
            % Received no reply
            fclose(s1);
            delete(s1);
            return;
        end
    end
    disp([int2str(toc(time)) ' : Started receiving data']);
    
    filtered = 0;
    while(true)
        try
            filtered = [filtered byte2word(fread(s1, s1.BytesAvailable))'];
        catch
            fclose(s1);
            delete(s1);
            display(filtered)
            filtered = NaN;
            return;
        end
        if(length(filtered) == n)
            break;
        elseif(length(filtered) == n+1)
            filtered = filtered(2:end);
            break;
        end
        
        t = tic;
        while(s1.BytesAvailable == 0)
            % Timeout 6sec
            if(toc(t) > 6)
                filtered = NaN;
                % Received no reply
                fclose(s1);
                delete(s1);
                display('Timeout');
                return;
            end
        end
    end
        
    fclose(s1);
    delete(s1);
    disp([int2str(toc(time)) ' : Finish']);

    return;
end