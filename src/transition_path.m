function out = transition_path(pc, dc, A, p, ss0, ss1)
% Transicion con prevision perfecta entre dos estados estacionarios.
%
% Metodo de tiempo apilado (Laffargue, Boucekkine y Juillard), el mismo que
% usa Dynare para prevision perfecta: las 2*(T-1) ecuaciones de Euler del
% horizonte se escriben como un unico sistema no lineal y se resuelven con
% Newton, en vez de iterar hacia adelante con disparos sucesivos.
%
%   p_it / c_t = beta/c_{t+1} * [ MPK_i,t+1 + p_i,t+1 (1-delta_i,t+1) ]
%
% Incognitas: {log kn_t, log kc_t} para t = 2..T. Condicion inicial: k_1 en el
% estado estacionario de 1950. Condicion terminal: k_{T+1} en el estado
% estacionario final, que es la contraparte numerica de la transversalidad.
% Semilla: interpolacion log-lineal entre ambos estados estacionarios.
%
% Entradas: pc, dc  precio y depreciacion del TIC, (T+1) x 1
%           A       nivel de PTF
%           p       parametros
%           ss0     estado estacionario inicial
%           ss1     estado estacionario final
% Salidas : out     K, la asignacion completa y el diagnostico del solver

    T = numel(pc) - 1;

    w0 = linspace(0, 1, T+1)';
    Kg = [exp((1-w0)*log(ss0.kn) + w0*log(ss1.kn)), ...
          exp((1-w0)*log(ss0.kc) + w0*log(ss1.kc))];
    Kg(1,:)   = [ss0.kn, ss0.kc];
    Kg(T+1,:) = [ss1.kn, ss1.kc];

    lrcache = linspace(ss0.lr, ss1.lr, T+1)';

    v0 = reshape(log(Kg(2:T,:))', [], 1);

    res = @(v) euler_residuals(v, pc, dc, A, p, ss0, ss1, T, lrcache);
    [v, info] = newton_banded(res, v0, p.tol, p.maxit, 13);

    K = assemble(v, ss0, ss1, T);
    a = path_allocation(K, pc, dc, A, p, lrcache);

    out.K = K;
    out.a = a;
    out.pc = pc;  out.dc = dc;
    out.resid = info.resid;
    out.iter  = info.iter;
    out.converged = info.converged;
    out.hist = info.hist;
    out.years = (p.year0:(p.year0 + T))';
end

function R = euler_residuals(v, pc, dc, A, p, ss0, ss1, T, lrcache)
    K = assemble(v, ss0, ss1, T);
    a = path_allocation(K, pc, dc, A, p, lrcache);
    c = a.c;

    mrs = p.beta*c(1:T-1)./c(2:T);
    rn  = mrs.*( a.mpkn(2:T) + (1-p.delta_n) ) - 1;
    rc  = mrs.*( a.mpkc(2:T) + pc(2:T).*(1-dc(2:T)) )./pc(1:T-1) - 1;
    R   = reshape([rn, rc]', [], 1);
end

function K = assemble(v, ss0, ss1, T)
    M = reshape(v, 2, T-1)';
    K = [ss0.kn, ss0.kc; exp(M); ss1.kn, ss1.kc];
end
