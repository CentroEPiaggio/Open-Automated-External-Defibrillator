function L = byte2long(B)
    % Compose 4 Byte in 1 Word
    L = B(1:4:end);
    L = L + bitshift(B(2:4:end),8);
    L = L + bitshift(B(3:4:end),16);
    L = L + bitshift(B(4:4:end),24);

    % Recover the sign
    for k = 1:length(L)
        if(bitget(L(k),32) == 1)
            L(k) = -1 * int32( bitcmp( uint32(L(k)) ) ) -1;
        end
    end
    
    return;
end