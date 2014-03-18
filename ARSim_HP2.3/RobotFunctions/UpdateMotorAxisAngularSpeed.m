function r = UpdateMotorAxisAngularSpeed(robot)

r = robot;
speed = r.Speed;

vLeft = speed - (0.5*r.Radius*r.AngularSpeed);
vRight = speed + (0.5*r.Radius*r.AngularSpeed);

r.Motors(1).AxisAngularVelocity = (vLeft/r.WheelRadius);
r.Motors(2).AxisAngularVelocity = (vRight/r.WheelRadius);
