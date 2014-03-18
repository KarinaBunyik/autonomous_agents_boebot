function l = GetDistanceToLineAlongRay(beta,p1,p2,x1,y1);

tmp1 = sin(beta)*(p2(1)-p1(1))-cos(beta)*(p2(2)-p1(2));

if ((tmp1 > 0) | (tmp1 < 0))
 tmp2 = (p2(2)-p1(2))*(x1-p1(1)) - (p2(1)-p1(1))*(y1-p1(2));
 l = abs(tmp2/tmp1);
else
 l = 100000000.0;
end
 