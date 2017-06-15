function W = byte2word(B)
    % Compose 2 Byte in 1 Word
    W = B(1:2:end) + bitshift(B(2:2:end),8);

    % Recover the sign
    for k = 1:length(W)
        if(bitget(W(k),16) == 1)
            W(k) = -1 * int16( bitcmp( uint16(W(k)) ) ) -1;
        end
    end
    
    return;
end