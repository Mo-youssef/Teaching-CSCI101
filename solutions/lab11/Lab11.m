%% Bubble sort
clear
clc

x1 = [34 2 5 15 89 23 100 1 13 8];
x2 = x1;
n = length(x2);
for i=1:n
    for j=1:n-i
        if x2(j)>x2(j+1)
            temp = x2(j);
            x2(j) = x2(j+1);
            x2(j+1) = temp;
        end
    end
end
disp(x1)
disp(x2)

%% Binary Search
clear
clc

x = [1 2 5 8 13 15 23 34 89 100];
key = 100;

min = 1;
max = length(x);
mid = floor((min+max)/2);
found = 0;

while max>=min
    if key==x(mid)
        ind = mid;
        min=max+1;
        found = 1;
    elseif key > x(mid)
        min = mid + 1;
        mid = floor((min+max)/2);
    elseif key < x(mid)
        max = max - 1;
        mid = floor((min+max)/2);
    else
        min=max+1;
    end
end

if found ==0
    fprintf('Sorry but %d is not found in the given array\n',key)
else
    fprintf('Your key %d was found at index %d\n',key,ind)
end

%% KNN
clear
clc

[data, txt, raw] = xlsread('KNN.xlsx');
k = 3;
classes = 2;

name = input('Please enter your full name: ','s');
w = input('Enter your weight in kg: ');
while w<20
    fprintf('Error! Seems that your weight should have a larger value\n')
    w = input('Enter your weight in kg: ');
end
h = input('Enter your height in cm: ');
while h>272
    fprintf('Wow! You should have registered for guinness world record!\n')
    h = input('Enter your height in cm: ');
end
v = input('Enter your vision out of 6: ');
while v<0 || v>6
    fprintf('Wrong number!\n')
    v = input('Enter your vision out of 6: ');
end

datatest = [h w v];

[r,c] = size(data);
dist = zeros(1,r);
for i=1:r
    distance=0;
    for j=1:c-1
        distance = distance + ((datatest(j)-data(i, j))^2);
    end
    dist(i) = sqrt(distance);
end
dist = [dist;1:r];
distnew = bubblesortk(dist,k);

results = zeros(1,classes);
for i=r-k+1:r
     results(data(distnew(2,i),c)) = results(data(distnew(2,i),c)) + 1;
end
[m,ind] = findmax(results);
fprintf('\n')
if ind==1
    fprintf('Dear %s,\nWe are sorry to inform you that you will not be admitted to the military!\n',name)
elseif ind==2
    fprintf('Dear %s,\nCongratulations, you will be successfully admitted to the military!\n',name)
end


