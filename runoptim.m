clc, clear;
run modelparams;

maxit = 100;
e0 = 1e-4; 
%x0 = [0.5;1.0;1.5;2.0;2.5;3.0;3.5]; % czasy przelaczen poczatkowe
x0 = 1:1:Tk; x0=x0';
n = length(x0); % wymiar przestrzeni
czod = 2*length(x0); % czestosc odnowy
wskaz = 1;

format long

for i=1:maxit
    % gradient w x0
    [q, g] = recalculate(x0);
    
    disp(strcat('q=',num2str(q)));
    %disp('grad=');
    %disp(g');
    %disp('stime=');
    %disp(x0');
    
    % norma gradientu
    n2 = g'*g;
    % warunek stopu
    if n2 < e0, break, end
    % warunek odnowy
    if rem(i,czod) == 1 || wskaz == 1
        v = eye(n);
    else
        % roznica miedzy gradientami z kroku obecnego i poprzedniego
        r = g - gs;
        s = x0 - xs;
        
        sr = s' * r;
        vr = v * r;
        vrs = vr * s';
        % z formuly Shermana-Morrisona v=inv(W), Wd=-gradient(x0)
        v = v+  (1 + r'*vr)/sr * (s*s')/sr - (vrs+vrs')/sr;
    end
    
    d = -v * g;
    if d' * g < 0
        gs = g;
        xs = x0;
        
        % szacuj maksymalny krok
        stimei = [0 x0' Tk];
        d = [0 d' 0];
        dStimei = diff(stimei);
        dD = -diff(d);
        woz = find(dD > 0);
        kns = dStimei(woz) ./ dD(woz);
        maxstep = min([inf kns]);
        
        % szukaj minimum na wyznaczonym kierunku
        %[x0, wskaz] = linesearch1(x0, d, q, maxstep);
        [x0,f0] = linesearch1(x0, d(2:length(d)-1)', q, maxstep);
        if f0 < q
            wskaz = 0;
        elseif wskaz == 1
            disp('Koniec');
            break;
        end;
    else
        % odnowa
        wskaz = 1;
    end
end 

format short

%%
[~,~,x,t,u,psi]=recalculate(x0);
figure(1)
plot(t,x(1,:), t,x(2,:),t,u);
grid on

figure(2)
title('funkcja przelaczajaca')
sw=switching_fun(psi);
grid on
plot(t,sw);