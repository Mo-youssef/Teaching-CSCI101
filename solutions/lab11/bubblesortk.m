% This function takes 2D array "unsorted" and uses bubble sort algorithm to 
% sort the minimum k elements and brings them at the end of the array along
% with the corresponding elements in the same column.

function x2 = bubblesortk(unsorted,k)

x2 = unsorted;  
n = length(x2);
for i=1:k
    for j=1:n-i
        if x2(1,j)<x2(1,j+1)
            temp = x2(:,j);
            x2(:,j) = x2(:,j+1);
            x2(:,j+1) = temp;
        end
    end
end

end