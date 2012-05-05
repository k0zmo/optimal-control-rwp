function[dQ] = costfuncderivatives(stimei, u, psi)

si = length(stimei);
dQ = zeros(1, si);
sii = 1;

if stimei(1) == 1
    sii = sii + 1;
    dQ(1) = 0;
end

for j = sii:si
    i = stimei(j);
    fswitch = switching_fun(psi(:,i));
    dQ(j) = fswitch * (u(i)-u(i-1));
end