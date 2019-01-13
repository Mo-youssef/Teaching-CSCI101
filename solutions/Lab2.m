%% problem 1
clear;clc;
r = input('radius = ');
Area = pi*r^2;
disp(Area);
%% problem 2
clear;clc;
base = input('base = ');
height = input('height = ');
Area = 0.5*base*height;
fprintf('Area = %f\n', Area);
%% problem 3
clear;clc;
p1 = input('point 1 = ');
p2 = input('point 2 = ');
dis = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
fprintf('distance = %f\n', dis);
%% problem 4
clear;clc;
x = input('x = ');
y = input('y = ');
z = input('z = ');
avg = (x+y+z)/3;
fprintf('average = %d\n', avg);
%% problem 5
clear;clc;
w = input('weeks = ');
min = w*7*24*60;
disp(min);
%% problem 6
clear;clc;
h = input('hours = ');
d = h/24;
disp(d);
%% problem 7
clear;clc;
x = input('x = ');
y = input('y = ');
num = ceil(x/y);
fprintf('number of trays = %d\n', num);
%% problem 8
clear;clc;
n = input('N = ');
q = fix(n/7);
r = mod(n,7);
fprintf('number of full groups = %d\nremaining apples = %d\n', q,r);
%% problem 9
clear;clc;
n = input('N = ');
q = fix(n/1000);
r = mod(n,1000);
fprintf('number of kilograms = %d\nnumber of grams = %d\n', q,r);
%% problem 10
clear;clc;
Tc = input('temperature in celsius = ');
Tf = (9/5)*Tc + 32;
Tr = Tf + 459.67;
Tk = (5/9) * Tr;
fprintf('temperature in Kelvin = %d\n', Tk);
%% problem 11
clear;clc;
h = 5;
r = 2;
V = pi*r^2*h;
Rg = 2;
Rf = 2/7.5;
Ri = Rf*12^3;
t = V/Ri;
fprintf('time in seconds = %d\n', t*60*60);