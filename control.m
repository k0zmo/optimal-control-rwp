function [u, t, stimei] = control(stime, uparams, t)

ti = length(t); % ilosc krokow
si = length(stime);

% do wektora czasu 'wstrzyknij' czasy sterowania
% tj. jesli mamy krok 0.01 a czas przelaczenia wystepuje w 3.603 s
% to nalezy rozszerzyc wektor czasu o dodatkowy skladnik aby nie
% przeskoczyc tej chwili calkujac rownania
epsilon = 10e-9;
for i = 1:si
    for j = 1:length(t)
        if j > 1 && ...
                stime(i) < t(j) && ...
                stime(i) > t(j-1) && ...
                abs(stime(i) - t(j-1)) > epsilon
            % trzeba 'wstrzyknac' dodatkowa chwile czasowa
            t = [t(1:j-1) stime(i) t(j:ti)];
            ti = ti + 1;
            break
        end
    end
end

u0   = uparams(1);
umax = uparams(2);
umin = uparams(3);

%% generowanie wektora sterowania
u = u0*ones(1, ti); % wektor sterowania
uS = u0;
stimei = zeros(1, si); % indeksy czasow przelaczen

i = 1;
for j = 1:si
    while stime(j) > t(i) && abs(stime(j) - t(i)) > epsilon
        u(i) = uS;
        i = i + 1;
    end

    stimei(j) = i;

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