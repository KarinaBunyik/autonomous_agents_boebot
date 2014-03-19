function v = ScaleMotorSignals(robot,s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Note: this function rescales the motor signals
%       to the appropriate voltage range.
%       The input motor signals (s), should be
%       in the range [-1,1].
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v(1) = s(1)*robot.Motors(1).MaximumVoltage;
v(2) = s(2)*robot.Motors(2).MaximumVoltage;


