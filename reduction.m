function [tau, u0, rc] = reduction(tau,u0,rc)
j = find(diff(tau) <= 1e-10);
if ~isempty(j)
    m = length(tau);
    u = u0*ones(m-1,1);
    u(2:2:end) = -u0;
    u(j) = [];
    tau(j) = [];
    r = find(diff(u) == 0);
    u(r) = [];
    tau(r+1) = [];
    u0 = u(1);
    rc = 1;
end

tau = tau(2:end-1);