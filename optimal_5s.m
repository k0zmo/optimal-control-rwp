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
W(1,1)=50;
W(2,2)=50;
W(3,3)=0;
W(4,4)=1;

% Warunki poczatkowy i koncowy
x0 = [-pi 0 0 0];
xf = [0 0 0 0];

% Krok calkowania
h0=0.01;

% Przyblizenie poczatkowe sterowania
u0=1;
tau = [0                 ...
	   0.320442088279850 ...
	   0.672332341747813 ...
	   1.03879224785509  ...
	   1.39605063379000  ...
	   1.77113896662658  ...
	   2.13949137853098  ...
	   2.53071593191578  ...
	   2.91937618277572  ...
	   3.34093941161981  ...
	   3.76995387279265  ...
	   4.26485055703642  ... 
	   4.86967491738520  ...
	   5];

[dQ, Q, x, t, psi, H1] = gradient(tau, u0, x0, h0, xf);

plotcharts(t, x, H1, tau, u0);