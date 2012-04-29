function[dQ] = costfuncderivatives(stimei, u, psi)

si = length(stimei);
dQ = zeros(1, si);

for j = 1:si
    i = stimei(j);
    fswitch = switching_fun(psi(:,i));
    dQ(j) = fswitch * (u(i)-u(i-1));
end