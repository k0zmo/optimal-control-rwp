clc, clear;

%% parametry fizyczne ukladu
global m g l J Jr k
m = 0.3014;
g = 9.81;
l = 0.12;
J = 0.004572;
Jr = 0.00002495;
k = 0.0274;

umax = 3;
umin = -umax;

%% parametry wskaznika jakosci
global R
R = eye(4,4);
R(1,1)=1;
R(2,2)=1;
R(3,3)=0;
R(4,4)=1;

%% parametry symulacji

% czas poczatkowy
t0 = 0;
% krok calkowania
h = 0.01;
% horyzont czasowy
Tk = 4;
% os czasu
t = t0:h:Tk;
% ilosc krokow
ti = length(t);

% warunek poczatkowy
x0 = [-pi; % kat wahadla (kat 0 to 'gora', kierunek zgodnie ze wsk. zegara)
      0; % predkosc wahadla
      0; % kat walu napedowego
      0]; % predkosc walu napedowego
  
% warunek koncowy
global xf
xf = [0; 0; 0; 0];

%% sterowanie - czasy przelaczen
stime = [0.3 0.56 0.9 1.567 2.023]; % czasy przelaczen (w sekundach)

%  % czasy przelaczen (w sekundach)
%  stime = [];
%  for i=0.2:0.5:Tk
%  	stime = [stime i];
%  end
si = length(stime);
disp(strcat('ilosc przelaczen=',num2str(si)));

% do wektora czasu 'wstrzyknij' czasy sterowania
% tj. jesli mamy krok 0.01 a czas przelaczenia wystepuje w 3.603 s
% to nalezy rozszerzyc wektor czasu o dodatkowy skladnik aby nie
% przeskoczyc tej chwili calkujac rownania
for i = 1:si
    for j = 1:length(t)
        if j > 1 && stime(i) < t(j) && stime(i) > t(j-1)
            % trzeba 'wstrzyknac' dodatkowa chwile czasowa
            t = [t(1:j-1) stime(i) t(j:ti)];
            ti = ti + 1;
            break
        end
    end
end

%% generowanie wektora sterowania
u0 = umin; % wartosc poczatkowa sterowania (w chwili t0)
u = u0*ones(1, ti); % wektor sterowania

uS = u0;
i = 1;
stimei = zeros(1, si); % indeksy czasow przelaczen

for si = 1:si
	while stime(si) > t(i)
		u(i) = uS;
		i = i + 1;
	end

	stimei = [stimei i];

	if uS == umax
		uS = umin;
	else
		uS = umax;
	end
end

% przypadek nieparzystej ilosci przelaczenia
if mod(si,2) ~= 0
	for ii = i:length(t)
		u(ii)  = uS;
	end
end

%  if u0 == umax
%  	uS = umin
%  else
%  	uS = umax
%  end
%  stimei = zeros(1, si); % indeksy chwil przelaczen
%  
%  for i = 1:2:si-1
%      stimei(i) = find(t == stime(i));
%      stimei(i+1) = find(t == stime(i+1));
%  	% przedzial < stime(i),stime(i+1) )
%      u(stimei(i):stimei(i+1)-1) = uS;
%  end
%  %
%  % przypadek nieparzystej ilosci przelaczen
%  if mod(si,2) ~= 0
%      i = length(stimei);
%      stimei(i) = find(t == stime(i));
%      u(stimei(i):ti) = uS;
%  end


%% calkowanie rk4 w przod
x = rk4('model', u, t, x0);

figId = 1
figure(figId)
plot(t,x(1,:), t,x(2,:), t, u);
legend('k¹t wahad³a','prêdkoœæ wahad³a', 'sterowanie');
title('Trajektorie systemu dla przyk³adowego sterowania');
grid on
figId = figId + 1;

%  figure(figId)
%  plot(t,x(3,:), t, x(4,:));
%  legend('k¹t wa³u napêdowego', 'prêdkoœæ wa³u napêdowego');
%  title('Trajektorie systemu dla przyk³adowego sterowania');
%  grid on
%  figId = figId + 1;
%  
%  % stan koncowy
%  xT = x(:,length(x));
%  Q = costfun(xT, Tk);
%  
%  %% calkowanie rownan sprzezonych
%  
%  % warunek koncowy na Psi
%  psiTk = R*(xf - xT);
%  
%  % calkowanie w tyl
%  psi = rk4r('comodel', x, t, psiTk);
%  
%  figure(figId)
%  plot(t,psi(1,:), t,psi(2,:));
%  title({'Trajektorie systemu sprzê¿onego '
%      'dla przyk³adowego sterowania'});
%  legend('psi1','psi2');
%  grid on
%  figId = figId + 1;
%  
%  %  figure(figId)
%  %  plot(t,psi(3,:), t,psi(4,:));
%  %  title({'Trajektorie systemu sprzê¿onego '
%  %      'dla przyk³adowego sterowania'});
%  %  legend('psi3','psi4');
%  %  grid on
%  %  figId = figId + 1;
%  
%  %% Funkcja przelaczajaca
%  switching_fun = @(psi) -k/J*psi(2,:) + k/Jr*psi(4,:);
%  switching = switching_fun(psi);
%  
%  figure(figId);
%  plot(t, switching, '.-b');
%  title('Sterownanie i funkcja prze³¹czaj¹ca');
%  %legend('
%  grid on
