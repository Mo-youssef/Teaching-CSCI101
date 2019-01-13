%% p1
f2c(0);
%% p2
d = getInput();
r = convertDeg(d);
showValue(r);
%% p4
x= input('enter degree ');
if x == 'K'
    disp(x);
end
%% p5
write(getmax())
%% p6
n = input('enter number of trips: ');
for i = 1:n
    fprintf('Trip %d:\n',i);
    dh = gethour('Depart');
    dm = getmin('Depart');
    th = gethour('Trip');
    tm = getmin('Trip');
    printarrival(dh,dm,th,tm);
end