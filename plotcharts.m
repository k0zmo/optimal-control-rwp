function [] = plotcharts(t, x, H1, tau, u0, imin)
global Tk
tau = [0 tau Tk];

figure(1),
subplot(3,1,1), plot(t, x(:,1), t, x(:,2))
subplot(3,1,2), plot(t, x(:,3), t, x(:,4))
subplot(3,1,3), plot(t, H1/max(abs(H1))),
grid on, axis([0 tau(end) -1.2 1.2]), hold on

% Linia 0
plot([0 tau(end)], [0 0], 'g','LineWidth', 2);

% Linie przelaczajace
for j = 2:length(tau)-1
    plot([tau(j) tau(j)], [-1 1], 'r:')
end

% Linie funkcji u
for j = 1:2:length(tau)-1
    plot([tau(j) tau(j+1)], [u0 u0]/abs(u0), 'r', 'LineWidth', 2)
    if j < length(tau)-1
        plot([tau(j+1) tau(j+2)], -[u0 u0]/abs(u0), 'r', 'LineWidth', 2)
    end
end

if nargin == 6
    plot([t(imin) t(imin)], [-1 1], 'k', 'LineWidth', 3)
end
hold off