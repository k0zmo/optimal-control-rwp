function[] = prettyprint(name, x)
fprintf(strcat(name,'=['));
for i=1:length(x), fprintf('%.5f ', x(i)); end;    
fprintf('] ');
end

