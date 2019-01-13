%% problem1
x = input('enter number ');
if mod(x,2) == 0
    disp('even');
else
    disp('odd');
end
%% problem 2
n1 = input('enter N1 ');
n2 = input('enter N2 ');
s=0;
for i=n1:n2
    s = s + i;
end
fprintf('the summation is %d\ntheir average is %d\n',s,s/(n2-n1+1));
%% problem 3
n1 = input('enter N1 ');
n2 = input('enter N2 ');
if n1>n2
    t = n2;
    n2 = n1;
    n1 = t;
end
s=0;
for i=n1:n2
    s = s + i;
end
fprintf('the summation is %d\ntheir average is %d\n',s,s/(n2-n1+1));
%% problem 4
x = input('enter number ');
if x <= 0
    disp('not positive');
else
    disp((x*(x+1))/2);
end
%% problem 5
N = input('enter number of numbers ');
A = zeros(1,N);
n = 0;
s = 0;
for i = 1:N
    ss = sprintf('enter number %d \n',i);
    A(i) = input(ss);
    if A(i) > 6
        n = n+1;
        s = s+A(i);
    end
end
if n>0
    fprintf('the average is %d\n',s/n);
end
%% problem 6
N = input('enter number of numbers ');
e = 0;
o = 0;
for i = 1:N
    ss = sprintf('enter number %d \n',i);
    x = input(ss);
    if mod(x, 2) == 0
        e=e+1;
    else
        o = o+1;
    end
end
fprintf('even sum is %d\nodd sum is %d\n',e,o);
%% problem 7
N = input('enter N ');
s = 0;
for i = 0:N-1
    s = s + 2^i;
end
s2 = (1-2^N)/(1-2);
fprintf('geometric series sum is %d or %d\n',s,s2);
%% problem 8
X = input('enter X ');
Y = input('enter Y ');
s = 1;
for i = 1:Y
    s = s * X;
end
fprintf('%d ^ %d = %d\n',X,Y,s);
%% problem 9
dep = input('enter departure time as [hr min] ');
arr = input('enter arrival time as [hr min] ');
if arr(2)<dep(2)
    arr(1) = arr(1) - 1;
    arr(2) = arr(2) + 60;
end
diff = [arr(1)-dep(1), arr(2)-dep(2)];
fprintf('the trip time will be %d hours and %d minutes\n',diff(1),diff(2));















