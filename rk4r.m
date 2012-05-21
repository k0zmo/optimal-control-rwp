function [psi] = rk4r(tau, x, h0, xf)
dTau = diff(tau);
n = ceil(dTau/h0);
nc = cumsum([1 n]);

psi = zeros(size(x));
global W
psi(end,:) = W * (xf - x(end,:))';

for j = length(tau)-1:-1:1
    if n(j)
        h = dTau(j)/n(j);
        for i = nc(j+1):-1:nc(j)+1
            % stan w tym kroku, poprzednim i w polowie
            x1  = x(i,:);
            x2  = x(i-1,:);
            x12 = (x1+x2)/2;

            % wspolczynniki RK
            z  = psi(i,:);
            k1 = h * feval('comodel', z         , x1 );
            k2 = h * feval('comodel', z - 0.5*k1, x12); 
            k3 = h * feval('comodel', z - 0.5*k2, x12); 
            k4 = h * feval('comodel', z - k3    , x2 ); 
            psi(i-1,:) = z - (k1+2*(k2+k3)+k4) / 6;
        end
    end
end