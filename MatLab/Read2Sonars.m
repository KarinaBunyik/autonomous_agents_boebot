%fclose(s);
%delete(s);

%clear
%clc

s = serial('COM8','BaudRate',9600);
fopen(s);
low  = zeros(120,1);
high = zeros(120,1);
blueHandle = plot(-(-59:60),high);
hold on;
redHandle = plot(-(-59:60),low,'red');
fscanf(s,'%u');
oldAngle = fscanf(s,'%u');
oldAngle = oldAngle(1);

decay = 1;
for i = 1:10000
    reading = fscanf(s,'%u');
    angle = reading(1)+1;
    
    if angle > 120
        angle = 120;
    end
    
    if angle > oldAngle
        low(oldAngle+1:angle) = (1-decay)*low(oldAngle+1:angle)+...
                                       decay*reading(2);
        high(oldAngle+1:angle) = (1-decay)*high(oldAngle+1:angle)+...
                                       decay*reading(3);
    elseif angle < oldAngle
        low(angle:oldAngle-1) = (1-decay)*low(angle:oldAngle-1)+...
                                       decay*reading(2);
        high(angle:oldAngle-1) = (1-decay)*high(angle:oldAngle-1)+...
                                       decay*reading(3);
    end
    oldAngle = angle;
    set(blueHandle,'YData',high)
    set(redHandle,'YData',low)
    ylim([0 320])
    drawnow;
end
hold off;
fclose(s);
delete(s);