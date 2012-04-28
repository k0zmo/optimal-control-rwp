function [xnext] = model(x, u)
global m g l J Jr k
xnext = [x(2); 
         m*g*l/J*sin(x(1)) - k/J*u; 
         x(4);
         k/Jr*u];