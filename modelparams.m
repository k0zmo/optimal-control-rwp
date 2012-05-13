%% parametry fizyczne ukladu
global m g l J Jr k
m = 0.3014;
g = 9.81;
l = 0.12;
J = 0.004572;
Jr = 0.00002495;
k = 0.0274;

global umax
umax = 3;

%% parametry wskaznika jakosci
global R
R = eye(4,4);
R(1,1)=5;
R(2,2)=1;
R(3,3)=0;
R(4,4)=0.1;

%% parametry symulacji
global h

% czas poczatkowy
t0 = 0;
% krok calkowania
h = 0.01;

global x0 xf
% warunek poczatkowy
x0 = [-pi; % kat wahadla (kat 0 to 'gora', kierunek zgodnie ze wsk. zegara)
      0; % predkosc wahadla
      0; % kat walu napedowego
      0]; % predkosc walu napedowego

% warunek koncowy
xf = [0; 0; 0; 0];
