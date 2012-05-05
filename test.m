clc, clear;

run modelparams;

%% sterowanie bazowe
u0 = umin;
stime = [0 2.3 2.31]; % czasy przelaczen
si = length(stime);

%hh = 0;%:0.005:0.1;
hh = h:h:Tk;
q = [];
figure(1)
hold on, grid on

for ii = 1:length(hh)
    delta_u = hh(ii);
    
    u0 = umin;
    %stime = Tk/2 + delta_u; % czasy przelaczen
    stime = delta_u;
    %si = length(stime); 
    
    %% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
    [u, t, stimei] = control(stime, [u0 umax umin], t);
    %stimei, t(stimei)
    %plot(t,u);
    %axis([0 Tk umin-1 umax+1]);
    
    x = rk4('model', u, t, x0);
    % stan koncowy
    xT = x(:,length(x));
    % wartosc wskaznika jakosci
    Q = costfun(xT);
    q = [q Q];
    
%     psiTk = R*(xf - xT); % warunek koncowy na Psi
%     psi = rk4r('comodel', x, t, psiTk);
% 
%     % figure, hold on, grid,
%     % plot(t, x(1,:), 'Color', [0 0 1]);
%     % plot(t, x(2,:), 'Color', [0 0.5 0]);
%     % plot(t, u, 'Color', [1 0 0]);
% 
%     %% Pochodna wskaznika jakosci wzgledem czasow przelaczen
%     dQ = costfuncderivatives(stimei, u, psi); 
%     dQ
end

plot(q)