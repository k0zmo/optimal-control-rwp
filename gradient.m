function [dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf)
% Calkowanie w przod rownan stanu
[Q, t, x, u] = rk4(tau, u0, x0, h0, xf);
% Calkowanie w tyl rownan sprzezonych
psi = rk4r(tau, x, h0, xf);
% Przebieg funkcji przelaczajacej
H1 = switching_fun(psi);

% Pochodna wskaznika jakosci wzgledem czasow przelaczen
ur = uranges(tau, h0);
dQ = 2*u0 * H1(ur(2:end-1));
% Co druga pochodna ma przeciwny znak
dQ(1:2:end) = -dQ(1:2:end);