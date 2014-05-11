try
    fclose(s);
    delete(s);
catch
end

%clear
%clc
clf

s = serial('COM8','BaudRate',9600);
fopen(s);
redone  = zeros(80,1);
blueone = zeros(80,1);
blueHandle = plot(-(-39:40),blueone);
hold on;
redHandle = plot(-(-39:40),redone,'red');
fscanf(s,'%u');
oldAngle = fscanf(s,'%u');
oldAngle = oldAngle(1);

decay = 1;
for i = 1:10000
    reading = fscanf(s,'%u');
    
    while s.BytesAvailable > 0
        fscanf(s,'%u');
    end
    
    angle = reading(1);
    
    if angle > 80
        angle = 80;
    end
    
    if angle > oldAngle
        redone(oldAngle+1:angle) = (1-decay)*redone(oldAngle+1:angle)+...
                                       decay*reading(2);
        blueone(oldAngle+1:angle) = (1-decay)*blueone(oldAngle+1:angle)+...
                                       decay*reading(3);
    elseif angle < oldAngle
        redone(angle:oldAngle-1) = (1-decay)*redone(angle:oldAngle-1)+...
                                       decay*reading(2);
        blueone(angle:oldAngle-1) = (1-decay)*blueone(angle:oldAngle-1)+...
                                       decay*reading(3);
    end
    oldAngle = angle;
    set(blueHandle,'YData',blueone)
    set(redHandle,'YData',redone)
    ylim([0 400])
    xlim([-50 50])
    ylabel('Distance')
    xlabel('Angle')
    legend('Wall','Cylinder')
    drawnow;
end
hold off;
fclose(s);
delete(s);