function collided = CheckForCollisions(arena, robot);

collided = false;

x = robot.Position(1);
y = robot.Position(2);
r = robot.Radius;

numberOfObjects = size(arena.Objects,1);
for i = 1:numberOfObjects
 numberOfSides = size(arena.Objects(i).Vertices,1);
 for j = 1:numberOfSides

  if (j < numberOfSides)
   p1 = arena.Objects(i).Vertices(j,:);
   p2 = arena.Objects(i).Vertices(j+1,:);
  else
   p1 = arena.Objects(i).Vertices(j,:);
   p2 = arena.Objects(i).Vertices(1,:);
  end

  d1 = sqrt( (x-p1(1))^2 + (y-p1(2))^2 );
  d2 = sqrt( (x-p2(1))^2 + (y-p2(2))^2 );
  if ((d1 < r) | (d2 < r)) 
   collided = true;
   break;
  end 

  a = (p2(1)-p1(1))^2 + (p2(2)-p1(2))^2;
  b = 2*( (p2(1)-p1(1))*(p1(1)-x) + (p2(2)-p1(2))*(p1(2)-y) );
  c = x^2 + y^2 + p1(1)^2 + p1(2)^2 - 2*( x*p1(1) + y*p1(2)) - r^2;
  delta = b*b - 4*a*c;
  if (delta > 0) 
   t1 = (x-p1(1))*(p2(1)-p1(1)) + (y-p1(2))*(p2(2)-p1(2));
   t2 = (p2(1)-p1(1))^2 + (p2(2)-p1(2))^2;
   u = t1/t2;
   if ((u >= 0) & (u <= 1))
    collided = true;
   end
  end

 end


 if (collided)
  break; % collision already detected, no need to check further.
 end 

end % for i
