%% p12
c = input('Enter the temp in degrees C: ');
a = input('Do you want K or F? ','s');
if a=='F'
    fprintf('The temp in degrees %c is %.1f\n',a,(9/5)*c+32);
elseif a=='K'
    fprintf('The temp in degrees %c is %.1f\n',a,c+273.15);
end
%% p13
a = input('Input 2D array: ');
s = size(a);
sum = 0;
h = 0;
for i = 1:s(1)
    sum = sum + a(i,2);
    if a(i,2)>h
        h = a(i,2);
    end
end
avg = sum/s(1);
fprintf('Average Waiting Time = %.1f\n',avg);
fw = 10;
fprintf('%-*s%-*s\n',fw,'ID',fw,'Waiting');
for i = 1:s(1)
    if a(i,2)>avg
        fprintf('%-*d%-*d\n',fw,a(i,1),fw,a(i,2));
    end
end
%% p14
a = input('X= ');
p = input('UserPoint= ');
s = size(a);
h = inf;
Dist = zeros(1,s(1));
for i = 1:s(1)
    Dist(i) = sqrt((a(i,1)-p(1))^2+(a(i,2)-p(2))^2);
    if Dist(i) < h
        h = Dist(i);
        hi = i;
    end
end
fprintf('Dist = ');
fprintf('%.1f ',Dist);
fprintf('\nNearst point is %d\n',hi);
%% p15
disp('When prompted, enter a temp in degrees C in range -16 to 20.');
t = input('Enter a maximum temp: ');
while t<-16 || t>20
    t = input('Error! Enter a maximum temp: ');
end
fw = 6;
fprintf('%-*s%-*s\n',fw,'F',fw,'C');
for f = 0:5:80
    c = (5/9)*(f-32);
    if c > t
        break;
    end
    fprintf('%-*.1f%-*.1f\n',fw,f,fw,c);
end
%% p16
n = input('enter num ');
fw = 5;
for i = 1:n
    for j = 1:n
        fprintf('%-*d',fw,i*j);
    end
    fprintf('\n');
end
%% p17
n = input('enter num ');
fw = 5;
for i = 1:n
    for j = 1:i
        fprintf('%-*d',fw,i*j);
    end
    fprintf('\n');
end
%% p17.5
n = input('enter num ');
fw = 5;
for i = 0:n
    for j = 0:n
        fprintf('%-*d',fw,abs(i-j));
    end
    fprintf('\n');
end
%% p17.6
n = input('enter num ');
fw = 5;
for i = 0:n
    for j = 0:n
        fprintf('%-*d',fw,mod(j-i,n+1));
    end
    fprintf('\n');
end
%% p17.7
n = input('enter num ');
for i = 1:n
    for s = 1:n-i
        fprintf(' ');
    end
    for j = 1:i
        if j==1 
            c=1;
        else
            c=c*(i-j+1)/(j-1);
        end
        fprintf('%d ',c);
    end
    fprintf('\n');
end
%% p18
lg = input('Please enter the low grade: ');
while lg<0 || lg>100
    disp('Error: valid range is [0-100]');
    lg = input('Please enter the low grade: ');
end
hg = input('Please enter the high grade: ');
while hg<lg || hg>100
    fprintf('Error: valid range is [%d-100]\n',lg);
    hg = input('Please enter the high grade: ');
end
g = 1;
c = 0;
cb = 0;
h = 0;
while g>=0
    g = input('Enter Grade:');
    while g>100
        disp('Error: valid range is [0-100]');
        g = input('Enter Grade:');
    end
%     if g<0
%         break;
%     end
    c = c+1;
    if g>=lg && g<=hg
        cb = cb+1;
        if g>h
            h=g;
        end
    end
end
fprintf('Total number of entered grades = %d\n',c-1);
if cb
    fprintf('Number of entered grades between %d and %d = %d\n',lg,hg,cb);
    fprintf('Maximum entered grade between %d and %d = %d\n',lg,hg,h);
else
    fprintf('No grades entered between %d and %d\n',lg,hg);
end
disp('*** End of Program ***');