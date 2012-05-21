function [Q] = costfun(xT,xf)
global W
Q = 0.5*((xT-xf))*W*(xT-xf)';