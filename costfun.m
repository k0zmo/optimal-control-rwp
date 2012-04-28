function [Q] = costfun(xT)
global R xf
Q = 0.5*((xT-xf)')*R*(xT-xf);