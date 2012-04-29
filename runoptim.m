clc, clear;
modelparams;
options = optimset('GradObj','on');
x0 = [0.5 1];
lb = [0 0 ]';
ub = ones(2,1)*Tk;
[x,fval] = fmincon(@recalculate,x0,[],[],[],[],lb,ub,[],options);

