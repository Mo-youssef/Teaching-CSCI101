%% problem 1
A = input('enter array\n');
x = input('enter number ');
f = 0;
for i = 1:length(A)
    if A(i) == x
        if f == 0
            disp('value is found at:');
        end
        disp(i);
        f = 1;
    end
end
if f == 0
    disp ('Not Found'); 
end
%% problem 2
G = input('enter grades\n');
val = zeros(size(G));
inv=0;v=0;s=0;H=0;L=100;c=0;
for i = 1:length(G)
    if G(i) >= 0 && G(i) <= 100
        val(i) = 1;
        v = v + 1;
        s = s + G(i);
        fprintf('Student %d grade (%d) is ''valid''\n',i,G(i));
        if G(i) >= H
            H = G(i);
            Hi = i;
        end
        if G(i) <= L
            L = G(i);
            Li = i;
        end
        if G(i) >= 85
            c = c+1;
            fprintf('\tand his grade is above 85%%\n');
        end
        
    else
        fprintf('Student %d grade (%d) is ''invalid''\n',i,G(i));
        val(i) = 0;
        inv = inv+1;
    end
end
G
val
fprintf('\nNumber of invalid grades is %d\n\n',inv);
if v > 0
    avg = s/v;
    fprintf('Student %d has highest grade which is %d\n',Hi,H);
    fprintf('Student %d has lowest grade which is %d\n',Li,L);
    fprintf('Average grade: %d\n',avg);
    fprintf('Number of students above 85%%: %d\n\n',c);
    c = 0;
    for i = 1:length(G)
        if G(i) >= avg && val(i) == 1
            fprintf('Student %d has above average grade\n',i);
            c = c + 1;
        end
    end
    fprintf('Number of students above average: %d\n',c);
else
    disp('no valid grades');
end
%% problem 3
t = input('Please enter the threshold below which samples will be considered to be invalid: ');
N = input('Please enter the number of data samples to enter: ');
s = 0;
c = 0;
for i = 1:N
    x = input('Please enter a data sample: ');
    if x >= t
        c = c+1;
        s = s+x;
    end
end
if c>0
    fprintf('Valid samples\n%d\nAverage\n%d\n',c,s/c);
else
    disp('No valid samples');
end