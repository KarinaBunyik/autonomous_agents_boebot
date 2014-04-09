function b = BrainStep(robot, time);

b = robot.Brain;
fetchEstimatedHeading = robot.Odometer.EstimatedHeading;
fetchX = robot.Odometer.EstimatedPosition(1);
fetchY = robot.Odometer.EstimatedPosition(2);

%%%%%%%%%%%%%%%% FSM: %%%%%%%%%%%%%%%%%%%%
if (b.CurrentState == 0) % Forward motion
 b.LeftMotorSignal = b.ForwardMotorSignal;
 b.RightMotorSignal = b.ForwardMotorSignal;
 b.CurrentState = 1;
elseif (b.CurrentState == 1) % Time to turn?
 objNwSideNvx = [b.PotentialObjectNW(2,4) b.PotentialObjectNW(2,2), -0.8];
 objNwSideNvy = [b.PotentialObjectNW(2,1) b.PotentialObjectNW(2,1), 0.8];
 inObjNwSideN = inpolygon(fetchX,fetchY,objNwSideNvx,objNwSideNvy);
 objNwSideEvx = [b.PotentialObjectNW(2,2) b.PotentialObjectNW(2,2), -0.8];
 objNwSideEvy = [b.PotentialObjectNW(2,1) b.PotentialObjectNW(2,3), 0.8];
 inObjNwSideE = inpolygon(fetchX,fetchY,objNwSideEvx,objNwSideEvy);
 objNwSideSvx = [b.PotentialObjectNW(2,2) b.PotentialObjectNW(2,4), -0.8];
 objNwSideSvy = [b.PotentialObjectNW(2,3) b.PotentialObjectNW(2,3), 0.8];
 inObjNwSideS = inpolygon(fetchX,fetchY,objNwSideSvx,objNwSideSvy);
 objNwSideWvx = [b.PotentialObjectNW(2,4) b.PotentialObjectNW(2,4), -0.8];
 objNwSideWvy = [b.PotentialObjectNW(2,3) b.PotentialObjectNW(2,1), 0.8];
 inObjNwSideW = inpolygon(fetchX,fetchY,objNwSideWvx,objNwSideWvy);   
    
 objSeSideNvx = [b.PotentialObjectSE(2,4) b.PotentialObjectSE(2,2), 0.8];
 objSeSideNvy = [b.PotentialObjectSE(2,1) b.PotentialObjectSE(2,1), -0.8];
 inObjSeSideN = inpolygon(fetchX,fetchY,objSeSideNvx,objSeSideNvy);
 objSeSideEvx = [b.PotentialObjectSE(2,2) b.PotentialObjectSE(2,2), 0.8];
 objSeSideEvy = [b.PotentialObjectSE(2,1) b.PotentialObjectSE(2,3), -0.8];
 inObjSeSideE = inpolygon(fetchX,fetchY,objSeSideEvx,objSeSideEvy);
 objSeSideSvx = [b.PotentialObjectSE(2,2) b.PotentialObjectSE(2,4), 0.8];
 objSeSideSvy = [b.PotentialObjectSE(2,3) b.PotentialObjectSE(2,3), -0.8];
 inObjSeSideS = inpolygon(fetchX,fetchY,objSeSideSvx,objSeSideSvy);
 objSeSideWvx = [b.PotentialObjectSE(2,4) b.PotentialObjectSE(2,4), 0.8];
 objSeSideWvy = [b.PotentialObjectSE(2,3) b.PotentialObjectSE(2,1), -0.8];
 inObjSeSideW = inpolygon(fetchX,fetchY,objSeSideWvx,objSeSideWvy); 
 
 if (inObjNwSideN == 1)   
  b.PotentialObjectNW(3,1) = 1;
  b.CurrentState = 3;
 elseif (inObjNwSideE == 1)
  b.PotentialObjectNW(3,2) = 1;
  b.CurrentState = 3;
 elseif (inObjNwSideS == 1)
  b.PotentialObjectNW(3,3) = 1;
  b.CurrentState = 3;
 elseif (inObjNwSideW == 1)
  b.PotentialObjectNW(3,4) = 1;
  b.CurrentState = 3;
 end
 
 if (inObjSeSideN == 1)   
  b.PotentialObjectSE(3,1) = 1;
  b.CurrentState = 3;
 elseif (inObjSeSideE == 1)
  b.PotentialObjectSE(3,2) = 1;
  b.CurrentState = 3;
 elseif (inObjSeSideS == 1)
  b.PotentialObjectSE(3,3) = 1;
  b.CurrentState = 3;
 elseif (inObjSeSideW == 1)
  b.PotentialObjectSE(3,4) = 1;
  b.CurrentState = 3;
 end 
 
 if (fetchX>b.PotentialWallE(2))
  b.PotentialWallE(3) = 1;
  b.CurrentState = 3;
 elseif (fetchX<b.PotentialWallW(2))
  b.PotentialWallW(3) = 1;
  b.CurrentState = 3;
 elseif (fetchY>b.PotentialWallN(2))
  b.PotentialWallN(3) = 1;
  b.CurrentState = 3;
 elseif (fetchY<b.PotentialWallS(2))
  b.PotentialWallS(3) = 1;
  b.CurrentState = 3;
 elseif (fetchY<b.PotentialWallS(2))
 end
 %r = rand;
 %if (r < b.TurnProbability)
 % s = rand;
 % if (s < b.LeftTurnProbability)
 %  b.LeftMotorSignal  =  b.TurnMotorSignal;
 %  b.RightMotorSignal = -b.TurnMotorSignal;
 % else
 %  b.LeftMotorSignal  = -b.TurnMotorSignal;
 %  b.RightMotorSignal =  b.TurnMotorSignal;
 % end
 % b.CurrentState = 1;
 %end
