function [psi] = rk4r(tau, x, h0, xf)

psi = zeros(size(x));
global W
psi(end,:) = W * (xf - x(end,:))';
[ur, un] = uranges(tau, h0);
dTau = diff(tau);

for j = length(tau)-1:-1:1
    if un(j) > 0
        h = dTau(j)/un(j);
        for i = ur(j+1):-1:ur(j)+1
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