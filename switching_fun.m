function[sw] = switching_fun(psi)
global k J Jr
sw = -k/J*psi(2,:) + k/Jr*psi(4,:);