function x = bubblesort(x)
for i = 1:length(x)
    flag = 0;
    for j = 1:length(x)-i
        if x(j)>x(j+1)
            t = x(j);
            x(j) = x(j+1);
            x(j+1) = t;
            flag = 1;
        end
    end
    if flag == 0
        break
    end
end
end