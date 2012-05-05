clc, clear;

run modelparams;

%% sterowanie
u0 = umin; % wartosc poczatkowa sterowania (w chwili t0)
%stime = [0.3 0.56 0.9 1.567 2.023 2.68 3.14 3.54 3.889]; % czasy przelaczen (w sekundach)
stime = Tk/2;
% czasy przelaczen (w sekundach)
%stime = Tk/2;
si = length(stime);
disp(strcat('ilosc przelaczen=',num2str(si)));

%% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
[u, t, stimei] = control(stime, [u0 umax umin], t);

%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);
% stan koncowy
xT = x(:,length(x));
Q = costfun(xT);

%% calkowanie rownan sprzezonych w tyl
psiTk = R*(xf - xT); % warunek koncowy na Psi
psi = rk4r('comodel', x, t, psiTk);

figId = 1;
figure(figId)
plot(t,x(1,:), t,x(2,:), t, u);
legend('k¹t wahad³a','prêdkoœæ wahad³a', 'sterowanie');
title('Trajektorie systemu dla przyk³adowego sterowania');
grid on
figId = figId + 1;

figure(figId)
plot(t,x(3,:), t, x(4,:));
legend('k¹t wa³u napêdowego', 'prêdkoœæ wa³u napêdowego');
title('Trajektorie systemu dla przyk³adowego sterowania');
grid on
figId = figId + 1;

 switching = switching_fun(psi);
 figure(figId);
 plot(t, switching, '-b');
 title('Sterownanie i funkcja prze³¹czaj¹ca');
 grid on
