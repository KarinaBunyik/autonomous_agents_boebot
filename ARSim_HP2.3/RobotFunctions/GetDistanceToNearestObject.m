function d = GetDistanceToNearestObject(beta, x, y, arena);

d = 100000000.0; % No detection yet

numberOfArenaObjects = size(arena.Objects,1);

for i = 1:numberOfArenaObjects
 numberOfSides = size(arena.Objects(i).Vertices,1);
 for j = 1:numberOfSides
  if (j < numberOfSides) 
    p1 = arena.Objects(i).Vertices(j,:);
    p2 = arena.Objects(i).Vertices(j+1,:);
  else
    p1 = arena.Objects(i).Vertices(numberOfSides,:);
    p2 = arena.Objects(i).Vertices(1,:);
  end 
  v1 = p1;
  v2 = p2;
  v1(1) = v1(1) - x;
  v1(2) = v1(2) - y;
  v2(1) = v2(1) - x;
  v2(2) = v2(2) - y;
  [minAngle,maxAngle] = GetMinMaxAngle(v1,v2);

  if (maxAngle-minAngle > pi)
   if (beta < 0)
    temp = minAngle;
    minAngle = maxAngle - 2*pi;
    maxAngle = temp;
   else
    temp = maxAngle;
    maxAngle = minAngle + 2*pi;
    minAngle = temp;
   end
  end %% If maxAngle-minAngle > pi

  if ((beta > minAngle) & (beta < maxAngle))
   lineDistance = GetDistanceToLineAlongRay(beta,p1,p2,x,y);
   if (lineDistance < d) 
    d = lineDistance;
   end  
  end
 
 end % for j
end % for i


