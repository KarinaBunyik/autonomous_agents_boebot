function plotHandle = InitializePlot(robot, arena)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Background:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotHandle = gcf;
set(plotHandle,'Color',[0.5 0.5 0.5]);
set(plotHandle,'DoubleBuffer','on');
axis equal;
axis off;
axis(arena.Size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arena:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
arenaHandle = findobj('Tag',arena.Name);
if (isempty(arenaHandle))
 arenaHandle = rectangle('position',[arena.Size(1), arena.Size(3), arena.Size(2)-arena.Size(1),...
                          arena.Size(4)-arena.Size(3)],'EdgeColor','White');
end

numberOfArenaObjects = size(arena.Objects,1);
for i = 1:numberOfArenaObjects
 arenaObjectHandle = findobj('Tag',arena.Objects(i).Name);
 if (~isempty(arenaObjectHandle))
  set(arenaObjectHandle,'XData',arena.Objects(i).Vertices(:,1),'YData',arena.Objects(i).Vertices(:,2));
 else
  arenaObjectHandle = patch('XData', arena.Objects(i).Vertices(:,1),...
                            'YData', arena.Objects(i).Vertices(:,2),...
                            'FaceColor','Blue','Tag',arena.Objects(i).Name);
 end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robot:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = robot.Position(1);
y = robot.Position(2);
angle = robot.Heading;

robotHandle = findobj('Tag',robot.Name);
if (~isempty(robotHandle))
  set(robotHandle,'Position',[x-robot.Radius, y-robot.Radius, 2*robot.Radius, 2*robot.Radius]);
else
 robotHandle = rectangle('curvature',[1 1],'position',...
                         [x-robot.Radius, y-robot.Radius, 2*robot.Radius, 2*robot.Radius]);
 set(robotHandle,'FaceColor','green','EdgeColor','white','Tag',robot.Name);
end

forwardLineHandle = findobj('Tag',[robot.Name 'ForwardLine']);
if (~isempty(forwardLineHandle))
 set(forwardLineHandle,'XData',[x x+robot.Radius*cos(angle)],'YData',[y y+robot.Radius*sin(angle)]);
else
 forwardLineHandle = line([x x+robot.Radius*cos(angle)], [y y+robot.Radius*sin(angle)], 'color','black');
 set(forwardLineHandle,'Tag',[robot.Name 'ForwardLine']);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Odometric ghost:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (~isempty(robot.Odometer))
 if (robot.ShowOdometricGhost)
  xEstimate = robot.Odometer.EstimatedPosition(1);
  yEstimate = robot.Odometer.EstimatedPosition(2);
  angleEstimate = robot.Odometer.EstimatedHeading;
  ghostHandle = findobj('Tag',[robot.Name 'Ghost']);
  if (~isempty(ghostHandle))
   set(ghostHandle,'Position',[xEstimate-robot.Radius, yEstimate-robot.Radius, 2*robot.Radius, 2*robot.Radius]);
  else
   ghostHandle = rectangle('curvature',[1 1],'position',...
       [xEstimate-robot.Radius, yEstimate-robot.Radius, 2*robot.Radius, 2*robot.Radius]);
   set(ghostHandle,'EdgeColor','black','Tag',[robot.Name 'Ghost']);
  end

  ghostLineHandle = findobj('Tag',[robot.Name 'ForwardLineGhost']);
  if (~isempty(ghostLineHandle))
   set(ghostLineHandle,'XData',[xEstimate xEstimate+robot.Radius*cos(angleEstimate)],...
                       'YData',[yEstimate yEstimate+robot.Radius*sin(angleEstimate)]);
  else
   ghostLineHandle = line([x x+robot.Radius*cos(angle)], [y y+robot.Radius*sin(angle)], 'color','black');
   set(ghostLineHandle,'Tag',[robot.Name 'ForwardLineGhost']);
  end
 end  % If ShowOdometricGhost
end % If Odometer present


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sensor ray indicators: get readings if displayed:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if (robot.ShowSensorRays)
  robot.Sensors = GetRayBasedSensorReadings(robot,arena);
 end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IR sensors:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numberOfSensors = size(robot.Sensors,2);
for i = 1:numberOfSensors
 x0 = x + robot.Radius*cos(angle+robot.Sensors(i).RelativeAngle);
 y0 = y + robot.Radius*sin(angle+robot.Sensors(i).RelativeAngle);
 sensorHandle = findobj('Tag',robot.Sensors(i).Name);
 if (~isempty(sensorHandle))
  set(sensorHandle,'Position',[x0-robot.Sensors(i).Size, y0-robot.Sensors(i).Size,...
                        2*robot.Sensors(i).Size, 2*robot.Sensors(i).Size]);
 else
  sensorHandle = rectangle('curvature',[1 1],'position',...
                     [x0-robot.Sensors(i).Size, y0-robot.Sensors(i).Size,...
                      2*robot.Sensors(i).Size, 2*robot.Sensors(i).Size]);
  set(sensorHandle,'FaceColor','red','EdgeColor','white','Tag',robot.Sensors(i).Name);
 end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Sensor ray indicators:
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 if (robot.ShowSensorRays)   
 % DeltaGamma = robot.Sensors(i).OpeningAngle/(robot.Sensors(i).NumberOfRays-1);
  x0 = robot.Sensors(i).Position(1);
  y0 = robot.Sensors(i).Position(2);

  for j = 1:robot.Sensors(i).NumberOfRays
   dx = robot.Sensors(i).RayLengths(j)*cos(robot.Sensors(i).RayDirections(j));
   dy = robot.Sensors(i).RayLengths(j)*sin(robot.Sensors(i).RayDirections(j));
   sensorRayHandle = findobj('Tag',[robot.Sensors(i).Name 'Ray' char(48+j) ]);
   if (~isempty(sensorRayHandle))
     set(sensorRayHandle,'Xdata', [x0 x0+dx], 'YData', [y0 y0+dy]);
   else
     sensorRayHandle = patch('XData',[x0 x0+dx],'YData',[y0 y0+dy]);
     set(sensorRayHandle,'Tag',[robot.Sensors(i).Name 'Ray' char(48+j) ]);
   end
  end % for j
 end % robot.ShowSensorRays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end % for i

drawnow;