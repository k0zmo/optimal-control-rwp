function [zw, qw, wskaz, z, q] = expansion(x0, d, zn, maxit, epsil)

% Metoda ekspansji - kontrakcji na dodatniej pó³prostej,
%         wychodz¹cej w kierunku d z punktu x0.
% Dane: z(1)=0 - punkt startowy
%       zn - krok pocz¹tkowy
%       alfa - wspó³czynnik ekspansji
%       beta - wspó³czynnik kontrakcji
%       maxit - maksymalna liczba kroków ekspansji
%       epsil - minimalna d³ugoœæ kroku kontrakcji.
% Wyjœcie: wskaz=0 - kontrakcja bez powodzenia
%               =2 - kontrakcja z powodzeniem
%               =1 - ekspansja bez obramowania
%               =3 = ekspansja z obramowaniem
%          zw - macierz wynikowych wartoœci argumentu:
%          zw(1) - lewy koniec przedzia³u nieokreœlonoœci
%          zw(2) - przybli¿enie rozwi¹zania optymalnego
%          zw(3) - prawy koniec przedzia³u nieokreœlonoœci
%          qw - macierz wynikowych wartoœci kosztu:
%               qw(i)=koszt(zw(i))
%          z - zawiera wszystkie wartoœci argumentu,
%              dla których wyliczono koszt (w kolejnoœci 
%              liczenia)
%          q - odpowiednia macierz wartoœci kosztu.

alfa = 3;
beta = 0.5;
z = [0 zn];
qs = costfunction(x0, 0, d);
qn = costfunction(x0, zn, d);
q = [qs qn];
if qn >= qs         % kontrakcja
   wskaz = 0;
   while zn > epsil          
      zn = beta * zn;
      qn = costfunction(x0, zn, d); 
      z = [z zn];
      q = [q qn];
      if qn < qs, wskaz = 2; break, end
   end  
else              % ekspansja
   wskaz = 1;
   for i = 1:maxit
      qs = qn;
      zn = alfa * zn;     
      qn = costfunction(x0, zn, d); 
      z = [z zn];
      q = [q qn];
      if qn >= qs, wskaz = 3; break, end
   end
end

k = length(z);
if wskaz == 0
   zw = [0 0 z(k)];
   qw = [q(1) q(1) q(k)];
elseif wskaz == 1
   zw = [z(k-1) z(k) inf];
   qw = [q(k-1) q(k) nan];
elseif wskaz == 2
   zw = [0 z(k) z(k-1)];
   qw = [q(1) q(k) q(k-1)];
elseif wskaz == 3
   zw = [z(k-2) z(k-1) z(k)];
   qw = [q(k-2) q(k-1) q(k)];
end