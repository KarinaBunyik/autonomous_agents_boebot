function b = CreateBrain;

%% ADD CODE BELOW:


%% Variables:

leftMotorSignal = 0;
rightMotorSignal = 0;
currentState = 0;

%% Parameters:
forwardMotorSignal = 0.5;
turnMotorSignal = 0.7;
turnProbability = 0.01;
stopTurnProbability = 0.03;
leftTurnProbability = 0.50;
foundWall = 0;


b = struct('LeftMotorSignal',leftMotorSignal,...
           'RightMotorSignal',rightMotorSignal,...
           'CurrentState',currentState, ...
           'ForwardMotorSignal',forwardMotorSignal,...
           'TurnMotorSignal',turnMotorSignal,...
           'TurnProbability',turnProbability,...
           'StopTurnProbability',stopTurnProbability,...
           'LeftTurnProbability',leftTurnProbability, ...
           'FoundWall',foundWall);
       