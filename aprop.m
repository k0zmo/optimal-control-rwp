function [zw, qw, z, q] = aprop(x0, d, zw, qw, maxit, z, q)

% Wielokrotna aproksymacja (interpolacja) paraboliczna II stopnia.
% Dane: zw(1) - lewy koniec przedziału nieokreśloności
%       zw(2) - punkt wewnętrzny
%       zw(3) - prawy koniec przedziału nieokreśloności
%       qw(i) - wartość wskaźnika jakości w punkcie zw(i)
%       maxit - liczba kroków.
% W każdym kroku aktualnym przybliżeniem rozwiązania optymalnego 
% jest para (zw(2),qw(2)), a aktualnym przedziałem nieokreśloności - 
% (zw(1),zw(3)).

if nargin == 6, maxit = 1; end

for i = 1:maxit
   a= (qw(3)-qw(2)) * (zw(1)-zw(2));
   b= (qw(2)-qw(1)) * (zw(3)-zw(2));
   if abs(a+b) < 1e-10, break, end   
   zz = 0.5*(zw(2) + (a*zw(1)+b*zw(3)) / (a+b));
   qq = costfunction(x0, zz, d);
   if abs(zz-zw(2)) < 1e-10, break, end   
   if qq < qw(2)
      if zz > zw(2)
         zw(1:2) = [zw(2) zz];
         qw(1:2) = [qw(2) qq];
      else
         zw(2:3) = [zz zw(2)];
         qw(2:3) = [qq qw(2)];
      end
   else
      if zz > zw(2)
         zw(3) = zz;
         qw(3) = qq;
      else
         zw(1) = zz;
         qw(1) = qq;
      end      
   end
z = [z zz];
q = [q qq];
end