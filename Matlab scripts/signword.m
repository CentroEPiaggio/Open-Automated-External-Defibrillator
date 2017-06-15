% Convert from uint16 to int16
function d = signword(data)
    d = data;
    for k = 1:length(data)
            if(bitget(data(k),16) == 1)
                d(k) = -1 * int16( bitcmp( uint16(data(k)) ) ) -1;
            end
    end
end