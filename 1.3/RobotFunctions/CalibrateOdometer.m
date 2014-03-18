function o = CalibrateOdometer(robot);

o = robot.Odometer;

o.EstimatedPosition(1) = robot.Position(1);
o.EstimatedPosition(2) = robot.Position(2);
o.EstimatedHeading = robot.Heading;