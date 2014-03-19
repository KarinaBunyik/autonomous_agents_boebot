function m = GetTorque(motor, voltage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NOTE: The axis angular velocity is updated after generating
%       the angular velocity of the wheels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eps = 1e-6;

m = motor;

speedSign = sign(m.AxisAngularVelocity);
shaftAngularVelocity = m.GearRatio*m.AxisAngularVelocity;

tau = m.TorqueConstant*(voltage - shaftAngularVelocity*m.ElectricalConstant)/...
         m.ArmatureResistance;


if (abs(shaftAngularVelocity) < eps)
 
 if (abs(tau) > eps)
  if (m.CoulombFriction > abs(tau))
   tau = 0.0;
  else
   tau = tau - sign(tau)*m.CoulombFriction;
  end
 end

else

 tau = tau - speedSign*m.CoulombFriction - ...
             shaftAngularVelocity*m.ViscousFriction;
 
end

tau = m.GearEfficiency*m.GearRatio*tau;

if (tau > m.MaximumTorque)
  tau = m.MaximumTorque;
elseif (tau < -m.MaximumTorque)
  tau = -m.MaximumTorque;
end

m.Torque = tau;


