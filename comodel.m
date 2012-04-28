function [psinext] = comodel(psi, x)
global m g l J
psinext = [-psi(2) * m*g*l/J*cos(x(1)); 
    -psi(1); 
    0;
    -psi(3)];