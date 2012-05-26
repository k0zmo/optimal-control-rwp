clc, clear all, close all, format short, format compact

% Parametry fizyczny ukladu
global m g l J Jr k
m = 0.3014;
g = 9.81;
l = 0.12;
J = 0.004572;
Jr = 0.00002495;
k = 0.0274;

% Macierz wagowa dla wskaznika jakosci
global W
W = eye(4,4);
W(1,1) = 50;
W(2,2) = 50;
W(3,3) = 0;
W(4,4) = 1;

% Warunki poczatkowy i koncowy
x0 = [-pi 0 0 0];
xf = [0 0 0 0];

% Krok calkowania
h0 = 0.01;
itmax = 500;

% Przyblizenie poczatkowe sterowania
u0 = 1;
global Tk
Tk = 4;
tau = 2;

[dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf);

% odchylki czasow przelaczen
hh = h0:h0:20*h0;
% wektor wskaznikow jakosci dla podanych odchylek
Qq = zeros(1, length(hh));
disp(strcat('Q=', num2str(Q)));

for ii = 1:length(hh)
    eps = hh(ii);

    %% sterowanie
    tau = 2 + eps;

    qQ = rk4(tau, u0, x0, h0, xf);
    disp(strcat('Obliczenia dla eps=',num2str(eps, '%01.4f'), ...
        ' Q=',num2str(qQ)));


    %% wartosc wskaznika jakosci
    Qq(ii) = (qQ - Q)/eps;
end

figure(1)
hold on;
plot(hh,Qq,':*r', 'MarkerSize',10);
plot([0 hh(end)],[dQ dQ],'b', 'LineWidth', 2);
grid;
legend('iloraz roznicowy','pochodna dokladna');
title('Weryfikacja pochodnej');
xlabel('\epsilon');
hold off