elseif (b.CurrentState == 2) % Time to stop turning?
 %r = rand;
 %if (r < b.StopTurnProbability) 
  %b.CurrentState = 0;
 %end
elseif (b.CurrentState == 3) % Found potential - turning
 b.LeftMotorSignal  =  b.TurnMotorSignal;
 b.RightMotorSignal = -b.TurnMotorSignal;
 b.CurrentState = 4;
elseif (b.CurrentState == 4) % Found potential - stop turning?
 
 if ( b.PotentialObjectNW(3,1) == 1)   
  if (fetchEstimatedHeading > b.PotentialObjectNW(1,1)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialObjectNW(1,1)+b.TurningAngle)
   b.PotentialObjectNW(3,1) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectNW(3,2) == 1)   
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialObjectNW(1,2)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialObjectNW(1,2)+b.TurningAngle)) 
   b.PotentialObjectNW(3,2) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectNW(3,3) == 1)  
  if (fetchEstimatedHeading > b.PotentialObjectNW(1,3)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialObjectNW(1,3)+b.TurningAngle)
   b.PotentialObjectNW(3,3) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectNW(3,4) == 1)  
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialObjectNW(1,4)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialObjectNW(1,4)+b.TurningAngle)) 
   b.PotentialObjectNW(3,4) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectSE(3,1) == 1)  
  if (fetchEstimatedHeading > b.PotentialObjectSE(1,1)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialObjectSE(1,1)+b.TurningAngle)
   b.PotentialObjectSE(3,1) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectSE(3,2) == 1)   
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialObjectSE(1,2)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialObjectSE(1,2)+b.TurningAngle)) 
   b.PotentialObjectSE(3,2) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectSE(3,3) == 1)   
  if (fetchEstimatedHeading > b.PotentialObjectSE(1,3)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialObjectSE(1,3)+b.TurningAngle)
   b.PotentialObjectSE(3,3) = 1;
   b.CurrentState = 0;
  end
 elseif ( b.PotentialObjectSE(3,4) == 1)   
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialObjectSE(1,4)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialObjectSE(1,4)+b.TurningAngle)) 
   b.PotentialObjectSE(3,4) = 1;
   b.CurrentState = 0;
  end
 end
    
 if (b.PotentialWallE(3) == 1) 
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialWallE(1)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialWallE(1)+b.TurningAngle)) 
   b.PotentialWallE(3) = 0;
   %test = fetchEstimatedHeading
   b.CurrentState = 0;
  end

 elseif (b.PotentialWallW(3) == 1) 
  if ((fetchEstimatedHeading > 0) && (fetchEstimatedHeading > b.PotentialWallW(1)-b.TurningAngle)) || ...
   ((fetchEstimatedHeading < 0) && (- fetchEstimatedHeading < -b.PotentialWallW(1)+b.TurningAngle)) 
   b.PotentialWallW(3) = 0;
   %test = fetchEstimatedHeading
   b.CurrentState = 0;
  end
 elseif (b.PotentialWallN(3) == 1) 
  if (fetchEstimatedHeading > b.PotentialWallN(1)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialWallN(1)+b.TurningAngle)
   b.PotentialWallN(3) = 0;
   %test = fetchEstimatedHeading
   b.CurrentState = 0;
  end
 elseif (b.PotentialWallS(3) == 1) 
  if (fetchEstimatedHeading > b.PotentialWallS(1)-b.TurningAngle) && ...
   ( fetchEstimatedHeading < b.PotentialWallS(1)+b.TurningAngle)
   b.PotentialWallS(3) = 0;
   %test = fetchEstimatedHeading
   b.CurrentState = 0;
  end
 end
end


