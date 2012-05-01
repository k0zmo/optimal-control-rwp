function [x0, wskaz] = linesearch(x0, d, maxstep)

[zw, qw, wskaz, z, q] = expansion(x0, d, 1, 10, 1e-8);
if wskaz>1
   [zw, qw, z, q] = goldensection(x0, d, zw, qw, 5, z, q);
   [zw, ~, ~, ~] = aprop(x0, d, zw, qw, 1, z, q);
end
if wskaz > 0   
   x0 = x0 + zw(2)*d;
end