function [ur, n] = uranges(tau, h0)
global Tk
dtau = diff([0 tau Tk]);
n = ceil(dtau/h0);
ur = 1;
for i=1:length(n)
	ur = [ur ur(end)+n(i)];
end