function motionResults = InitializeMotionResults(robot)

numberOfSensors = size(robot.Sensors,2);
for i = 1:numberOfSensors
 sensorReadings(i) = robot.Sensors(i).Reading;
end

time = [0.0];
position = robot.Position;
velocity = robot.Velocity;
heading = robot.Heading;

motionResults = struct('Time',time,...
                       'Position',position,...
                       'Velocity',velocity,...
                       'Heading',heading,...
                       'SensorReadings',sensorReadings);