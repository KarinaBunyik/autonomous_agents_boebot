function o = GetOdometerReading(robot, dt);

o = robot.Odometer;

sigma = o.Sigma;

speed = robot.Speed;

vLeft = speed - robot.Radius*robot.AngularSpeed;
vRight = speed + robot.Radius*robot.AngularSpeed;

deltaLeft = vLeft*dt + randn*sigma; 
deltaRight = vRight*dt + randn*sigma;

deltaS = (deltaLeft+deltaRight)/2.0;
deltaPhi = -(deltaLeft-deltaRight)/(2.0*robot.Radius);

o.EstimatedHeading = o.EstimatedHeading + deltaPhi;

if (o.EstimatedHeading > pi) 
 o.EstimatedHeading = o.EstimatedHeading - 2*pi;
elseif (o.EstimatedHeading < -pi)
 o.EstimatedHeading = o.EstimatedHeading + 2*pi;
end

deltaX = deltaS*cos(o.EstimatedHeading);
deltaY = deltaS*sin(o.EstimatedHeading);

o.EstimatedPosition(1) = o.EstimatedPosition(1) + deltaX;
o.EstimatedPosition(2) = o.EstimatedPosition(2) + deltaY;