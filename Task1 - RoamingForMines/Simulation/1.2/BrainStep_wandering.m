function b = BrainStep(robot, time);

b = robot.Brain;

%% Add code here

testIrLeft = robot.RayBasedSensors(1).Reading;
testIrRight = robot.RayBasedSensors(2).Reading;

if (b.CurrentState == 0) % Forward motion
  b.LeftMotorSignal = b.ForwardMotorSignal;
  b.RightMotorSignal = b.ForwardMotorSignal;
  b.CurrentState = 3;
elseif (b.CurrentState == 1) % Time to turn? 
  r = rand;
  if (r < b.TurnProbability)
    s = rand;
    if (s < b.LeftTurnProbability)
      b.LeftMotorSignal = b.TurnMotorSignal;
      b.RightMotorSignal = -b.TurnMotorSignal;
    else
      b.LeftMotorSignal = -b.TurnMotorSignal; 
      b.RightMotorSignal = b.TurnMotorSignal;
    end
    b.CurrentState = 2;
  end
elseif (b.CurrentState == 2) % Time to stop turning? 
  if (we turned 90 degrees)
    b.CurrentState = 0;
  end
elseif (b.CurrentState == 3) % Found wall?
  if (b.foundWall ~= 0)
    b.LeftMotorSignal = b.TurnMotorSignal;
    b.RightMotorSignal = -b.TurnMotorSignal;
    b.CurrentState = 2;
  else
    b.CurrentState = 1;
  end
end