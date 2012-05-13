function [xopt, fopt] = linesearch(tau0,u0,f0,sd,t)

% Obliczenie maksymalnego, dopuszczalnego kroku
global Tk
tau_ = [0 tau0 Tk];
dd = [0 sd' 0];
dtau = diff(tau_);
dD = diff(dd);
jj = find(dD < 0);
smax = min([inf -dtau(jj)./dD(jj)]);

tau0 = tau0';

% Sprawdzenie wsk. jakosci dla maksymalnego, dopuszczalnego kroku
if smax < inf
	Q = cost(tau0+sd*smax, u0, t);
    % Wartosc optymalna lezy na brzegu ograniczen
	if Q < f0
		xopt = (tau0+smax*sd)';
		fopt = Q;
		return
	end
end

% Proste, iteracyjne poszukiwanie na kierunku (kontrakcja)
s(1) = 0;
f(1) = f0;
s(2) = min([1,smax]);
for i=2:20
	f(i) = cost(tau0+sd*s(i), u0, t);
	if f(i) < f0, break, end
	s(i+1) = s(i)/4;
end
[fopt,iopt] = min(f);
xopt = (tau0 + s(iopt)*sd)';
