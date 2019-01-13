function y = lb(x,k)
start = 1;
final = length(x);
while start < final
    mid = floor((start+final)/2);
    if x(mid)<k
        start = mid+1;
    else
        final = mid; 
    end
end
y = start;
end