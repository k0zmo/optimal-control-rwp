function [x] = rk4(odefun, u, tspan, x0)
% odefun - nazwa funkcji prawej strony rownania x'(t) = f(x(t),u(t))
% u      - sterowanie
% tspan  - os czasu
% x0     - warunek poczatkowy

if length(tspan) < 3
    return;
end

hbase = tspan(2) - tspan(1);

% ilosc krokow
ti = length(tspan);

% funkcja wyjsciowa x(t) - inicjalizacja zerami
x = zeros(length(x0), ti);

% warunek poczatkowy
x(:,1) = x0;

for i = 1:ti-1
    % dlugosc kroku calkowania
    h = tspan(i+1) - tspan(i);
    if  abs(h - hbase) > 10e-6
        disp(['rk4: Zmieniam krok na ', num2str(h), ...
            ' dla t=', num2str(tspan(i))]);
    end
    
    % sterowanie w tym kroku, nastepnym i w polowie
    u1 = u(i);
    u2 = u(i+1);
    u12 = (u1+u2)/2;
 
    % wspolczynniki RK
    k_1 = h * feval(odefun, x(:,i)          , u1 );
    k_2 = h * feval(odefun, x(:,i) + 0.5*k_1, u12); 
    k_3 = h * feval(odefun, x(:,i) + 0.5*k_2, u12); 
    k_4 = h * feval(odefun, x(:,i) + k_3    , u2 ); 
    
    delta = (k_1 + 2*(k_2 + k_3) + k_4) / 6;
    x(:,i+1) = x(:,i) + delta;
end
