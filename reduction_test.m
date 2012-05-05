clc, clear;

run modelparams;
u0 = umax;

[~,stime_r,u0_r] = reduction([1 1 2 2 3], u0);
if ~isequal(stime_r, 3) || (u0_r ~= u0)
    fprintf('!');
    %u0_r
    %stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([1 2 2 3], u0);
if ~isequal(stime_r, [1 3]) || (u0_r ~= u0)
    fprintf('!');
    %u0_r
    %stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([1 1 2 3 3], u0);
if ~isequal(stime_r, 2) || (u0_r ~= u0)
    fprintf('!');
    %u0_r
    %stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([1 3 3], u0);
if ~isequal(stime_r, 1) || (u0_r ~= u0)
    fprintf('!');
    %u0_r
    %stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([1 2 3 3], u0);
if ~isequal(stime_r, [1 2]) || (u0_r ~= u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([0.5 1 1.5 1.5 2 2.5 2.5 3], u0);
if ~isequal(stime_r, [0.5 1 2 3]) || (u0_r ~= u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([0.5 0.5 1 1.5 1.5 2 2.5 2.5 3], u0);
if ~isequal(stime_r, [1 2 3]) || (u0_r ~= u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([0 0.5 0.5 1 1.5 1.5 2 2.5 2.5 3 3], u0);
if ~isequal(stime_r, [1 2]) || (u0_r == u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([0 0.5 0.5 1 1.5 1.5 2 2.5 2.8 3 3], u0);
if ~isequal(stime_r, [1 2 2.5 2.8]) || (u0_r == u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;


[~,stime_r,u0_r] = reduction([0 0.5 0.7 0.7 1 1.5 1.5 2 2.5 2.8 3 3], u0);
if ~isequal(stime_r, [0.5 1 2 2.5 2.8]) || (u0_r == u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

[~,stime_r,u0_r] = reduction([0 0.5 0.7 0.7 1 1.5 1.5 2 2.5 2.8 3 3 4], u0);
if ~isequal(stime_r, [0.5 1 2 2.5 2.8]) || (u0_r == u0)
    fprintf('!');
   % u0_r
   % stime_r
else
    fprintf('.');
end;

fprintf('\n');