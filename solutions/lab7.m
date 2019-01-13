%% p5
N = input('enter no. ');
fprintf('%-6s%-6s%-6s%-6s\n','n','n2','n3','n4');
for i = 1:N
    fprintf('%-6d%-6d%-6d%-6d\n',i,i^2,i^3,i^4);
end
%%
s=sprintf('%d',1000);
%% p6
l = input('enter length array ');
w = input('enter width array ');
a = l.*w;
fw = 20;
fprintf('%2$-*1$s%3$-*1$s%4$-*1$s%5$-*1$s\n',fw,'Num','Length','Width','Area');
for i = 1:length(l)
    fprintf('%-*d%-*d%-*d%-*d\n',fw,i,fw,l(i),fw,w(i),fw,a(i));
end
%% p7
tc = input('enter length array ');
tf = (9/5).*tc + 32;
tr = tf+459.67;
tk = (5/9).*tr;
fw = 10;
fprintf('%2$-*1$s%3$-*1$s%4$-*1$s%5$-*1$s\n',fw,'Num','Cel','Fah','Kelvin');
for i = 1:length(tc)
    fprintf('%-*d%-*.2f%-*.2f%-*.2f\n',fw,i,fw,tc(i),fw,tf(i),fw,tk(i));
end
%% p8
clear;clc;
N = input('enter angle ');
a = -N:0.1:N;
s = sin((pi/180)*a);
plot(a,s);
f = fopen('sin.txt','w');
fw = 20;
fprintf(f,'%-*s%-*s\n',fw,'angle',fw,'sin');
for i = 1:length(a)
    fprintf(f,'%-*.1f%-*.2f\n',fw,a(i),fw,sin(i));
end
fclose(f);
%% p9
clear;clc;
cc = 'y';
while cc == 'y'
    m = input('Max grade: ');
    n = input('Total number of grades: ');
    s = 0;
    for i = 1:n
        ss = sprintf('Grade %d:',i);
        g = input(ss);
        while g<0 || g>m
            disp('Invalid Grade! Re-enter grade between 0 and Max');
            g = input(ss);
        end
        s = s+g;
    end
    avg = s/n;
    avg_per = avg/m;
    if avg_per>=0.85
        l = 'A';
    elseif avg_per>=0.75
        l = 'B';
    elseif avg_per>=0.65
        l = 'C';
    elseif avg_per>=0.50
        l = 'D';
    else 
        l = 'F';
    end
    fprintf('The average grade is %c = %.1f = %d%%\n',l,avg,round(avg_per*100));
    cc = input('Do you want to continue (y/n):','s');
end
disp('Good Bye!');



























