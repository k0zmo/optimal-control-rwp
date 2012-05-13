function Q = cost(tau,u0)
global h x0

% Dlugosci czasu trwania danego sterowania
dtau = diff(tau);
% Dlugosc przedzialu dla danego sterowania
n = ceil(dtau/h);
% Nie potrzebujemy calego stanu x, wystarczy nam ostatnia wartosc
x = x0; 
u = u0;

for j = 1:length(dtau)
    if n(j) ~= 0
        h = dtau(j)/n(j);
        h2 = h/2;
        h3 = h/3;
        h6 = h/6;
        for i = 1:n(j)
            dx1 = feval('model', x(:,i), u);
            dx2 = dx1 + feval('model', h2*dx1, 0);
            dx3 = dx1 + feval('model', h2*dx2, 0);
            dx4 = dx1 + feval('model', h*dx3, 0);
            x = x + h3*(dx2+dx3) + h6*(dx1+dx4);
        end
    end
    
    u=-u;
end

% wartosc wskaznika jakosci
Q = costfun(x);