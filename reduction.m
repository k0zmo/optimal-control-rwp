function [tau, u0, R]=reduction(tau, u0, R)
j = find(diff(tau) <= 1e-10);

if ~isempty(j)
    u = u0*ones(length(tau)-1,1);
    u(2:2:end) = -u0;
    u(j) = [];
    tau(j) = [];
    r = find(diff(u) == 0);
    u(r) = [];
    tau(r+1) = [];
    u0 = u(1);
    R = 1;
end