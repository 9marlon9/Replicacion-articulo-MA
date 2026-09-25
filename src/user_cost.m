function R = user_cost(pi_, delta, p)
% Costo de uso de largo plazo del capital de tipo i.
%
%   R_i = p_i * (r + delta_i),    r = 1/beta - 1 = 2.70%
%
% El retorno requerido sale de la Euler de estado estacionario beta*(1+r) = 1
% (nota al pie 14). Que R_n y R_c usen el mismo r es la condicion de no
% arbitraje entre los dos activos: lo unico que los distingue es el precio al
% que se compran y la velocidad a la que se consumen.
%
% Entradas: pi_    precio relativo del capital (1 para NTIC, el numerario)
%           delta  tasa de depreciacion
%           p      parametros
% Salida  : R      pago por unidad de capital

    R = pi_ * (1/p.beta - 1 + delta);
end
