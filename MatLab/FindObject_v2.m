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
lowSonar  = zeros(80,1);
highSonar  = zeros(80,1);
lowCoord = [0 0];
lowCoordHandle = plot(lowCoord(1),lowCoord(2),'x');
hold on;
highCoord = [0 0];
highCoordHandle = plot(highCoord(1),highCoord(2),'o');
lowHandle = plot(-(-39:40),lowSonar,'red');
highHandle = plot(-(-39:40),highSonar,'blue');
fscanf(s,'%d');
oldAngle = fscanf(s,'%d');
oldAngle = oldAngle(1);

for i = 1:10000
    reading = fscanf(s,'%d');
    
    while s.BytesAvailable > 0
        fscanf(s,'%d');
    end
    
    angle = reading(1);
    
    if angle > 80
        angle = 80;
    end
    
    lowCoord = [reading(4) reading(5)];
    highCoord = [reading(6) reading(7)];
    
    if angle > oldAngle
        lowSonar(oldAngle+1:angle) = reading(2);
        highSonar(oldAngle+1:angle) = reading(3);
    elseif angle < oldAngle
        lowSonar(angle:oldAngle-1) = reading(2);
        highSonar(angle:oldAngle-1) = reading(3);
    end
    oldAngle = angle;

    set(lowHandle,'YData',lowSonar)
    set(highHandle,'YData',highSonar)
    set(lowCoordHandle,'XData',-lowCoord(2))
    set(lowCoordHandle,'YData',lowCoord(1))
    set(highCoordHandle,'XData',-highCoord(2))
    set(highCoordHandle,'YData',highCoord(1))
    
    ylim([0 400])
    xlim([-50 50])
    ylabel('Distance')
    xlabel('Angle')
%    legend('Object','Cylinder')
    drawnow;
end
hold off;
fclose(s);
delete(s);