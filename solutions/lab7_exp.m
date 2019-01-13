clc;
x = input('enter ','s');
fw = length(x)+4;
fprintf('%-*s%-*s%-*s\n',fw,'Num',fw,x,fw,'Cube');
for i = 1:3
    fprintf('%-*d%-*d%-*d\n',fw,i,fw,i^2,fw,i^3);
end
%%
clc
for i = 1:5
    s = sprintf('enter number %d ',i);
    x = input(s);
end
%%
f = fopen('test.txt','w');
s = fopen('sin.txt','w');
fprintf(s,'hello from matlab');
fclose(f);
fclose(s);

%%
clear
x = [-3:0.1:3];
y = x.^2;
plot(x,y,'o')
%%

X = -30:0.1:30;
Y = sin(X);
plot(X,Y);
%%
clc;
x = input('enter num ');
fw = 11;
fprintf('%-*s%-*s%-*s\n',fw,'Num',fw,'Square',fw,'Cube');
for i = 1:x
    fprintf('%-*f%-*d%-*d\n',fw,i,fw,i^2,fw,i^3);
end


%%
clc
x = input('enter string','s');
fw = length(x)+4;
fprintf('%-*s%-*s%-*s\n',fw,'Num',fw,x,fw,'cube');
for i=1:5
    fprintf('%-*d%-*d%-*d\n',fw,i,fw,i^2,fw,i^3);
end
%%
a = [1 2 3 4];
b = [5 6 7 8];
%%
clc
a = 1:5;
%a
%disp(a)
for i=1:length(a)-1
    fprintf('%d,',a(i));
end
fprintf('%d\n',a(i+1));

%%
clc
fw = 5;
fprintf('|%-*d|\n',fw,500);










