function y = getmin(s)
fprintf('%s Time MM: ',s);
y = input('');
while y<0 || y>59
    fprintf('ERROR! Valid Range [0,60)\n%s Time MM: ',s);
    y = input('');
end 
end