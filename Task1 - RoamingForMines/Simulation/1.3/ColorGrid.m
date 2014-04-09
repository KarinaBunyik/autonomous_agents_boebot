clear all

gridColors = [0.7 0.7 0.7; 0.0 0.0 0.0; 1.0 1.0 0.0; ...
              0.0 0.0 1.0; 1.0 1.0 1.0; 0.7 1.0 0.7; ...
              0.5 1.0 0.5];

emptyCellColorIndex = 1;
obstacleCellColorIndex = 2;
startCellColorIndex = 3;
targetCellColorIndex = 4;
currentCellColorIndex = 5;
evaluatedCellColorIndex = 6;
pathCellColorIndex = 7;


mapGrid = ... 
[2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 2 2 2 2 2 1 1 1 2 2 1 2 2 2; ...
 2 2 2 1 1 2 2 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 1 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 1 1 1 1 2 1 1 1 2 1 1 1 1 1 1 1 1 2; ...
 2 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 2; ...
 2 1 1 1 1 1 1 1 1 1 2 1 1 1 2 1 1 1 2 1 1 1 1 2; ...
 2 2 2 1 1 2 2 1 1 1 2 2 2 2 2 1 1 1 2 2 1 2 2 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2; ...
 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;]; 

startX = 4;
startY = 4;
targetX = 22;
targetY = 14;

mapGrid(startY,startX) = startCellColorIndex; %% NOTE! (Y,X) not (X,Y)!
mapGrid(targetY, targetX) = targetCellColorIndex;

%% ... etc. ...

plotHandle = image(mapGrid,'erasemode','xor');
colormap(gridColors);
axis equal;
drawnow;
%hold all

%% initiation

startRow = startY;
startCol = startX;
targetRow = targetY;
targetCol = targetX;

distanceValue = ones(16,24);
stateValue = zeros(16,24);

for i = 1:16
  for j = 1:24
    distanceValue(i,j) = 40000;
  end
end

distanceValue(startRow,startCol) = 0;
currentNodeIndex = [startRow, startCol];

loopVar = 1;
%handl = plotHimage(mapGrid,'erasemode','xor');

%while (currentNodeIndex(1) ~= targetX) || (currentNodeIndex(2) ~= targetY)
while true
  if (currentNodeIndex(1)+1)>0 && (currentNodeIndex(1)+1)<17 && mapGrid((currentNodeIndex(1)+1),currentNodeIndex(2)) ~= 2
    distanceValue(currentNodeIndex(1)+1,currentNodeIndex(2)) = ...
      min(distanceValue(currentNodeIndex(1)+1,currentNodeIndex(2)), distanceValue(currentNodeIndex(1),currentNodeIndex(2))+1);
  end
  if (currentNodeIndex(1)-1)>0 && (currentNodeIndex(1)-1)<17 && mapGrid((currentNodeIndex(1)-1),currentNodeIndex(2)) ~= 2
    distanceValue(currentNodeIndex(1)-1,currentNodeIndex(2)) = ...
      min(distanceValue(currentNodeIndex(1)-1,currentNodeIndex(2)), distanceValue(currentNodeIndex(1),currentNodeIndex(2))+1);
  end
  if (currentNodeIndex(2)-1)>0 && (currentNodeIndex(2)-1)<25 && mapGrid(currentNodeIndex(1),(currentNodeIndex(2)-1)) ~= 2
    distanceValue(currentNodeIndex(1),currentNodeIndex(2)-1) = ...
      min(distanceValue(currentNodeIndex(1),currentNodeIndex(2)-1), distanceValue(currentNodeIndex(1),currentNodeIndex(2))+1);
  end
  if (currentNodeIndex(2)+1)>0 && (currentNodeIndex(2)+1)<25 && mapGrid(currentNodeIndex(1),(currentNodeIndex(2)+1)) ~= 2
   distanceValue(currentNodeIndex(1),currentNodeIndex(2)+1) = ...
      min(distanceValue(currentNodeIndex(1),currentNodeIndex(2)+1), distanceValue(currentNodeIndex(1),currentNodeIndex(2))+1);
  end
  minimumDistanceValue = 40000;
  minimumDistanceIndex = currentNodeIndex;
  for i = 1:16
    for j = 1:24
      if stateValue(i,j) == 0 && (currentNodeIndex(1)~=i || currentNodeIndex(2)~=j)
        if distanceValue(i,j) < minimumDistanceValue
          minimumDistanceValue = distanceValue(i,j);
          minimumDistanceIndex = [i,j];
        end
      end
    end
  end

  stateValue(currentNodeIndex(1), currentNodeIndex(2)) = 1;
  
  if ((currentNodeIndex(1) ~= targetRow) || (currentNodeIndex(2) ~= targetCol)) && ...
    ((currentNodeIndex(1) ~= startRow) || (currentNodeIndex(2) ~= startCol))
      mapGrid(currentNodeIndex(1), currentNodeIndex(2)) = evaluatedCellColorIndex;
  end
  currentNodeIndex = minimumDistanceIndex;
  if ((currentNodeIndex(1) ~= targetRow) || (currentNodeIndex(2) ~= targetCol)) && ...
    ((currentNodeIndex(1) ~= startRow) || (currentNodeIndex(2) ~= startCol))
      mapGrid(currentNodeIndex(1), currentNodeIndex(2)) = currentCellColorIndex;
  end
  pause(.1)
  plotHandle = image(mapGrid,'erasemode','xor');
  colormap(gridColors);
  axis equal;
  drawnow;
  %reducing flashing
  set(plotHandle,'erasemode','none');
  
  if (currentNodeIndex(1) == targetRow) && (currentNodeIndex(2) == targetCol)
    break
  end
