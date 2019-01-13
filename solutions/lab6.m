%% p7
sum(1)=1;
i = 1;
while sum(i)<=10000
    i=i+1;
    sum(i) = sum(i-1)+i^2;
end
disp(i-1);
%% p2
n = input('enter a number ');
f = 1;
i = 1;
% note the equality in condition
while f<=1e6 && i<n
    i = i+1;
    f = f*i;
end
if f<=1e6
    disp(f)
else
    disp('factorial exceeds 1000000')
end
%% p2
n = input('enter a number ');
f = n;
% note the equality in condition
while f<=1e6 && n>1
    n = n-1;
    f = f*n;
end
if n<2
    disp(f)
else
    disp('factorial exceeds 1000000')
end
%% p3
a = input('enter array ');
b = input('enter array ');
if length(a) ~= length(b)
    disp('dim mismatch');
else
    disp(a-b);
end
%% p4
a = input('enter array ');
b = input('enter array ');
f = 0;
for i = 1:length(a)
    for j = 1:length(b)
        if a(i)==b(j)
            f = 1;
            break;
        end
    end
    if f
        break;
    end
end
if f
    disp('duplicate exists');
else
    disp('unique values');
end
%% p5
a = input('enter array ');
b = input('enter array ');
res = zeros(1,length(a));
for i = 1:length(a)
    c = 0;
    for j = 1:length(b)
        if a(i)==b(j)
            c=c+1;
        end
    end
    res(i) = c;
end
res
%%
x='y';
while x=='y'
    x = input('enter arr ');
    for i = 1:length(x)
        if x(i)<0 || x(i)>100
            x = 'y';
        end
    end
end
disp('finally');
























