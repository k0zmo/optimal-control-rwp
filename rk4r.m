function [psi] = rk4r(odefun, x, tspan, psiT)
% odefun - nazwa funkcji prawej strony rownania x'(t) = f(x(t),u(t))
% x      - stan
% tspan  - os czasu
% psiT   - warunek koncowy

if length(tspan) < 3
    return;
end

hbase = tspan(2) - tspan(1);
hbase = -hbase;

% ilosc krokow
ti = length(tspan);

% funkcja wyjsciowa psi(t) - inicjalizacja zerami
psi = zeros(length(psiT), ti);

% warunek koncowy
psi(:,ti) = psiT;

for i=ti:-1:2
    % dlugosc kroku calkowania
    h = tspan(i-1) - tspan(i);
%     if  abs(h - hbase) > 10e-6
%         disp(['rk4r: Zmieniam krok na ', num2str(h), ...
%             ' dla t=', num2str(tspan(i))]);
%     end    
    
    % stan systemu w tym kroku, nastepnym i w polowie
    x1  = x(:,i);
    x2  = x(:,i-1);
    x12 = (x1+x2)/2;
 
    % wspolczyniki RK
    k_1 = h * feval(odefun, psi(:,i)          , x1 );
    k_2 = h * feval(odefun, psi(:,i) + 0.5*k_1, x12);
    k_3 = h * feval(odefun, psi(:,i) + 0.5*k_2, x12);
    k_4 = h * feval(odefun, psi(:,i) + k_3    , x2 );
    
    delta = (k_1 + 2*(k_2 + k_3) + k_4) / 6;
    psi(:,i-1) = psi(:,i) + delta;
end
