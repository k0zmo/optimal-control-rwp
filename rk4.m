function [Q, t, x, u] = rk4(tau, u0, x0, h0, xf)
dTau = diff(tau);
n = ceil(dTau/h0);
nc = cumsum([1 n]);
xlength = nc(end);

x = zeros(xlength, length(x0));
x(1,:) = x0;
t = zeros(xlength, 1);

u = zeros(xlength, 1);
u(1) = u0;
cu = u(1);

for j = 1:length(tau)-1
    if n(j)
        h = dTau(j)/n(j);
        for i = nc(j):nc(j+1) - 1
            % wspolczynniki RK
			z = x(i,:);
            k1 = h * feval('model', z         , cu);
            k2 = h * feval('model', z + 0.5*k1, cu); 
            k3 = h * feval('model', z + 0.5*k2, cu); 
            k4 = h * feval('model', z + k3    , cu); 
			
            x(i+1,:) = z + (k1+2*(k2+k3)+k4) / 6;
            t(i+1) = t(i) + h;
            u(i+1) = cu;
        end
    end
    cu = -cu;
end

Q = costfun(x(end,:), xf);