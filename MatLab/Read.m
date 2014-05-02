%fclose(s);
%delete(s);

%clear
%clc

s = serial('COM8','BaudRate',9600);
fopen(s);
values = zeros(120,1);
plotHandle = plot(-(-59:60),values);
fscanf(s,'%u');
oldAngle = fscanf(s,'%u');
oldAngle = oldAngle(1);

decay = 1;
for i = 1:3000
    reading = fscanf(s,'%u');
    angle = reading(1)+1;
    
    if angle > 120
        angle = 120;
    end
    
    if angle > oldAngle
        values(oldAngle+1:angle) = (1-decay)*values(oldAngle+1:angle)+...
                                       decay*reading(2);% *ones(size(oldAngle+1:angle));
    elseif angle < oldAngle
        values(angle:oldAngle-1) = (1-decay)*values(angle:oldAngle-1)+...
                                       decay*reading(2);% *ones(size(oldAngle+1:angle));
    end
    oldAngle = angle;
        
    set(plotHandle,'YData',values)
    ylim([0 320])
    drawnow;
end

fclose(s);
delete(s);