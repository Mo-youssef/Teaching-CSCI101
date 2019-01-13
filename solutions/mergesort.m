function y = mergesort(x)
    l = length(x);
    if l ==1
        y = x;
    else 
        h1 = mergesort(x(1:round(l/2)));
        h2 = mergesort(x(round(l/2)+1:end));
        nl = length(h1)+length(h2);
        res  = zeros(1,nl);
        ii = 1; jj = 1;
        for i = 1:nl
            if ii > length(h1)
                res(i:end) = h2(jj:end);
                break;
            end
            if jj > length(h2)
                res(i:end) = h1(ii:end);
                break;
            end
            if h1(ii)<h2(jj)
                res(i) = h1(ii);
                ii = ii+1;
            else 
                res(i) = h2(jj);
                jj = jj+1;
            end
        end
        y = res;
    end
end