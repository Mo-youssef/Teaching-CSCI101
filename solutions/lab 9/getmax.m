function y = getmax()
y = input('enter maximum length in ft: ');
while y<=0 || rem(y,1)~=0
    y = input('ERROR!\nenter maximum length in ft: ');
end
end