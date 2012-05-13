function[tau,u0,x,t,psi,H1] = bfgs(tau,u0)
% rc=1 - wyliczyæ gradient, d=-dQ
%    2 -    "        "    , d ze wzoru rek.
%    0 - nie wyliczaæ grad.,d=-dQ

maxit = 500;
rc = 1;

for ii = 1:maxit+1
    if rc
        [dQ, Q, x, t, psi, H1] = gradient(tau, u0);
        norm_dQ = norm(dQ);
        disp([Q norm_dQ])
        if norm_dQ < 1e-6, disp('normal stop'), break,end
        if ii > maxit, disp('maximum iteration number exceeded'), break,end
    end
    
    if rc<2
        V = eye(length(tau)-2);
        d = -dQ;
    else
        R = dQ - dQ_o; 
        S = (tau(2:end-1) - tau_o(2:end-1))';
        VS = V*S;
        V = V + R*R'/(R'*S) - VS*VS'/(S'*VS);
        d = -V\dQ;
    end
    
    der = dQ'*d;
    if der < 0
        tau_o = tau; 
        dQ_o = dQ;
        tau = linesearch(tau, u0, Q, d, t);
        if max(abs(tau - tau_o))
            rc = 2;
            [tau, u0, rc] = reduction(tau, u0, rc);
        else
            if rc < 2
                disp('no improvement'),break
            end
            rc = 0;
        end
    else           %w tym wypadku rc==2
        rc = 0;
    end
end