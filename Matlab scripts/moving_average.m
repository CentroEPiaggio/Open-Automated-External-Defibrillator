function y = moving_average(x, n)

    m = (n-1)/2;

    y = zeros(size(x));
    for k = 1+m:length(x)-m
        y(k) = sum(x(k-m:k+m))/n;
    end

end