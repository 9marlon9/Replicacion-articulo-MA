function [y, m, agg] = production(kn, kc, lr, A, p)
% Tecnologia anidada CES y productos marginales, ecuaciones (3)-(5).
%
%   y = A * kn^alpha * x^(1-alpha)
%   x = [ eta*lr^theta + (1-eta)*z^theta ]^(1/theta)
%   z = [ gamma*kc^sigma + (1-gamma)*lnr^sigma ]^(1/sigma)
%
% El capital TIC y el trabajo no rutinario forman el compuesto z, y ese
% compuesto sustituye al trabajo rutinario con elasticidad 8.04. De ahi sale
% el mecanismo del paper: capital TIC mas barato eleva el producto marginal
% del trabajo no rutinario, su complemento en z, y deprime el del rutinario.
% La Cobb-Douglas externa fija s_n = alpha en todo momento.
%
% Opera elemento a elemento: admite escalares o vectores conformables, de modo
% que una trayectoria completa se evalua en una sola llamada.
%
% Entradas: kn, kc  capital NTIC y TIC por trabajador
%           lr      trabajo en ocupaciones de rutina (lnr = 1-lr)
%           A       nivel de PTF
%           p       parametros
% Salidas : y       producto por trabajador
%           m       productos marginales: mpkn, mpkc, mplr, mplnr
%           agg     compuestos x y z

    lnr = 1 - lr;

    z = (p.gamma*kc.^p.sigma + (1-p.gamma)*lnr.^p.sigma).^(1/p.sigma);
    x = (p.eta*lr.^p.theta  + (1-p.eta)*z.^p.theta  ).^(1/p.theta);
    y = A * kn.^p.alpha .* x.^(1-p.alpha);

    dy_dx   = (1-p.alpha)*y./x;
    dx_dlr  = x.^(1-p.theta).*p.eta.*lr.^(p.theta-1);
    dx_dz   = x.^(1-p.theta).*(1-p.eta).*z.^(p.theta-1);
    dz_dkc  = z.^(1-p.sigma).*p.gamma.*kc.^(p.sigma-1);
    dz_dlnr = z.^(1-p.sigma).*(1-p.gamma).*lnr.^(p.sigma-1);

    m.mpkn  = p.alpha*y./kn;
    m.mpkc  = dy_dx.*dx_dz.*dz_dkc;
    m.mplr  = dy_dx.*dx_dlr;
    m.mplnr = dy_dx.*dx_dz.*dz_dlnr;

    agg.x = x;
    agg.z = z;
end
