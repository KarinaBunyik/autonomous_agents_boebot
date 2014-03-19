function ShowRobot(plot,robot);

x = robot.Position(1);
y = robot.Position(2);
angle = robot.Heading;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robot body:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robotHandle = findobj('Tag',robot.Name);
set(robotHandle,'Position',[x-robot.Radius y-robot.Radius 2*robot.Radius 2*robot.Radius]);
forwardLineHandle = findobj('Tag',[robot.Name 'ForwardLine']);
set(forwardLineHandle,'XData',[x x+robot.Radius*cos(angle)],'YData',[y y+robot.Radius*sin(angle)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Odometric ghost:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (~isempty(robot.Odometer))
 if (robot.ShowOdometricGhost)
  xEstimate = robot.Odometer.EstimatedPosition(1);
  yEstimate = robot.Odometer.EstimatedPosition(2);
  angleEstimate = robot.Odometer.EstimatedHeading;
  ghostHandle = findobj('Tag',[robot.Name 'Ghost']);
  set(ghostHandle,'Position',[xEstimate-robot.Radius yEstimate-robot.Radius 2*robot.Radius 2*robot.Radius]);
  ghostLineHandle = findobj('Tag',[robot.Name 'ForwardLineGhost']);
  set(ghostLineHandle,'XData',[xEstimate xEstimate+robot.Radius*cos(angleEstimate)],...
          'YData',[yEstimate yEstimate+robot.Radius*sin(angleEstimate)]);
 end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IR sensors:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numberOfSensors = size(robot.Sensors,2);
for i = 1:numberOfSensors
 x0 = robot.Sensors(i).Position(1);
 y0 = robot.Sensors(i).Position(2);
 sensorHandle = findobj('Tag',robot.Sensors(i).Name);
 set(sensorHandle,'Position',[x0-robot.Sensors(i).Size, y0-robot.Sensors(i).Size,...
                       2*robot.Sensors(i).Size, 2*robot.Sensors(i).Size]);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Sensor ray indicators
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if (robot.ShowSensorRays)
  for j = 1:robot.Sensors(i).NumberOfRays 
   sensorRayHandle = findobj('Tag',[robot.Sensors(i).Name 'Ray' char(48+j)]);
   dx = robot.Sensors(i).RayLengths(j)*cos(robot.Sensors(i).RayDirections(j));
   dy = robot.Sensors(i).RayLengths(j)*sin(robot.Sensors(i).RayDirections(j));
   set(sensorRayHandle,'Xdata', [x0 x0+dx], 'YData', [y0 y0+dy]);
  end
 end 

end % for i

drawnow;