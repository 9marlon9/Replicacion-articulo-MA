function lr = labor_alloc(kn, kc, A, p, lr0)
% Asignacion intratemporal del trabajo, ecuacion (7): MPL_r = MPL_nr, con
% lr + lnr = 1.
%
% El trabajo es homogeneo y se mueve entre ocupaciones sin costo, de modo que
% un mismo salario rige en ambas y el hogar reparte su unidad de trabajo hasta
% igualar productos marginales. La consecuencia para la medicion es que toda
% la brecha entre las participaciones de ingreso de rutina y no rutina refleja
% cantidades de trabajo, no salarios.
%
% Se resuelve por Newton sobre logit(lr), lo que confina lr al intervalo (0,1)
% sin imponer restricciones explicitas. Vectorizado sobre los periodos.
%
% Entradas: kn, kc  capital NTIC y TIC por trabajador
%           A       nivel de PTF
%           p       parametros
%           lr0     valor inicial, del mismo tamano que kn
% Salida  : lr      trabajo en ocupaciones de rutina

    if nargin < 5 || isempty(lr0)
        lr0 = 0.4*ones(size(kn));
    end
    lr0 = min(max(lr0, 1e-6), 1-1e-6);
    v = log(lr0./(1-lr0));
    h = 1e-7;

    for it = 1:60
        f = gap(v, kn, kc, A, p);
        if max(abs(f)) < 1e-13
            break
        end
        df = (gap(v+h, kn, kc, A, p) - gap(v-h, kn, kc, A, p))/(2*h);
        d  = -f./df;
        d(~isfinite(d)) = 0;
        v  = v + max(min(d, 2), -2);
    end
    lr = 1./(1 + exp(-v));
end

function f = gap(v, kn, kc, A, p)
    lr = 1./(1 + exp(-v));
    [~, m] = production(kn, kc, lr, A, p);
    f = log(m.mplr) - log(m.mplnr);
end
