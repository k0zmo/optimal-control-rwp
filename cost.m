function Q = cost(tau,u0,t)
global umax umin x0

%% generuj sterowanie dla podanych czasow przelaczen, sterowania 
%  poczatkowego oraz osi czasu
[u, t] = control(tau, [u0 umax umin], t);

% u - wygenerowane sterowanie
% t - skorygowany czas o chwile przelaczen

%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);
% stan koncowy
xT = x(:,end);
% wartosc wskaznika jakosci
Q = costfun(xT);