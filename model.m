function [xnext] = model(x, u)
global m g l J Jr k

xx1 = x(2);
xx2 = m*g*l/J*sin(x(1)) - k/J*u;
xx3 = x(4);
xx4 = k/Jr*u;

xnext = [xx1; xx2; xx3; xx4];

% xnext = [x(2); 
%     m*g*l/J*sin(x(1)) - k/J*u; 
%     x(4);
%     k/Jr*u];