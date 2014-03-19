function s = UpdateSensorPositions(robot);

s = robot.RayBasedSensors;

numberOfSensors = size(s,2);
for i = 1:numberOfSensors 
 s(i).Position(1) = robot.Position(1) + robot.Radius*cos(robot.Heading + s(i).RelativeAngle);
 s(i).Position(2) = robot.Position(2) + robot.Radius*sin(robot.Heading + s(i).RelativeAngle);
 s(i).AbsoluteAngle = robot.Heading + s(i).RelativeAngle;
end