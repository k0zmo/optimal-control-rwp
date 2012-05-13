clc, clear;

run modelparams;

%% sterowanie bazowe
u0 = umin;
tau = Tk/2;
si = length(tau);

%% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
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
psiTk = R*(xf - xT); % warunek koncowy na Psi
psi = rk4r('comodel', x, t, psiTk);

%% Pochodna wskaznika jakosci wzgledem czasow przelaczen
dQ = costfuncderivatives(taui, u, psi);

% odchylki czasow przelaczen
hh = 0:h:20*h;
% wektor wskaznikow jakosci dla podanych odchylek
Qq = zeros(1, length(hh));
disp(strcat('Q=', num2str(Q)));
Qq(1) = Q;

for ii = 2:length(hh)
    eps = hh(ii);

    %% sterowanie
    u0 = umin;
    tau = Tk/2 + eps;

    %% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
    [u, t, taui] = control(tau, [u0 umax umin], t);

    %% calkowanie rk4 w przod
    x = rk4('model', u, t, x0);
    % stan koncowy
    xT = x(:, end);

    Q = costfun(xT);
    disp(strcat('Obliczenia dla eps=',num2str(eps, '%01.4f'), ...
        ' Q=',num2str(Q)));


    %% wartosc wskaznika jakosci
    Qq(ii) = (Q - Qq(1))/eps;
end

figure(1)
hold on;
plot(hh(2:end),Qq(2:end),'or');
plot([hh(1) hh(end)],[dQ dQ],'g');
grid;
legend('iloraz ró¿nicowy','pochodna dok³adna');
title('Weryfikacja pochodnej');
xlabel('\epsilon');
hold off