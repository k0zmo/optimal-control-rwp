clc, clear all, close all, format long e, format compact

run modelparams;
tau = [0 2 4];
u0 = umax;

[dQ,Q,x,t,psi,H1] = gradient(tau, u0);

plot(t, H1);

% odchylki czasow przelaczen
hh = 0:h:20*h;
% wektor wskaznikow jakosci dla podanych odchylek
Qq = zeros(1, length(hh));
disp(strcat('Q=', num2str(Q)));
Qq(1) = Q;

for ii = 2:length(hh)
    eps = hh(ii);

    %% sterowanie
    tau = tau(end)/2 + eps;

    Q = cost(tau, u0);
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