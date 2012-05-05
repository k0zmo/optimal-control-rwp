function [xopt, fopt] = linesearch1(p0,u0,sd,f0,smax)
if smax < inf
	Q = recalculate(p0, u0, sd, smax);
	if Q < f0
		xopt = p0 + smax*sd;
		fopt = Q;
		return
	end
end

s(1) = 0;
f(1) = f0;
s(2) = min([1,smax]);
for i=2:20
	f(i) = recalculate(p0, u0, sd, s(i));
	if f(i) < f0, break, end
	s(i+1) = s(i)/4;
end
[fopt,iopt] = min(f);
xopt = p0 + s(iopt) * sd;
