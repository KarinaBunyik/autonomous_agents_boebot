function r = SetPositionAndVelocity(robot,position,heading,velocity,angularSpeed);

r = robot;
r.Position = position;
r.Heading = heading;
r.Velocity = velocity;
r.Speed = sqrt(velocity(1)^2 + velocity(2)^2);
r.AngularSpeed = angularSpeed;
r.Sensors = UpdateSensorPositions(r);
