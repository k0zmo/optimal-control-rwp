function[reducted,stime, u0] = reduction(stime, u0)
% Zalozenie jest takie, ze nie "nachodzi na siebie" wiecej
% niz 2 czasy przelaczen
global umax umin h

lstime = length(stime);
stime_p = [0 stime];
dstime_p = diff(stime_p);

dd = find(dstime_p <= h);
% czy zaszla zmiana
reducted = ~isempty(dd);

if reducted
    if dd(1) == 1
        % zmiana poczatkowego sterowania
        if u0 == umax, u0 = umin;
        else u0 = umax; end
        stime = stime(2:end);
        dd = dd(2:end);
        dd = dd - 2;
    else
        dd = dd - 1;
    end
   
    while ~isempty(dd)
        d = dd(1);
        if d == lstime-1
            stime = stime(1:end-2);
        else
            stime = [stime(1:d-1) stime(d+2:end)];
        end
        
        dd = dd(2:end);
        dd = dd - 2;
    end
end