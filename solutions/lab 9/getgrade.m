function y = getgrade(A)
y = repmat(' ',1,length(A));
for i = 1:length(A)
    if A(i)>=90
        y(i) = 'A';
    elseif A(i)>=80
        y(i) = 'B';
    elseif A(i)>=70
        y(i) = 'C';
    elseif A(i)>=50==60
        y(i) = 'D';
    elseif A(i)>=0
        y(i) = 'F';
    end
end
assert(length(y)==length(A))
end