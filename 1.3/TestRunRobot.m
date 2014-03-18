%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TestRunRobot: a sample program, illustrating the use
% of the ARSim functions (v1.1.9)
%
% (c) Mattias Wahde, 2006, 2007, 2011
%
% Send bug reports to: mattias.wahde@chalmers.se
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add ARSim to the search path:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(computer,'PCWIN')
  path(path,'.\RobotFunctions');
  path(path,'.\ResultFunctions');
  path(path,'.\PlotFunctions');
  path(path,'.\ArenaFunctions');
else
  path(path,'./RobotFunctions');
  path(path,'./ResultFunctions');
  path(path,'./PlotFunctions');
  path(path,'./ArenaFunctions');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate arena:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
arenaSize = [-2.1 2.1 -2.1 2.1]; 
arenaObject1 = CreateArenaObject('arenaObject1',[[-1 -1]; [-1 1]; [1 1]; [1 -1]]);
arenaObject2 = CreateArenaObject('arenaObject2',[[-2.1 -2]; [-2 -2]; [-2 2]; [-2.1 2]]);
arenaObject3 = CreateArenaObject('arenaObject3',[[-2.1 -2.1]; [2.1 -2.1]; [2.1 -2]; [-2.1 -2]]);
arenaObject4 = CreateArenaObject('arenaObject4',[[-2.1 2]; [2.1 2]; [2.1 2.1]; [-2.1 2.1]]);
arenaObject5 = CreateArenaObject('arenaObject5',[[2 -2]; [2.1 -2]; [2.1 2]; [2 2]]);
testArena =  CreateArena('arena',arenaSize,[arenaObject1; arenaObject2; arenaObject3; arenaObject4; arenaObject5]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate robot:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Brain:
%%%%%%%%%%%%%%%%%%
brain = CreateBrain;

%%%%%%%%%%%%%%%%%%
% IR Sensors:
%%%%%%%%%%%%%%%%%%
sensor1RelativeAngle = 0.7854;
sensor2RelativeAngle = -0.7854;
size = 0.0500;
numberOfRays = 3;
openingAngle = 0.5000;
range = 1.0000;
c1 = 0.0300;
c2 = 0.1000;
sigma = 0.0200;
sensor1 = CreateIRSensor('sensor1',sensor1RelativeAngle,size,...
                          numberOfRays,openingAngle,range,c1,c2,sigma);
sensor2 = CreateIRSensor('sensor2',sensor2RelativeAngle,size,...
                          numberOfRays,openingAngle,range,c1,c2,sigma);

%%%%%%%%%%%%%%%%%%%%
% Odometer:
%%%%%%%%%%%%%%%%%%%%
sigma = 0.0002;  % Measures the odometric drift
odometer = CreateOdometer('odometer',sigma);

%%%%%%%%%%%%%%%%%%%%
% Compass:
%%%%%%%%%%%%%%%%%%%%
sigma = 0.0500;
compass = CreateCompass('compass',sigma);

%%%%%%%%%%%%%%%%%%%%
% Motors:
%%%%%%%%%%%%%%%%%%%%
leftMotor = CreateMotor('leftMotor');
rightMotor = CreateMotor('rightMotor');
mass = 3.0000;
momentOfInertia = 0.2000;
radius = 0.2000;
wheelRadius = 0.1000;

%% Robot with IR sensors:
%  testRobot = CreateRobot('TestRobot',mass,momentOfInertia,radius,wheelRadius, ...
%                       [sensor1 sensor2],[leftMotor rightMotor],[],[],brain);

%% Robot with IR sensors and odometer:
%  testRobot = CreateRobot('TestRobot',mass,momentOfInertia,radius,wheelRadius, ...
%                        [sensor1 sensor2],[leftMotor rightMotor],odometer,[],brain);

%% Robot with IR sensors, odometer, and compass:
   testRobot = CreateRobot('TestRobot',mass,momentOfInertia,radius,wheelRadius, ...
                       [sensor1 sensor2],[leftMotor rightMotor],odometer,compass,brain);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
showPlot = true;
plotStep = 10;
recordResults = true;
testRobot.ShowSensorRays = true;
testRobot.ShowOdometricGhost = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

position = [-1.5000 -1.500];
heading = 0.0000;
velocity = [0.0000 0.0000];
angularSpeed = 0.0000;

testRobot = SetPositionAndVelocity(testRobot, position, heading, velocity, angularSpeed);
if (~isempty(testRobot.Odometer))
 testRobot.Odometer = CalibrateOdometer(testRobot);
end

if (showPlot)
 plotHandle = InitializePlot(testRobot, testArena);
end
if (recordResults)
 motionResults = InitializeMotionResults(testRobot);
end

maxSteps = 100000;
dt = 0.01;
time = 0.0;
collided = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main loop:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1;
while ((i < maxSteps) & (~collided))
   testRobot.RayBasedSensors = GetRayBasedSensorReadings(testRobot,testArena);
   if (~isempty(testRobot.Odometer))
    testRobot.Odometer = GetOdometerReading(testRobot,dt);
   end 
   if (~isempty(testRobot.Compass))
    testRobot.Compass = GetCompassReading(testRobot,dt);
   end  
   testRobot.Brain = BrainStep(testRobot, time);
   testRobot = MoveRobot(testRobot,dt);

   time = i*dt;
   if (recordResults)
    motionResults = AddMotionResults(motionResults,time,testRobot); 
   end

   i = i + 1;

   collided = CheckForCollisions(testArena, testRobot);

   if ((mod(i,plotStep)==0) && showPlot)
    ShowRobot(plotHandle,testRobot);
   end
end
