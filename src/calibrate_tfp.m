function A = calibrate_tfp(pc0, dc0, p)
% Nivel de PTF que fija la escala de la economia.
%
% La funcion de produccion (3) no lleva termino de PTF explicito, pero la
% Tabla 4 reporta niveles en dolares por trabajador. A se elige de modo que el
% estado estacionario inicial cumpla ln(y) = 10.20, que es la normalizacion de
% la nota al pie 15. Las participaciones de ingreso y las tasas de cambio de
% la Tabla 4 son invariantes a esta eleccion.
%
% Biseccion en log(A), que es legitima porque ln(y) es monotona creciente en
% log(A) una vez resuelto el estado estacionario.
%
% Entradas: pc0, dc0  precio y depreciacion del TIC en el ano inicial
%           p         parametros
% Salida  : A         nivel de PTF

    f = @(lA) log(steady_state(pc0, dc0, exp(lA), p).y) - p.logy0;

    lo = -20;  hi = 20;
    flo = f(lo);
    for it = 1:200
        mid = 0.5*(lo + hi);
        fm  = f(mid);
        if abs(fm) < 1e-12 || (hi - lo) < 1e-14
            break
        end
        if sign(fm) == sign(flo)
            lo = mid;  flo = fm;
        else
            hi = mid;
        end
    end
    A = exp(0.5*(lo + hi));
end
