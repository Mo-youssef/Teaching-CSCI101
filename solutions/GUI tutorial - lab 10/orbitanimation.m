phi = linspace(0,2*pi,1000);
x = 5*cos(phi);
y = 4*sin(phi);
z = x+y;
figure('DoubleBuffer','on');
plot3(x,y,z);
l = 8;
axis([-l l -l l -l l])
hold on
[theta,phi] = ndgrid(linspace(0,pi),linspace(0,2*pi));
xx = 4*sin(theta).*cos(phi);
yy = 4*sin(theta).*sin(phi);
zz = 4*cos(theta);
surf(xx,yy,zz)
p = line('XData',x(1),'YData',y(1),'ZData',z(1),'Color','r','Marker','o');
i = 1;
while true      
    set(p,'XData',x(i),'YData',y(i),'ZData',z(i))       
    drawnow
    i = rem(i+1,1000)+1;            
    if ~ishandle(p), break; end      
end