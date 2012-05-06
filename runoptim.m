clc, clear;
run modelparams;

maxit = 100;
e0 = 1e-4; 
%x0 = [1.78 1.79 2.002285256623649]; x0=x0';
x0 = [0.91 2.91]; x0=x0';

u0 = umin;
stime = x0;

czod = 2*length(x0); % czestosc odnowy
rr = 1;
skip2 = 0;
reducted = 0;
fprintf('--Poczatek--');

for i=1:maxit
    
    if skip2 ~= 1
        % gradient w x0
        [Q, grad] = recalculate(stime, u0);

        fprintf('\nQ=%.16f ', Q);
        prettyprint('stime', stime);

        % norma gradientu
        n2 = grad'*grad;
        % sprawdz warunek stopu
        if n2 < e0, disp('|grad|<=eps'); break, end
    else
        skip2 = 0;
    end
    
    if rr == 1 || reducted == 1 % || rem(1, czod) == 1
        v = eye(length(stime));
        reducted = 0;
    else
        r = grad - grad_s;
        s = stime - stime_s;
        
        sr = s' * r;
        vr = v * r;
        vrs = vr * s';
        % z formuly Shermana-Morrisona v=inv(W), Wd=-gradient(x0)
        v = v + (1 + r'*vr)/sr * (s*s')/sr - (vrs+vrs')/sr;
    end
    
    % kierunek poszukiwania
    d = -v * grad;
    
    if d'*grad >= 0
        rr = 1;
    else
        stime_s = stime;
        grad_s = grad;
        
        % szacuj maksymalny krok dla poszukiwania na kierunku
        st = maxstep(stime, d);
        
        % szukaj minimum na wyznaczonym kierunku
        [stime, Q_opt] = linesearch1(stime, u0, d, Q, st);
        fprintf('new_Q=%.16f ', Q_opt);
        
        [reducted, stime, u0] = reduction(stime, u0);
        if reducted == 1
            %grad_s = grad;
            %stime_s = stime;            
        else
            % jesli nastapila poprawa
            if Q_opt < Q && abs(Q_opt - Q) > 10e-6
                rr = 0;
            elseif rr == 1
                fprintf('\n--Koniec--\n');
                break;
            elseif rr == 0
                skip2 = 1;
                rr = 1;
            end
        end
    end
end 

%%
[~,~,x,t,u,psi]=recalculate(stime,u0);

figure(1)
title('przebieg stanow x1 i x2')
plot(t,x(1,:), t,x(2,:));
grid on

figure(2)
title('przebieg stanow x3 i x4')
plot(t,x(3,:), t,x(4,:));
grid on

figure(3)
title('funkcja przelaczajaca i sterowanie')
sw=switching_fun(psi);
swmax = max(abs(max(sw)),abs(min(sw)));
uumax = max(abs(umax),abs(umin));
plot(t,sw/swmax, t, u/uumax, 'r', [0 t(end)], [0 0], '--k');
grid on
axis([0 Tk -1.5 1.5])