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
tau = [0 6];
% tau = [0 ...
       % 0.320442088279850 ...
       % 0.672332341747813 ...
       % 1.03879224785509  ...
       % 1.39605063379000  ...
       % 1.77113896662658  ...
       % 2.13949137853098  ...
       % 2.53071593191578  ...
       % 2.91937618277572  ...
       % 3.34093941161981  ...
       % 3.76995387279265  ...
       % 4.26485055703642  ...
       % 4.86967491738520  ...
       % 5];

% [dQ, Q, x, t, psi, H1, u] = gradient(tau,u0,x0,h0,xf);
% plotcharts(t, x, H1, tau, u0);
% pause(5)

while 1
    
    %
    % BFGS
    %
    rc = 1;
    % Czestosc odnowy
    czod = length(tau(2:end-1));
    od = 0;
    for ii = 1:itmax
        if rc
            [dQ, Q, x, t, psi, H1, u] = gradient(tau,u0,x0,h0,xf);
            norm_dQ = norm(dQ);
            disp([Q norm_dQ])
            
            % Sprawdz warunek na norme gradientu
            if norm_dQ < 1e-6
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
        if rc < 2 || od == czod
            V = eye(length(tau) - 2);
            d = -dQ;
            disp(strcat('renewal (od=', num2str(od),'/', num2str(czod),')'));
            od = 0;
        else
            R = dQ - dQ_s;
            S=(tau(2:end-1) - tau_s(2:end-1))';
            
            SR = S' * R;
            VR = V * R;
            VRS = VR * S';
            
            % z formuly Shermana-Morrisona v=inv(W), Wd=-gradient(x0)
            V = V +  (1 + R'*VR)/SR * (S*S')/SR - (VRS+VRS')/SR;
            d = -V*dQ;

            od = od+1;
        end

        if dQ'*d < 0
            tau_s = tau;
            dQ_s = dQ;

            tau = linesearch(tau, d, Q, u0, x0, h0, xf);
            if max(abs(tau - tau_s))
                rc = 2;
                [tau, u0, rc] = reduction(tau, u0, rc);
            else
                if rc < 2
                    disp('no more improvement, STOP')
                    break
                end
                rc = 0;
            end
        else
            rc=  0;
        end
    end
	
	disp('after bfgs');
    
    %
    % Generacja szpilkowa
    %
    dtau = diff(tau);
    n = ceil(dtau/h0);
    nc = cumsum([1 n]);
	
	tmp = u.*H1;
	out = nc(2:end-1);
	
	[Emin,imin] = min(tmp);
	% Blokada generacji szpilki w miejscu przelaczenia sterowania
	while ~isempty(find(out == imin))
		tmp(imin) = inf;
		[Emin,imin] = min(tmp);
	end
    
    % dtau=diff(tau);
    % n=ceil(dtau/h0);
    % nc=cumsum([1 n]);
    % u=u0;
    % Emin=inf;
    % imin=0;
    % for j=1:length(dtau)
        % ii=nc(j)+1:nc(j+1)-1;
        % if j==1, ii=[1 ii]; end
        % if j==length(dtau), ii=[ii nc(end)]; end
		% %[ii(1) ii(end)]
        % [Ej iminj]=min(u*H1(ii));
        % if Ej<Emin
            % Emin=Ej;
            % imin=ii(1)-1+iminj;
        % end
        % u=-u;
    % end
	
	% [Emin, imin]
    
    if Emin > -1e-6
        disp('Cost derivative below 1e-6, STOP')
        break
    else
        % Generacja dla chwili poczatkowej - zmiana sterowania poczatkowego
        if imin == 1
            tau = [0 tau];
            u0 = -u0;
        % Generacja dla chwili koncowej
        elseif imin == length(t)
            tau = [tau tau(end)];
        % Generacja "gdzies" w srodku
        else
            tau = [t(imin) t(imin) tau];
            tau = sort(tau);
        end
    end
    
    plotcharts(t, x, H1, tau, u0, imin);
    pause(3)
end

plotcharts(t, x, H1, tau, u0);