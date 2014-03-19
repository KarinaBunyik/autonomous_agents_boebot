function s = GetIRSensorReading(sensor,arena);

s = sensor;
rayReadings = zeros(s.NumberOfRays,1);

%% Find ray readings:
x = s.Position(1);
y = s.Position(2);
deltaGamma = s.OpeningAngle/(s.NumberOfRays-1);
for i = 1:s.NumberOfRays
 beta = s.AbsoluteAngle - 0.5*s.OpeningAngle + (i-1)*deltaGamma;
 if (beta < -pi)
  beta = beta + 2*pi;
 elseif (beta > pi)
  beta = beta - 2*pi;
 end
 s.RayDirections(i) = beta;
 distance = GetDistanceToNearestObject(beta, x, y, arena);
 if (distance < s.Range) 
   s.RayLengths(i) = distance;
   kappa = -0.5*s.OpeningAngle + (i-1)*deltaGamma;
   if (distance > 0.0)
    rayReadings(i) = cos(kappa)*( (s.C1/(distance^2)) + s.C2);
    if (rayReadings(i) > 1.0)
     rayReadings(i) = 1.0;
    end
   else
    rayReadings(i) = 1.0;
   end
 else
   s.RayLengths(i) = s.Range;
   rayReadings(i) = 0.0;
 end

%% Add noise:
errorFreeReading = mean(rayReadings);
noisyReading = errorFreeReading*(1 + randn*s.Sigma);
if (noisyReading < 0)
 noisyReading = 0.0;
end
if (noisyReading > 1)
 noisyReading = 1.0;
end
s.Reading = noisyReading;
 
end
