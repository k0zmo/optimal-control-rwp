function [st] = maxstep(stime, d)
global Tk

stimei = [0 stime' Tk];
dd = [0 d' 0];
dStimei = diff(stimei);
dD = -diff(dd);
woz = find(dD > 0);
kns = dStimei(woz) ./ dD(woz);
st = min([inf kns]);

