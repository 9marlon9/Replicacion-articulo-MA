function s = steady_state(pc, dc, A, p, guess)
% Estado estacionario del modelo de la Seccion 5. Tres ecuaciones en
% (kn, kc, lr):
%
%   MPK_n = 1  * (1/beta - 1 + delta_n)     Euler del capital NTIC
%   MPK_c = pc * (1/beta - 1 + dc)          Euler del capital TIC
%   MPL_r = MPL_nr                          asignacion del trabajo
%
% Un precio del capital TIC mas bajo abarata su costo de uso y el hogar
% acumula kc. Eso arrastra kn por complementariedad Cobb-Douglas y desplaza
% trabajo de rutina hacia no rutina, que es la recomposicion ocupacional que
% el modelo llama automatizacion.
%
% El consumo sale de la restriccion de recursos evaluada en estado
% estacionario, c = y - (g+delta_n)*kn - pc*(g+dc)*kc, donde el sustraendo es
% la inversion que mantiene constantes los stocks por trabajador.
%
% Se resuelve en (log kn, log kc, logit lr) para imponer los dominios.
%
% Entradas: pc     precio relativo del capital TIC (NTIC es el numerario)
%           dc     depreciacion del capital TIC
%           A      nivel de PTF
%           p      parametros
%           guess  (opcional) punto inicial transformado
% Salidas : s      cantidades, consumo, producto, participaciones de ingreso
%                  s_n, s_c, s_r, s_nr y el residuo del solver

    if nargin < 5 || isempty(guess)
        guess = [11.4; 7.2; -0.4];
    end

    Rn = user_cost(1 , p.delta_n, p);
    Rc = user_cost(pc, dc      , p);

    res = @(v) ss_residuals(v, Rn, Rc, A, p);
    [v, info] = newton_solve(res, guess, p.tol, p.maxit);

    [kn, kc, lr] = unpack(v);
    [y, m] = production(kn, kc, lr, A, p);

    s.kn = kn;  s.kc = kc;  s.lr = lr;  s.lnr = 1 - lr;
    s.y  = y;
    s.c  = y - (p.g + p.delta_n)*kn - pc*(p.g + dc)*kc;
    s.s_n  = m.mpkn *kn /y;
    s.s_c  = m.mpkc *kc /y;
    s.s_r  = m.mplr *lr /y;
    s.s_nr = m.mplnr*(1-lr)/y;
    s.s_L  = s.s_r + s.s_nr;
    s.pc = pc;  s.dc = dc;
    s.resid = info.resid;
    s.converged = info.converged;
    s.guess = v;
end

function R = ss_residuals(v, Rn, Rc, A, p)
    [kn, kc, lr] = unpack(v);
    [~, m] = production(kn, kc, lr, A, p);
    R = [m.mpkn/Rn  - 1;
         m.mpkc/Rc  - 1;
         m.mplr/m.mplnr - 1];
end

function [kn, kc, lr] = unpack(v)
    kn = exp(v(1));
    kc = exp(v(2));
    lr = 1/(1 + exp(-v(3)));
end
