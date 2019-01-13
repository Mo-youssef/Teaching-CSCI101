function y = gethour(s)
fprintf('%s Time HH: ',s);
y = input('');
while y<0 || y>23
    fprintf('ERROR! Valid Range [0,24)\n%s Time HH: ',s);
    y = input('');
end 
end