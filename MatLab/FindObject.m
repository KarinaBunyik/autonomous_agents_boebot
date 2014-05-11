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
coord = [0 0];
coordHandle = plot(coord(1),coord(2),'x');
hold on;
lowHandle = plot(-(-39:40),lowSonar,'red');
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
    
    reading'
    coord = [reading(3) reading(4)];
    
    if angle > oldAngle
        lowSonar(oldAngle+1:angle) = reading(2);
        
    elseif angle < oldAngle
        lowSonar(angle:oldAngle-1) = reading(2);
        
    end
    oldAngle = angle;
    
    set(coordHandle,'XData',-coord(2))
    set(coordHandle,'YData',coord(1))
    set(lowHandle,'YData',lowSonar)
    ylim([0 400])
    xlim([-50 50])
    ylabel('Distance')
    xlabel('Angle')
    legend('Object','Cylinder')
    drawnow;
end
hold off;
fclose(s);
delete(s);