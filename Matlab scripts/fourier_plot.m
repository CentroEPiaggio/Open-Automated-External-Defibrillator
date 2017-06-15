function fourier_plot(sig, f, nf)

    if(nargin == 1)
        f = 500;
    elseif (nargin < 3)
        nf = 2^ceil(3+log2(length(sig)));
    end

    sig_fshift = fftshift(abs(fft(sig', nf)));
    nl = length(sig_fshift);
    df = f / (nl);
    fk = df * (-nl/2:nl/2-1);
    % figure, plot(fk,sig_fshift)
    figure, plot(fk,20*log10(sig_fshift))
end
