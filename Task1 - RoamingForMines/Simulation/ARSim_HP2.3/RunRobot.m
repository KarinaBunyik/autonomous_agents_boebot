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
arenaSize = [-2 2 -2 2]; 
arenaObject1 = CreateArenaObject('arenaObject1',[[-0.9 0.9]; [-0.9 0.7]; [-0.7 0.7]; [-0.7 0.9]]);
arenaObject2 = CreateArenaObject('arenaObject2',[[-2.0 -2.0]; [-1.8 -2.0]; [-1.8 2.0]; [-2.0 2.0]]);
arenaObject3 = CreateArenaObject('arenaObject3',[[-1.8 -2.0]; [1.8 -2.0]; [1.8 -1.8]; [-1.8 -1.8]]);
arenaObject4 = CreateArenaObject('arenaObject4',[[2.0 -2.0]; [1.8 -2.0]; [1.8 2.0]; [2.0 2.0]]);
arenaObject5 = CreateArenaObject('arenaObject5',[[-1.8 2.0]; [1.8 2.0]; [1.8 1.8]; [-1.8 1.8]]);
arenaObject6 = CreateArenaObject('arenaObject6',[[0.9 -0.9]; [0.9 -0.7]; [0.7 -0.7]; [0.7 -0.9]]);
testArena = CreateArena('arena',arenaSize,[arenaObject1; arenaObject2; arenaObject3;...
                                           arenaObject4; arenaObject5; arenaObject6]);
%testArena = CreateArena('arena',arenaSize,[arenaObject2; arenaObject3;...
%                                           arenaObject4; arenaObject5;]);


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
sigma = 0.0100;
sensor1 = CreateIRSensor('sensor1',sensor1RelativeAngle,size,...
                          numberOfRays,openingAngle,range,c1,c2,sigma);
sensor2 = CreateIRSensor('sensor2',sensor2RelativeAngle,size,...
                          numberOfRays,openingAngle,range,c1,c2,sigma);

%%%%%%%%%%%%%%%%%%%%
% Odometer:
%%%%%%%%%%%%%%%%%%%%e
sigma = 0.0000;     % Measures the odometric drift
odometer = CreateOdometer('odometer',sigma);



%%%%%%%%%%%%%%%%%%%%
% Motors:
%%%%%%%%%%%%%%%%%%%%
leftMotor = CreateMotor('leftMotor');
rightMotor = CreateMotor('rightMotor');
mass = 3.0000;
momentOfInertia = 0.2000;
radius = 0.2000;
wheelRadius = 0.1000;


%% Robot with IR sensors and odometer:
   testRobot = CreateRobot('TestRobot',mass,momentOfInertia,radius,wheelRadius, ...
                        [sensor1 sensor2],[leftMotor rightMotor],odometer,[],brain);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
showPlot = true;
plotStep = 10;
recordResults = true;
testRobot.ShowSensorRays = false;
testRobot.ShowOdometricGhost = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%position = [-0.2000 0.0000];
position = [0.0000 0.0000];
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

maxSteps = 2000;
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
