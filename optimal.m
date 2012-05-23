clc, clear all, close all, format long e, format compact

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
global Tk

result_files = {'results/tau40.txt';
    'results/tau41.txt'; 
    'results/tau42.txt';
    'results/tau43.txt';
    'results/tau44.txt';
    'results/tau45.txt';
    'results/tau46.txt';
    'results/tau47.txt';
    'results/tau48.txt';
    'results/tau49.txt';
    'results/tau50.txt';
    'results/tau51.txt';
    };

T = 4:0.1:5.1;
xT = inf*ones(length(T),length(x0));
QT = inf*ones(length(T),1);

for i=1:length(result_files)
    result = load(char(result_files(i)));
    Tk = result(end);
    u0 = result(end-1);
    tau = result(1:end-2)';

    [dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf);
    QT(i) = Q;
    xT(i, :) = x(end, :);
end
figure(1),
plot(T,QT,'b-*');
xlabel('horyzont czasowy T');
ylabel('wartosc wskaznika jakosci Q');
grid on

% xT3 = xT(:, [1:2 4]);
% nxT3 = inf*ones(length(T));
% for i=1:length(T)
%     nxT3(i) = norm(xT3(i,:));
% end
% subplot(2,1,2), plot(T,nxT3,'b-*');
