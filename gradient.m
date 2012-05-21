function [dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf)
% Calkowanie w przod rownan stanu
[Q, t, x, u] = rk4(tau, u0, x0, h0, xf);
% Calkowanie w tyl rownan sprzezonych
psi = rk4r(tau, x, h0, xf);
% Przebieg funkcji przelaczajacej
H1 = switching_fun(psi);

dTau = diff(tau);
n = ceil(dTau/h0);
nc = cumsum([1 n]);

% Pochodna wskaznika jakosci wzgledem czasow przelaczen
dQ = 2*u0*H1(nc(2:end-1));
% Co druga pochodna ma przeciwny znak
dQ(1:2:end) = -dQ(1:2:end);