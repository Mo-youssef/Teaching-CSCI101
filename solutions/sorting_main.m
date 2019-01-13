%% 
% mergesort
xx = randi(1e5,1,1e5);
x = xx;
tic  
y = mergesort(xx);
toc
tic 
y2 = sort(xx);
toc
tic 
for i=1:length(x)
    for j = 1:length(x)-i
        if x(j) > x(j+1)
            s = x(j);
            x(j) = x(j+1);
            x(j+1) = s;
        end
    end
end
toc