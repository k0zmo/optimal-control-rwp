function [dQ,Q,x,t,psi,H1] = gradient(tau,u0)
global h x0

dtau = diff(tau);
n = ceil(dtau/h);
nc = cumsum([1 n]);

x = zeros(length(x0), nc(end));
x(:,1) = x0;
u = u0;
t = zeros(1, nc(end));

for j = 1:length(dtau)
    if n(j)
        h = dtau(j)/n(j);
        h2 = h/2;
        h3 = h/3;
        h6 = h/6;
        for i = nc(j):nc(j+1)-1
            dx1 = feval('model', x(:,i), u);
            dx2 = dx1 + feval('model', h2*dx1, 0);
            dx3 = dx1 + feval('model', h2*dx2, 0);
            dx4 = dx1 + feval('model', h*dx3, 0);
            x(:,i+1) = x(:,i) + h3*(dx2+dx3) + h6*(dx1+dx4);
            t(i+1) = t(i) + h;
        end
    end
    u=-u;
end

xT = x(:,end);
Q = costfun(xT);

psi = zeros(size(x));
psi(:,end) = psi_last(xT);
u=-u;

for j=length(dtau):-1:1
    if n(j)
        h = dtau(j) / n(j);
        h2 = h/2;
        h3 = h/3;
        h6 = h/6;
        for i = nc(j+1):-1:nc(j)+1
            dx1 = feval('comodel', psi(:,i), x(:,i));
            dx2 = dx1 + feval('comodel', h2*dx1, 0);
            dx3 = dx1 + feval('comodel', h2*dx2, 0);
            dx4 = dx1 + feval('comodel', h*dx3, 0);
            psi(:,i-1) = psi(:,i) - h3*(dx2+dx3) - h6*(dx1+dx4);
        end
    end
    u=-u;
end
H1 = switching_fun(psi);

if length(tau)<=2
    dQ = [];
else
    dQ = 2*u0 * H1(nc(2:end-1));
    dQ(1:2:end) = -dQ(1:2:end);
end

