function write(x)
fprintf('%-10s%-10s\n','Foot','Meters');
for i = 1:x
    fprintf('%-10d%-10.1f\n',i,0.3048*i);
end
end