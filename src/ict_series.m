function [pc, dc, years, src] = ict_series(T, p)
% Las dos series exogenas del modelo: precio relativo y depreciacion del
% capital TIC. Toda la variacion del ejercicio viene de aqui; el resto del
% modelo tiene parametros fijos.
%
% El precio relativo se interpreta como la tasa a la que el producto se
% transforma en capital TIC, y junto con la depreciacion determina el precio
% efectivo del capital TIC para un inversionista.
%
% Si existe data/ict_series.csv, con columnas year, pc, dc, se usan esas
% series, construidas desde las cuentas detalladas de activos fijos del BEA.
% Si no, se construye una aproximacion logistica anclada en los rangos de la
% Tabla 3, pc en [0.254, 1.727] y delta_c en [0.137, 0.206], y en el
% calendario de la Seccion 5: precio plano a comienzos de los cincuenta, caida
% rapida desde comienzos de los sesenta, aplanamiento a mediados de los dos
% mil; depreciacion plana al inicio y al final, con alza entre 1980 y 2000.
% La Tabla 4 solo usa los extremos y es invariante a esta eleccion; lambda no,
% porque depende de la trayectoria completa via el descuento.
%
% Despues de 2013 ambas series quedan constantes, de modo que la economia
% converge al estado estacionario final.
%
% Entradas: T      periodos de simulacion
%           p      parametros
% Salidas : pc, dc series exogenas, (T+1) x 1
%           years  anos, (T+1) x 1
%           src    'BEA' o 'aproximacion'

    years = (p.year0:(p.year0 + T))';
    f = fullfile('data', 'ict_series.csv');

    if exist(f, 'file')
        M = csvread_safe(f);
        yd = M(:,1);  pd = M(:,2);  dd = M(:,3);
        pc = interp_flat(yd, pd, years);
        dc = interp_flat(yd, dd, years);
        src = 'BEA';
    else
        pc = logistic_path(years, 1.727, 0.254, 1985, 11.0, p.year1);
        dc = logistic_path(years, 0.137, 0.206, 1990,  5.5, p.year1);
        src = 'aproximacion';
    end
end

function s = logistic_path(years, v0, v1, mid, scale, ylast)
    t = min(years, ylast);
    w = 1./(1 + exp(-(t - mid)/scale));
    w0 = 1/(1 + exp(-(years(1) - mid)/scale));
    w1 = 1/(1 + exp(-(ylast     - mid)/scale));
    w  = (w - w0)/(w1 - w0);
    s  = exp( (1-w)*log(v0) + w*log(v1) );
end

function v = interp_flat(yd, vd, years)
    v = zeros(numel(years),1);
    for k = 1:numel(years)
        yy = min(max(years(k), min(yd)), max(yd));
        v(k) = interp1(yd, vd, yy, 'linear');
    end
end

function M = csvread_safe(f)
    fid = fopen(f, 'r');
    rows = [];
    while true
        ln = fgetl(fid);
        if ~ischar(ln), break, end
        ln = strtrim(ln);
        if isempty(ln), continue, end
        nums = sscanf(strrep(ln, ',', ' '), '%f');
        if numel(nums) >= 3
            rows = [rows; nums(1:3)'];
        end
    end
    fclose(fid);
    M = rows;
end
