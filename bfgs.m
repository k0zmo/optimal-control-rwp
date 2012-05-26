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
itmax = 500;

% Przyblizenie poczatkowe sterowania
u0 = 1;
global Tk
Tk = 4.9;
tau = []';
totalit = 0;
% [dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf);
% plotcharts(t,x,H1,tau,u0);
while 1
    
    %
    % BFGS
    %
    R = 1;
    
    % R = 0 : kolejny krok, macierz v liczona z iteracyjnego wzoru
    % R = 1 : poczatek bfgs'u lub po nietrywialnej redukcji
    % R = 2 : odnowa (bez przeliczenia gradientu) po zajsciu dQ'*d >= 0
    
    % Czestosc odnowy
    czod = length(tau);
    od = 1;
    for ii = 1:itmax
        totalit = totalit + 1;
        if R < 2
            [dQ, Q, x, t, psi, H1, u] = gradient(tau, u0, x0, h0, xf);
            disp([Q norm(dQ)])
            
            % Sprawdz warunek na norme gradientu
            if norm(dQ) < 1e-6
                disp('norm_dQ < 1e-6, STOP')
                break
            end
            
            % Sprawdz warunek na maksymalna liczbe iteracji
            if ii > itmax
                disp('current iteration count > maxit, STOP');
                break
            end
        end
        
        % Odnowa gradientu
        if R > 0 || od == czod
            w = eye(length(tau));
            d = -dQ;
            disp(strcat('renewal (od=', num2str(od),'/', num2str(czod),')'));
            od = 0;
        else
            r = dQ - gs;
            s = (tau - tau_s)';
            
            ws = w*s;
            w = w + r*r'/(r'*s) - vs*vs'/(s'*vs);
            d = -w\dQ;

            od = od+1;
        end

        if dQ'*d >= 0
            R = 2;
        else
            tau_s = tau;
            gs = dQ;

            tau = linesearch(tau, d, Q, u0, x0, h0, xf);
            if max(abs(tau - tau_s)) > 1e-8
                R = 0;
                [tau, u0, R] = reduction(tau, u0, R);
            else
                % Dla R = 0 'dajemy' jeszcze jedna szanse
                if R == 0
                    R = 2;
                else
                    % Nie nastapila poprawa
                    disp('no more improvement, STOP')
                    break
                end
            end
        end
    end
	
	disp(' ');
    tau'
    disp(' ');
    
    %
    % Generacja szpilkowa
    %
    ur = uranges(tau, h0);	
	tmp = u.*H1;
	out = ur(2:end-1);
	
	[Emin,imin] = min(tmp);
	% Blokada generacji szpilki w miejscu przelaczenia sterowania
	while any(out == imin)
		tmp(imin) = inf;
		[Emin,imin] = min(tmp);
	end
    
    if Emin > -1e-6
        disp('switching function synced with control, STOP')
        [Q, norm(dQ)]
        break
    else
        % Generacja dla chwili poczatkowej - zmiana sterowania poczatkowego
        if imin == 1
            tau = [0 tau];
            u0 = -u0;
        % Generacja dla chwili koncowej
        elseif imin == length(t)
            tau = [tau Tk];
        % Generacja "gdzies" w srodku
        else
            tau = [t(imin) t(imin) tau];
            tau = sort(tau);
        end
    end
    
    %plotcharts(t, x, H1, tau, u0, imin);
    %pause(10)
end

plotcharts(t, x, H1, tau, u0);
totalit