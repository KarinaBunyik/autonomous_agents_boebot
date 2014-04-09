%fclose(s);
%delete(s);

clear
clc

s=serial('COM9','BaudRate',9600);
fopen(s);
vision = zeros(100,1);
plot(vision)
drawnow

for i = 1:5000
    readData = fscanf(s); %reads "Ready"

    iter = mod(i-1,100)+1;
    iter2 = mod(i,100)+1;
    str2num(readData)
    vision(iter) = str2num(readData);
    vision(iter2) = 0;

    plot(vision)
    ylim([0 400]);
    pause(0.001);
end
    
fclose(s);
delete(s);