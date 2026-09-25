function p = set_parameters()
% Calibracion de Eden & Gaggl (2018), Tablas 2A y 3.
%
%   alpha    participacion del capital NTIC; constante por la Cobb-Douglas
%            externa, que es lo que replica su ausencia de tendencia
%   beta     descuento; beta*(1+r)=1 implica r = 2.70% anual
%   delta_n  depreciacion NTIC, media de las cuentas del BEA
%   g        crecimiento del trabajo agregado
%   sigma    1/(1-sigma) = 1.43 = EOS entre capital TIC y trabajo no rutinario
%   theta    1/(1-theta) = 8.04 = EOS entre el compuesto z y el trabajo rutinario
%   gamma    peso del capital TIC dentro de z
%   eta      peso del trabajo rutinario dentro de x
%
% gamma y eta se recuperan de las constantes de regresion de la Tabla 2A,
% -5.201 y 0.138, y no de los valores impresos 0.005 y 0.535: el redondeo de
% estos ultimos desplaza las participaciones unas tres decimas de punto.

    p.alpha   = 0.3505;
    p.beta    = 0.9737;
    p.delta_n = 0.0733;
    p.g       = 0.0192;

    p.sigma   = 0.299;
    p.theta   = 0.876;
    p.gamma   = exp(-5.201)/(1 + exp(-5.201));
    p.eta     = exp( 0.138)/(1 + exp( 0.138));

    p.year0   = 1950;
    p.year1   = 2013;

    p.tol     = 1e-10;
    p.maxit   = 120;
    p.T       = 160;
    p.logy0   = 10.20;
end
