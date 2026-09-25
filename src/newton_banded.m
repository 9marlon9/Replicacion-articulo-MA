function [v, info] = newton_banded(res, v0, tol, maxit, spacing)
% Newton amortiguado para el sistema apilado de la transicion.
%
% El residuo de Euler del periodo t involucra capital solo en t, t+1 y t+2, de
% modo que el jacobiano es de banda angosta. Se explota con el coloreo de
% Curtis, Powell y Reid (1974): dos variables separadas 'spacing' posiciones
% tienen soportes de filas disjuntos, se perturban a la vez y despues se
% recorta cada columna a su banda. El jacobiano completo cuesta 2*spacing
% evaluaciones del residuo en lugar de 2*n; con n = 318 y spacing = 13 son 26
% evaluaciones en vez de 636.
%
% Entradas: res      residuos, ordenados por periodo en bloques de 2
%           v0       valor inicial, con el mismo orden
%           tol      tolerancia sobre max(abs(R))
%           maxit    iteraciones maximas
%           spacing  separacion del coloreo
% Salidas : v        solucion
%           info     resid, iter, converged e historial de residuos

    v = v0(:);
    n = numel(v);
    R = res(v);
    hist = zeros(maxit,1);

    % El capital del periodo q = blk+1 entra en los residuos de Euler de los
    % bloques q-2, q-1 y q, es decir en las filas 2*blk-3 a 2*blk+2.
    blk  = ceil((1:n)'/2);
    rlo  = max(1, 2*blk - 3);
    rhi  = min(n, 2*blk + 2);

    for it = 1:maxit
        nrm = max(abs(R));
        hist(it) = nrm;
        if nrm < tol
            info = struct('resid', nrm, 'iter', it-1, 'converged', true, ...
                          'hist', hist(1:it));
            return
        end

        h = 1e-6*max(1, abs(v));
        J = zeros(n, n);
        for col = 1:spacing
            idx = (col:spacing:n)';
            vp = v;  vm = v;
            vp(idx) = vp(idx) + h(idx);
            vm(idx) = vm(idx) - h(idx);
            D = (res(vp) - res(vm))./(2*h(idx))';
            for k = 1:numel(idx)
                j = idx(k);
                J(rlo(j):rhi(j), j) = D(rlo(j):rhi(j), k);
            end
        end

        warning('off', 'all');
        d = -(J\R);
        warning('on', 'all');
        if any(~isfinite(d))
            info = struct('resid', nrm, 'iter', it, 'converged', false, ...
                          'hist', hist(1:it));
            return
        end

        % Busqueda de linea sobre la norma 2, que es menos propensa a
        % estancarse que la norma del maximo usada en el test de parada.
        n2 = norm(R);
        step = 1;
        for ls = 1:50
            Rt = res(v + step*d);
            if all(isfinite(Rt)) && norm(Rt) < n2
                break
            end
            step = step/2;
        end
        v = v + step*d;
        R = res(v);
    end

    info = struct('resid', max(abs(R)), 'iter', maxit, ...
                  'converged', max(abs(R)) < tol, 'hist', hist);
end
