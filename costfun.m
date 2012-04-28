function [Q] = costfun(xT, Tk)
global R xf
Q = 0.5*((xT-xf)')*R*(xT-xf);