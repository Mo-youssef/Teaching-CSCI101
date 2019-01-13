clc
x=input('enter number ');
while x<0
    x = input('wrong enter again ');
end

%%
clc 
a = [3 2 5 1 2 2 3 3 2 1 2 3   4  4 4 4 ];
sum=0;
for i = 1:length(a)
    if a(i) == 5
        break;
    end
end
sum