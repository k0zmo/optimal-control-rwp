clc, clear;

modelparams;

%% sterowanie bazowe
u0 = umin;
stime = Tk/2; % czasy przelaczen
si = length(stime);

%% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
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

%% calkowanie rownan sprzezonych w tyl
psiTk = R*(xf - xT); % warunek koncowy na Psi
psi = rk4r('comodel', x, t, psiTk);

%% Pochodna wskaznika jakosci wzgledem czasow przelaczen
dQ = costfuncderivatives(stimei, u, psi);

% odchylki czasow przelaczen
hh = 0:0.01:0.2;
% wektor wskaznikow jakosci dla podanych odchylek
Qq = zeros(1,length(hh));
disp(strcat('Q=',num2str(Q)));
Qq(1) = Q;

figure(1)
hold on, grid on
plot(t, x(1,:),'b',t,x(2,:),'r')

figure(2)
hold on, grid on
plot(t, x(4,:),'b',t,x(3,:),'r')

for ii = 2:length(hh)
    delta_u = hh(ii);

    %% sterowanie
    u0 = umin;
    stime = Tk/2 + delta_u; % czasy przelaczen
    si = length(stime);

    %% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
    [u, t, stimei] = control(stime, [u0 umax umin], t);

    %% calkowanie rk4 w przod
    x = rk4('model', u, t, x0);
    % stan koncowy
    xT = x(:,length(x));

    figure(1)
    plot(t, x(1,:),'b', t,x(2,:),'r', t,u,'g')
    figure(2)
    plot(t, x(3,:),'b',t,x(4,:),'r')

    Q_ = costfun(xT);
    disp(strcat('Obliczenia dla delta_u=',num2str(delta_u, '%01.4f'), ...
        ' Q=',num2str(Q_)));

    %% calkowanie rownan sprzezonych w tyl
    % tego tutaj nie potrzebujemy
    %psiTk = R*(xf - xT); % warunek koncowy na Psi
    %psi = rk4r('comodel', x, t, psiTk);

    %% wartosc wskaznika jakosci
    Qq(ii) = (Q_ - Qq(1))/delta_u;
end

figure(1)
hold off
figure(2)
hold off

figure(3)
hold on;
plot(hh(2:length(hh)),Qq(2:length(Qq)),'or');
plot([hh(1) hh(length(hh))],[dQ dQ],'g');
grid;
legend('pochodna szacowana','pochodna dok³adna');
xlabel('delta u');
hold off