end
prevNodeIndex(1) = targetRow;
prevNodeIndex(2) = targetCol;
while true
  if distanceValue(prevNodeIndex(1)-1,prevNodeIndex(2)) < distanceValue(prevNodeIndex(1),prevNodeIndex(2))
    prevNodeIndex(1) = prevNodeIndex(1)-1;
    prevNodeIndex(2) = prevNodeIndex(2);
  elseif distanceValue(prevNodeIndex(1)+1,prevNodeIndex(2)) < distanceValue(prevNodeIndex(1),prevNodeIndex(2))
    prevNodeIndex(1) = prevNodeIndex(1)+1;
    prevNodeIndex(2) = prevNodeIndex(2);
  elseif distanceValue(prevNodeIndex(1),prevNodeIndex(2)-1) < distanceValue(prevNodeIndex(1),prevNodeIndex(2))  
    prevNodeIndex(1) = prevNodeIndex(1);
    prevNodeIndex(2) = prevNodeIndex(2)-1;
  else
    prevNodeIndex(1) = prevNodeIndex(1);
    prevNodeIndex(2) = prevNodeIndex(2)+1;      
  end    
  
  mapGrid(prevNodeIndex(1), prevNodeIndex(2)) = pathCellColorIndex;
  
  if (prevNodeIndex(1) == startRow) && (prevNodeIndex(2) == startCol)
    break
  end
  
  pause(.1)
  plotHandle = image(mapGrid,'erasemode','xor');
  colormap(gridColors);
  axis equal;
  drawnow;
  %reducing flashing
  set(plotHandle,'erasemode','none');
  
  %if ((currentNodeIndex(1) ~= targetRow) || (currentNodeIndex(2) ~= targetCol)) && ...
   % ((currentNodeIndex(1) ~= startRow) || (currentNodeIndex(2) ~= startCol))
    %  mapGrid(currentNodeIndex(1), currentNodeIndex(2)) = evaluatedCellColorIndex;
 % end
  %currentNodeIndex = minimumDistanceIndex;
  %if ((currentNodeIndex(1) ~= targetRow) || (currentNodeIndex(2) ~= targetCol)) && ...
   % ((currentNodeIndex(1) ~= startRow) || (currentNodeIndex(2) ~= startCol))
    %  mapGrid(currentNodeIndex(1), currentNodeIndex(2)) = currentCellColorIndex;
  %end
end



