function s = GetRayBasedSensorReadings(robot, arena)

s = robot.Sensors;
numberOfSensors = size(s,2);

for i=1:numberOfSensors
 if (s(i).Type == 'IR') 
   s(i) = GetIRSensorReading(s(i),arena);
 end
end


