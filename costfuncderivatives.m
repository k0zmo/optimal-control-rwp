function[dQ] = costfuncderivatives(taui, u, psi)

si = length(taui);
if si == 0
    dQ = [];
    return
end

dQ = zeros(1, si);
sii = 1;

if taui(1) == 1
    sii = sii + 1;
    dQ(1) = 0;
end

for j = sii:si
    i = taui(j);
    fswitch = switching_fun(psi(:,i));
    dQ(j) = fswitch * (u(i)-u(i-1));
end