function c = GetCompassReading(robot, dt);

c = robot.Compass;
sigma = c.Sigma;
c.EstimatedHeading = robot.Heading + randn*sigma;
if (c.EstimatedHeading > pi) 
  c.EstimatedHeading = c.EstimatedHeading - 2*pi;
elseif (c.EstimatedHeading < -pi)
 c.EstimatedHeading = c.EstimatedHeading + 2*pi;
end
