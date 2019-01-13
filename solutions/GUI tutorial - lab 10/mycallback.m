function mycallback(aa, event)
global r;
switch event.Character
    case 'q'
        r = 1;
    case 30
        r = 'up';
    case 31
        r = 'down';
    case 29
        r = 'right';
    case 28
        r = 'left';
end