function d = get_data(c, s1)
    %% Send command to device
    if(~isnan(c))
        fwrite(s1,c);
    end
    
    %% Wait for a reply
    t = tic;
    while(s1.BytesAvailable == 0)
        % Timeout 5sec
        if(toc(t) > 6)
            d = NaN;
            % Received no reply
            return;
        end
    end
    
    %% Read data
    n = 0;
    
    % Read until there are available bytes
    while(true)
        % Read
        data = fread(s1,s1.BytesAvailable);
        l = length(data);
        
        if( c == 'K' || c == 'I' )
            % K and I directly print a string
            d((n + 1) : (n + l) ) = data;
            n = n + l;
        else
            % In any other case data is sent as 2 Byte word (LSB first)
            d((n + 1) : floor(n + l/2) ) = byte2word(data);
            n = n + l/2;
        end
        
        % If data size is less than maximum data size the transfer is over
%         if( l<512 )
%             return;
%         end
        
        % If no new data is available in 500ms the transfer is over
        t = tic;
        while(s1.BytesAvailable == 0)
            if(toc(t) > 1)
                return;
            end
        end
        
    end

end