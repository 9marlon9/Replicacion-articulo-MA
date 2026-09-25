function lam = welfare_gain(c_base, c_cf, t0_index, beta)
% Ganancia equivalente en consumo permanente, ecuacion (9).
%
% lambda es el aumento permanente de consumo que deja al hogar indiferente
% entre quedarse en el contrafactual y vivir la senda base desde t0:
%
%   sum_t beta^(t-t0) ln[(1+lambda) c_t^cf] = sum_t beta^(t-t0) ln(c_t^base)
%
% Con utilidad logaritmica lambda sale en forma cerrada:
%
%   lambda = exp( (1-beta) * sum_t beta^(t-t0) [ln c_t^base - ln c_t^cf] ) - 1
%
% lambda crece con t0 por dos fuerzas: las generaciones tempranas financian en
% consumo sacrificado la acumulacion de capital, y descuentan unas ganancias
% que solo se materializan decadas despues. Las tardias heredan el stock.
%
% La cola posterior al ultimo periodo simulado se valora con la diferencia
% terminal, que ya es la de estado estacionario.
%
% Entradas: c_base    consumo en la simulacion base
%           c_cf      consumo en el contrafactual
%           t0_index  indice del ano de evaluacion
%           beta      factor de descuento
% Salida  : lam       lambda en unidades de consumo (0.04 = 4%)

    d  = log(c_base(t0_index:end)) - log(c_cf(t0_index:end));
    n  = numel(d);
    w  = beta.^(0:n-1)';
    pv = sum(w.*d) + (beta^n/(1-beta))*d(end);
    lam = exp((1-beta)*pv) - 1;
end
