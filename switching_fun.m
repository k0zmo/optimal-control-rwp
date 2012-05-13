function H1 = switching_fun(psi)
global k J Jr
H1 = -k/J*psi(2,:) + k/Jr*psi(4,:);