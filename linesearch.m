function [xopt] = linesearch(tau0, sd, f0, u0, x0, h0, xf)

% Obliczenie maksymalnego, dopuszczalnego kroku
sd=[0, sd', 0];
dd = diff(sd);
dtau = diff(tau0);
jj = find(dd<0);
smax = min([inf,-dtau(jj)./dd(jj)]);

% Sprawdzenie wsk. jakosci dla maksymalnego, dopuszczalnego kroku
if smax < inf
    Q = rk4(tau0 + smax*sd, u0, x0, h0, xf);
    if Q < f0
        xopt = tau0 + smax*sd;
        return
    end
end

s(1) = 0;
f(1) = f0;
s(2) = min([1, smax]);

% Proste, iteracyjne poszukiwanie na kierunku (kontrakcja)
for i = 2:20
    f(i) = rk4(tau0 + s(i)*sd, u0, x0, h0, xf);
    
    if f(i) < f0
		break
	end
	
    s(i+1) = s(i)/4;
end

[~,iopt] = min(f);
xopt = tau0 + s(iopt)*sd;