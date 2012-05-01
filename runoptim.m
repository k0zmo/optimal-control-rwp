clc, clear;

% options = optimset('GradObj','on');
% x0 = [0.5 1];
% lb = [0 0 ]';
% ub = ones(2,1)*Tk;
% [x,fval] = fmincon(@recalculate,x0,[],[],[],[],lb,ub,[],options);

x0 = [0.5 1]; % czasy przelaczen poczatkowe

[Q,dQ,x,t,u]=recalculate(x0);
plot(t,x(1,:), t,x(2,:),t,u);
grid on