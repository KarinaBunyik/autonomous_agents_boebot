function motionResults = AddMotionResults(oldMotionResults, time, robot)

motionResults = oldMotionResults;
motionResults.Time = [motionResults.Time; time];
motionResults.Position = [motionResults.Position; robot.Position];
motionResults.Velocity = [motionResults.Velocity; robot.Velocity];
motionResults.Heading  = [motionResults.Heading; robot.Heading];

sensorReadings = [];
numberOfSensors = size(robot.Sensors,2);
for i = 1:numberOfSensors
 sensorReadings(i) = robot.Sensors(i).Reading;
end

motionResults.SensorReadings = [motionResults.SensorReadings; sensorReadings];
