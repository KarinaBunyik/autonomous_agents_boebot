function b = BrainStep(robot, time);

b = robot.Brain;


%% Add code here
testIrLeft = robot.RayBasedSensors(1).Reading;
testIrRight = robot.RayBasedSensors(2).Reading;

if (b.CurrentState == 0) % Forward motion
  b.LeftMotorSignal = -b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  testEstimatedHeading = robot.Odometer.EstimatedHeading

elseif (b.CurrentState == 8) % Forward motion
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  testIrLeft = robot.RayBasedSensors(1).Reading;
  testIrRight = robot.RayBasedSensors(2).Reading;
  
  if (testIrLeft <= 0)
      
    b.CurrentState = 1;
  end
  %b.CurrentState = 0;
elseif (b.CurrentState == 1)
  testIrLeft = robot.RayBasedSensors(1).Reading;
  testIrRight = robot.RayBasedSensors(2).Reading;
  if (testIrLeft > 0.2)
    b.LeftMotorSignal = -b.ForwardMotorSignal;
    b.RightMotorSignal = b.ForwardMotorSignal;

    testEstimatedHeading = robot.Odometer.EstimatedHeading;
    b.CurrentState = 2;
  end
elseif (b.CurrentState == 2)
  testIrLeft = robot.RayBasedSensors(1).Reading;
  testIrRight = robot.RayBasedSensors(2).Reading;
  desiredHeading = mod((b.Corners*1.2), 3.14)
  testEstimatedHeading = robot.Odometer.EstimatedHeading
  %if (robot.Compass.EstimatedHeading < -1)
  %   if (desiredHeading > -robot.Odometer.EstimatedHeading)
  %     b.Corners = b.Corners + 1.3
  %     b.CurrentState = 0;
  %   end
  %end
  %else
    if (desiredHeading < robot.Odometer.EstimatedHeading)
      b.Corners = b.Corners + 1.3
      b.CurrentState = 0;
    elseif ( -1.9800 > robot.Odometer.EstimatedHeading) && ...
        (-2.0000 < robot.Odometer.EstimatedHeading)
      %b.Corners = b.Corners + 1.3
      b.CurrentState = 0
    
    end
        
  %end
end




