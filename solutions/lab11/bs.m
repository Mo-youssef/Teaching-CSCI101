function y = bs(x,k)
start = 1;
final = length(x);
f = 1;
while start <= final
    mid = floor((start+final)/2);
    if x(mid) == k
        y = mid;
        f = 0;
        break;
    elseif x(mid)>k
        final = mid - 1;
    else
        start = mid + 1; 
    end
end
if f
    y = -1;
end
end