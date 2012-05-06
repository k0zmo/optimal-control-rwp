%%
[Q,~,x,t,u,psi]=recalculate(stime,u0);
disp(Q)

figure(1)
title('przebieg stanow x1 i x2')
plot(t,x(1,:), t,x(2,:));
grid on


figure(99)
title('funkcja przelaczajaca i sterowanie')
sw=switching_fun(psi);
swmax = max(abs(max(sw)),abs(min(sw)));
uumax = max(abs(umax),abs(umin));
plot(t,sw/swmax, t, u/uumax, 'r', [0 t(end)], [0 0], '--k');
grid on
axis([0 Tk -1.5 1.5])