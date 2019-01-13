function x = selectionsort(x)
for i = 1:length(x)
    min = x(i);
    for j = i:length(x)
        if x(j)<=min
            min = x(j);
            mini = j;
        end
    end
    t = x(i);
    x(i) = x(mini);
    x(mini) = t;
end
end