function m = CreateMotor(name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DC motor:
%
% Constants: 
%
% MaximumVoltage = vMax
% Torque constant cT,
% Elecrical constant cE,
% Armature resistance = rA
% Coulomb friction = fC
% Viscous friction = fv
% MaximumTorque = tmax
% GearRatio = g
% GearEfficiency = gEff;
%
%
% Variables:
%
% AxisAngularVelocity: omega;
% Torque: tau (acting on the axis)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vMax = 12.0000;
cT   =  0.0333;
cE   =  0.0333;
rA   =  0.6200;
fC   =  0.0080;
fV   =  0.0200;
tMax =  1.0000;  
g    =  2.0000;  
gEff =  1.0000;

omega = 0.0;
tau = 0.0;

m = struct('Name',name,...
           'MaximumVoltage',vMax,...
           'TorqueConstant',cT,...
           'ElectricalConstant',cE,...
           'ArmatureResistance',rA,...
           'CoulombFriction',fC,...
           'ViscousFriction',fV,...
           'MaximumTorque',tMax,...
           'GearRatio',g,...
           'GearEfficiency',gEff,...
           'AxisAngularVelocity',omega,...
           'Torque',tau);
         
           
