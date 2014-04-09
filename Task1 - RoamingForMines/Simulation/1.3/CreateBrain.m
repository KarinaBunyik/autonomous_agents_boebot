function b = CreateBrain;

%% ADD CODE BELOW:


%% Variables:

leftMotorSignal = 0;
rightMotorSignal = 0;
currentState = 0;
corners = 1;

%% Parameters:

forwardMotorSignal = 0.5;
turnMotorSignal = 0.7;


b = struct('LeftMotorSignal',leftMotorSignal,...
           'RightMotorSignal',rightMotorSignal,...
           'CurrentState',currentState, ...
           'ForwardMotorSignal',forwardMotorSignal,...
           'TurnMotorSignal',turnMotorSignal, ...
           'Corners', corners);