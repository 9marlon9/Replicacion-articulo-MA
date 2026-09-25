function a = path_allocation(K, pc, dc, A, p, lr0)
% Asignacion y consumo implicados por una trayectoria de capital.
%
% Resuelve en cada periodo el reparto del trabajo y recupera el consumo como
% residuo de la restriccion de recursos, ecuacion (8):
%
%   c_t = y_t + sum_i p_it (1-delta_it) k_it - (1+g) sum_i p_it k_i,t+1
%
% El consumo no entra como incognita en el sistema de Euler precisamente por
% esto: queda determinado una vez elegidas las sendas de capital, lo que
% reduce el problema a la mitad de variables.
%
% Vectorizado en el tiempo: una sola llamada resuelve los T+1 periodos.
%
% Entradas: K    matriz (T+1) x 2 con columnas [kn, kc]
%           pc   precio relativo del capital TIC, (T+1) x 1
%           dc   depreciacion del capital TIC, (T+1) x 1
%           A    nivel de PTF
%           p    parametros
%           lr0  valores iniciales para lr, (T+1) x 1
% Salida  : a    lr, y, c, productos marginales y participaciones por factor

    T  = size(K,1) - 1;
    kn = K(:,1);  kc = K(:,2);

    lr = labor_alloc(kn, kc, A, p, lr0);
    [y, m] = production(kn, kc, lr, A, p);

    resources = y(1:T) + (1-p.delta_n)*kn(1:T) + pc(1:T).*(1-dc(1:T)).*kc(1:T);
    invest    = (1+p.g)*( kn(2:T+1) + pc(1:T).*kc(2:T+1) );
    c = resources - invest;

    a.lr = lr;  a.lnr = 1 - lr;  a.y = y;  a.c = c;
    a.mpkn = m.mpkn;  a.mpkc = m.mpkc;  a.mplr = m.mplr;  a.mplnr = m.mplnr;
    a.s_n  = m.mpkn .*kn      ./y;
    a.s_c  = m.mpkc .*kc      ./y;
    a.s_r  = m.mplr .*lr      ./y;
    a.s_nr = m.mplnr.*(1 - lr)./y;
    a.s_L  = a.s_r + a.s_nr;
end
