clc, clear all, close all, format long e, format compact

run modelparams;
tau = [];
u0 = umax;
while 1
    [tau,u0,x,t,u,psi] = bfgs(tau,u0,t);
    H1 = switching_fun(psi);

    figure(1), plot(t,x(1,:), t,x(2,:));
    title('przebieg stanow x1 i x2'), grid on

    figure(2), plot(t, H1/max(abs(H1)));
    title('funkcja przelaczajaca i sterowanie'), grid on
    axis([0 Tk -1.2 1.2])
    hold on

    % Dla prostszego plotowania
    tau_ = [0 tau Tk];
    u0_ = u0 / abs(umax);

    % Linie przelaczen
    for j=1:length(tau)
        plot([tau(j) tau(j)],[-1 1],'r:')
    end
    % Wartosc sterowania na okreslonych przedzialach
    for j=1:2:length(tau_)-1
        plot([tau_(j) tau_(j+1)],[u0_ u0_],'r','LineWidth',2)
        if j<length(tau_)-1
            plot([tau_(j+1) tau_(j+2)],-[u0_ u0_],'r','LineWidth',2)
        end
    end

    % Liczenie wariacji szpilkowej
    [Emin imin] = min(u.*H1);

    if Emin>-1e-6
        disp('Cost derivative below 1e-6')
        break
    else
        if imin==1
            % tau = [0 tau];
            u0 = -u0;
        elseif imin == length(t)
            tau = [tau tau(end)];
        else
            t = sort([t t(imin)+h*0.5]);
            tau = sort([t(imin) t(imin+1) tau]);
        end
    end
    plot([t(imin) t(imin)],[-1 1],'k','LineWidth',3)
    hold off
    pause(1)
    %keyboard
end
