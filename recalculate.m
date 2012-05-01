function [Q,dQ,x_,t_,u_,psi_] = recalculate(stime,d,s)
modelparams;

% stime = stime + d*s
if nargin == 2, stime = stime + d;
elseif nargin == 3, stime = stime + d*s;
end

%% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
u0 = umin;
[u, t, stimei] = control(stime, [u0 umax umin], t);
% u - wygenerowane sterowanie
% t - skorygowany czas o chwile przelaczen
% stimei - indeks czasu przelaczen w wektorze czasu t

%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);
% stan koncowy
xT = x(:,length(x));
% wartosc wskaznika jakosci
Q = costfun(xT);

if nargout >= 2 
    %% calkowanie rownan sprzezonych w tyl
    psiTk = R*(xf - xT); % warunek koncowy na Psi
    psi = rk4r('comodel', x, t, psiTk);

    % figure, hold on, grid,
    % plot(t, x(1,:), 'Color', [0 0 1]);
    % plot(t, x(2,:), 'Color', [0 0.5 0]);
    % plot(t, u, 'Color', [1 0 0]);

    %% Pochodna wskaznika jakosci wzgledem czasow przelaczen
    dQ = costfuncderivatives(stimei, u, psi);
end

if nargout >= 3, x_ = x; end,
if nargout >= 4, t_ = t; end,
if nargout >= 5, u_ = u; end,
if nargout >= 6, psi_ = psi; end,
