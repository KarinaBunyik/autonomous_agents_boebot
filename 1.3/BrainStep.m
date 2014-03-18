function b = BrainStep(robot, time);

b = robot.Brain;


%% Add code here
fetchIrLeft = robot.RayBasedSensors(1).Reading;
fetchX = robot.Odometer.EstimatedPosition(1);
fetchY = robot.Odometer.EstimatedPosition(2);
fetchEstimatedHeading = robot.Odometer.EstimatedHeading;

if (b.CurrentState == 0)
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  if (fetchIrLeft <= 0)
    b.CurrentState = 1;
  end
elseif (b.CurrentState == 1)
  if (fetchIrLeft > 0.2) || ...
      ((fetchX>1.500) && (fetchY>1.5000)) || ...
      ((fetchX<-1.5000) && (fetchY>1.5000)) || ...
      ((fetchX>1.500) && (fetchY<-1.5000)) || ...
      ((fetchX<-1.5000) && (fetchY<-1.5000))
    b.LeftMotorSignal = -b.ForwardMotorSignal;
    b.RightMotorSignal = b.ForwardMotorSignal;
    b.CurrentState = 2;
  end
elseif (b.CurrentState == 2)
  if (1.2500 < fetchEstimatedHeading) && ...
     (1.2800 > fetchEstimatedHeading)
    b.Corners = b.Corners + 1;
    b.CurrentState = 0;
  end  
  if b.Corners > 1
    if ( 1.2500 < fetchEstimatedHeading) && ...
      (1.2800 > fetchEstimatedHeading)
      b.CurrentState = 0;
    elseif ( 2.8000 < fetchEstimatedHeading) && ...
      (-3.1200 < fetchEstimatedHeading)
      b.CurrentState = 0;
    elseif ( -1.9000 > fetchEstimatedHeading) && ...
      (-1.9200 < fetchEstimatedHeading)
      b.CurrentState = 0;
    elseif ( -0.3100 < fetchEstimatedHeading) && ...
      (-0.2800 > fetchEstimatedHeading)
      b.CurrentState = 0;
    end  
  end
end




