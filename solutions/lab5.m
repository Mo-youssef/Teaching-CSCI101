%% problem 1
x = input('enter number ');
y = input('enter number ');
z = input('enter number ');
if x<y
    if y<z
        fprintf('%d %d %d',x,y,z);
    else
        if x<z
            fprintf('%d %d %d',x,z,y);
        else
            fprintf('%d %d %d',z,x,y);
        end
    end
else
    if x<z
        fprintf('%d %d %d',y,x,z);
    else
        if y<z
            fprintf('%d %d %d',y,z,x);
        else
            fprintf('%d %d %d',z,y,x);
        end
    end   
end
fprintf('\n');
%% p1 selection
A = input('enter numbers ');
for i=1:length(A)
    s = A(i);
    si = i;
    for j = i:length(A)
        if A(j) < s
            s = A(j);
            si = j;
        end
    end
    A(si) = A(i);
    A(i) = s;
end
A
%% p1 bubble
A = input('enter numbers ');
for i=1:length(A)
    f = 1;
    for j = 1:length(A)-i
        if A(j) > A(j+1)
            s = A(j);
            A(j) = A(j+1);
            A(j+1) = s;
            f = 0;
        end
    end
    if f
        break;
    end
end
A
%% problem 2
A = input('enter array ');
H = -inf;
L = inf;
f = 0;
for i = 1:length(A)
    if rem(A(i),2) == 0
        f = 1;
        if A(i)>H
            H = A(i);
        end
        if A(i)<L
            L = A(i);
        end
    end
end
if f==0
    disp('No Even Numbers');
else
    fprintf('Range is from %d to %d\n',L,H);
end
%% problem 3
w = input('enter weight: ');
f = 1;
i=1;
while i<5 && w<0
    disp('Invalid weight');
    w = input('enter weight: ');
    i=i+1;
end
if w <0
    disp('Invalid weight');
    f = 0;
else
    i=0;
    while i<5
        u = input('Enter weight unit (1 for mg, 2 for kg, 3 for ton): ');
        f=0;
        disp('Invalid unit');
        if u>=1 && u<=3
            f = 1;
            break;
        end
        i=i+1;
    end
    if u==1
        g = w/1000;
        s = "mg";
    elseif u==2
        g = w*1000;
        s = "kg";
    elseif u==3
        g = w*1e6;  
        s = "ton";
    end
end
if f
    fprintf('%d\nConverting %s to gram\n%d\n',w,s,g);
end
%% problem 4
clear;
cc = input('enter coefficients ');
a = cc(1); b = cc(2); c = cc(3);
if a==0 && b==0 && c==0
    disp('Any x is a solution');    
elseif a==0
    if b==0 
        disp('No solution');
    else
        disp(-c/b);
    end
else
    disp((-b+sqrt(b^2-4*a*c))/(2*a));
    disp((-b-sqrt(b^2-4*a*c))/(2*a));
end
%% problem 5
A = input('enter grades ');
l = length(A);
res(5) = 0;
f=1;
for i = 1:l
    if A(i)>100
        disp('Invalid grade');
        f=0;
    elseif A(i)>=85
        res(1) = res(1)+1;
    elseif A(i)>=75
        res(2) = res(2)+1;
    elseif A(i)>=65
        res(3) = res(3)+1;
    elseif A(i)>=50
        res(4) = res(4)+1;
    elseif A(i)>=0
        res(5) = res(5)+1;
    else 
        disp('Invalid grade');
        f=0;
    end
end
if f
    disp(res);
end
%% problem 6
t = input('enter time ');
v = -0.48*t^3 + 36*t^2 - 760*t + 4100;
v = v/1000;
a = -0.12*t^4 + 12*t^3 - 380*t^2 + 4100*t + 220;
a = a/1000;
fprintf('Altitude (KMs)\n%.3f\nVeloctiy(KMs/hour)\n%.3f\n',a,v);