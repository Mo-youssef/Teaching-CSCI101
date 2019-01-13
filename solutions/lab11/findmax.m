% This function takes 1D array x and returns the maximum value in it m and
% its index ind

function [m,ind] = findmax(x)

n = length(x);
m = -inf;
for i=1:n
    if m<x(i)
        m = x(i);
        ind = i;
    end
end

end