global r
f = figure('KeyPressFcn', @mycallback);
while true
        disp(r);
    if ~ishandle(f)
        break;
    end
    pause(0.5)
end