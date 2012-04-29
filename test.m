clc, clear;

modelparams;

%% sterowanie bazowe
u0 = umin;
stime = Tk/2; % czasy przelaczen
si = length(stime);

hh = 0:0.005:0.1;
figure(1)
hold on, grid on

for ii = 1:length(hh)
    delta_u = hh(ii);
    
    u0 = umin;
    stime = Tk/2 + delta_u; % czasy przelaczen
    %si = length(stime); 
    
    %% generuj sterowanie dla podanych czasow przelaczen, sterowania poczatkowego oraz osi czasu
    [u, t, stimei] = control(stime, [u0 umax umin], t);
    %stimei, t(stimei)
    plot(t,u);
    axis([0 Tk umin-1 umax+1]);
end