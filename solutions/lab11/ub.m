function y = ub(x,k)
start = 1;
final = length(x);
while start < final
    mid = floor((start+final)/2);
    if x(mid)>k
        final = mid;
    else
        start = mid + 1; 
    end
end
y = start;
end