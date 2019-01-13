function printarrival(dh,dm,th,tm)
m = dm+tm;
r = floor(m/60);
m = mod(m,60);
h = mod((dh+th+r),24);
fprintf('Arrival Time- %d:%d\n',h,m);
end