function [aMin,aMax] = GetMinMaxAngle(v1,v2);

a1 = atan2(v1(2),v1(1));
a2 = atan2(v2(2),v2(1));

aMin = min(a1,a2);
aMax = max(a1,a2);