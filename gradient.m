function [dQ,Q,x,t,u,psi] = gradient(tau,u0,t)
global umax umin x0

%% generuj sterowanie dla podanych czasow przelaczen, sterowania 
%  poczatkowego oraz osi czasu
[u, t, taui] = control(tau, [u0 umax umin], t);

% u - wygenerowane sterowanie
% t - skorygowany czas o chwile przelaczen
% taui - indeks czasu przelaczen w wektorze czasu t

%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);
% stan koncowy
xT = x(:,end);
% wartosc wskaznika jakosci
Q = costfun(xT);

%% calkowanie rownan sprzezonych w tyl
psiTk = psi_last(xT); % warunek koncowy na Psi
psi = rk4r('comodel', x, t, psiTk);

%% Pochodna wskaznika jakosci wzgledem czasow przelaczen
dQ = costfuncderivatives(taui, u, psi);
dQ = dQ';
