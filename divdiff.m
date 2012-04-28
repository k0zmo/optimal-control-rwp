clc, clear;

modelparams;
R=0.0001*R;

%% sterowanie bazowe
u0 = umin;
stime = Tk/2; % czasy przelaczen
si = length(stime);

%% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
[u, t] = control(stime, [u0 umax umin], t);

%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);
% stan koncowy
xT = x(:,length(x));
% wartosc wskaznika jakosci
Q = costfun(xT);

%% calkowanie rownan sprzezonych w tyl
psiTk = R*(xf - xT); % warunek koncowy na Psi
psi = rk4r('comodel', x, t, psiTk);

%% Pochodne wskaznika jakosci wzgledem czasow przelaczen
du = zeros(1, si);
i = 1;
for j = 1:si
    while stime(j) > t(i)
        i = i + 1;
    end
    fswitch = switching_fun(psi(:,i));
    du(j) = fswitch * (u(i+1)-u(1));
end

% odchylki czasow przelaczen
hh = 0:0.005:0.1;
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
    disp(strcat('Obliczenia dla delta_u1=',num2str(delta_u)));

    %% sterowanie
    u0 = umin;
    stime = Tk/2 + delta_u; % czasy przelaczen
    si = length(stime);

    %% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
    [u, t] = control(stime, [u0 umax umin], t);
    %     plot(t,u,'r');

    %% calkowanie rk4 w przod
    x = rk4('model', u, t, x0);
    % stan koncowy
    xT = x(:,length(x));

    figure(1)
    plot(t, x(1,:),'b',t,x(2,:),'r')
    figure(2)
    plot(t, x(3,:),'b',t,x(4,:),'r')

    Q_ = costfun(xT);
    disp(strcat('Q=',num2str(Q_)));

    %% calkowanie rownan sprzezonych w tyl
    psiTk = R*(xf - xT); % warunek koncowy na Psi
    psi = rk4r('comodel', x, t, psiTk);

    % wartosc wskaznika jakosci
    Qq(ii) = (Q_ - Qq(1))/delta_u;
end

figure(1)
hold off
figure(2)
hold off

figure(3)
hold on;
plot(hh(2:length(hh)),Qq(2:length(Qq)),'.r');
plot([0 hh(length(hh))],[du du],'g');
grid;
legend('pochodna szacowana','pochodna dok³adna');
hold off