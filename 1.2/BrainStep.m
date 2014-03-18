function b = BrainStep(robot, time);

b = robot.Brain;

%% Add code here


if (b.CurrentState == 0) % Forward motion
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  b.CurrentState = 3;
elseif (b.CurrentState == 1) % Follow wall
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  b.FoundWall = 0;
  b.CurrentState = 4;
elseif (b.CurrentState == 2) % Time to stop turning? 
  testIrLeft = robot.RayBasedSensors(1).Reading;
  testIrRight = robot.RayBasedSensors(2).Reading;
  if (testIrRight == 0)
    b.CurrentState = 1;
  end
elseif (b.CurrentState == 3) % Found wall?
  if (b.FoundWall ~= 0)
    b.LeftMotorSignal = b.TurnMotorSignal;
    b.RightMotorSignal = -b.TurnMotorSignal;
    b.CurrentState = 2;
  else
    b.CurrentState = 3;
  end
elseif (b.CurrentState == 4) % Found second wall?
  if (b.FoundWall ~= 0)
    b.LeftMotorSignal = -b.TurnMotorSignal;
    b.RightMotorSignal = b.TurnMotorSignal;
    b.CurrentState = 5;
  else
    b.CurrentState = 4;
  end
elseif (b.CurrentState == 5) % Time to stop turning to corner?
  testIrLeft1 = robot.RayBasedSensors(1).Reading;
  testIrLeft2 = robot.RayBasedSensors(3).Reading;
  testIrRight1 = robot.RayBasedSensors(2).Reading;
  testIrRight2 = robot.RayBasedSensors(4).Reading;
  if (testIrLeft1+testIrLeft2) < (testIrRight1 + testIrRight2)
    b.CurrentState = 6;
  end
elseif (b.CurrentState == 6) % end state
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  b.CurrentState = 6;
end