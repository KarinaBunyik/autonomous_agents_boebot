%fclose(s);
%delete(s);

%clear
%clc

s = serial('COM8','BaudRate',9600);
fopen(s);
values = zeros(120);
plotHandle = plot(values,values);

for i = 1:500
    reading = fscanf(s,'%u');
    
    reading(1)+1
    vector(reading(1)+1) = reading(2);
    set(plotHandle,'YData',vector)
    
    disp([reading(1) reading(2)])
    drawnow;
end

fclose(s);
delete(s);