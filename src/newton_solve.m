function [v, info] = newton_solve(res, v0, tol, maxit)
% Newton amortiguado con jacobiano denso por diferencias centradas, para los
% sistemas pequenos: los tres estados estacionarios.
%
% Se implementa aqui y no con fsolve para que el codigo corra en Matlab sin
% Optimization Toolbox y en Octave sin paquetes adicionales.
%
% Entradas: res    residuos, R = res(v), con numel(R) = numel(v)
%           v0     valor inicial
%           tol    tolerancia sobre max(abs(R))
%           maxit  iteraciones maximas
% Salidas : v      solucion
%           info   resid, iter y flag de convergencia

    v = v0(:);
    n = numel(v);
    R = res(v);
    for it = 1:maxit
        nrm = max(abs(R));
        if nrm < tol
            info = struct('resid', nrm, 'iter', it-1, 'converged', true);
            return
        end
        J = zeros(n, n);
        h = 1e-7*max(1, abs(v));
        for j = 1:n
            vp = v; vm = v;
            vp(j) = vp(j) + h(j);
            vm(j) = vm(j) - h(j);
            J(:,j) = (res(vp) - res(vm))/(2*h(j));
        end
        warning('off', 'all');
        d = -(J\R);
        warning('on', 'all');
        if any(~isfinite(d))
            d = -R;
        end
        step = 1;
        for ls = 1:40
            vt = v + step*d;
            Rt = res(vt);
            if all(isfinite(Rt)) && max(abs(Rt)) < nrm
                break
            end
            step = step/2;
        end
        v = v + step*d;
        R = res(v);
    end
    info = struct('resid', max(abs(R)), 'iter', maxit, 'converged', max(abs(R)) < tol);
end
