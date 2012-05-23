function [Q, t, x, u] = rk4(tau, u0, x0, h0, xf)
global Tk
[ur, un] = uranges(tau, h0);
dTau = diff([0 tau Tk]);
xlength = ur(end);

x = zeros(xlength, length(x0));
x(1,:) = x0;
t = zeros(xlength, 1);

u = zeros(xlength, 1);
u(1) = u0;
cu = u(1);

for j = 1:length(tau)+1
    if un(j) > 0
        h = dTau(j)/un(j);
        for i = ur(j):ur(j+1) - 1
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