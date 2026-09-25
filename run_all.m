% run_all.m
%
% Replicacion del resultado principal de Eden, M. y P. Gaggl (2018), "On the
% welfare implications of automation", Review of Economic Dynamics 29, 15-43:
% Tabla 4, Figura 7 y Figura 8.
%
% El ejercicio consiste en alimentar un modelo de crecimiento neoclasico con
% las dos series exogenas que el paper considera —el precio relativo del
% capital TIC y su tasa de depreciacion— y comparar la economia resultante con
% un contrafactual en que el precio del capital TIC no cae. La diferencia
% entre ambas es lo que el paper atribuye a la automatizacion.
%
% Ejecutar desde la raiz del proyecto, en Matlab o en Octave:  run_all
% Escribe en out/: table4.txt, table4.csv, fig7.png, fig8.png, welfare.csv,
% diagnostics.txt

clear; close all; clc
addpath('src');
if exist('OCTAVE_VERSION', 'builtin')
    graphics_toolkit('gnuplot');
    set(0, 'defaultfigurevisible', 'off');
end
if ~exist('out', 'dir'), mkdir('out'); end

p = set_parameters();
T = p.T;
iT = p.year1 - p.year0 + 1;

[pc, dc, years, src] = ict_series(T, p);
A = calibrate_tfp(pc(1), dc(1), p);

fprintf('Eden y Gaggl (2018), RED 29: Tabla 4, Figuras 7 y 8\n\n');
fprintf('Series exogenas del capital TIC: %s\n', src);
fprintf('  p_c      %7.4f (%d)  ->  %7.4f (%d)\n', pc(1), p.year0, pc(iT), p.year1);
fprintf('  delta_c  %7.4f (%d)  ->  %7.4f (%d)\n', dc(1), p.year0, dc(iT), p.year1);
fprintf('  A        %7.3f\n\n', A);

% Tres estados estacionarios. El contrafactual congela el precio del capital
% TIC en su nivel de 1950 y deja correr la depreciacion, que es la definicion
% que usa la Tabla 4 del paper.
ss_ini  = steady_state(pc(1), dc(1), A, p);
ss_base = steady_state(pc(iT), dc(iT), A, p, ss_ini.guess);
ss_cfp  = steady_state(pc(1),  dc(iT), A, p, ss_ini.guess);
ss_cfpd = ss_ini;

write_table4(ss_ini, ss_base, ss_cfp, fullfile('out','table4.txt'), ...
             fullfile('out','table4.csv'));
type(fullfile('out','table4.txt'));

% Transiciones con prevision perfecta. La tercera, con ambas series
% congeladas, cumple dos funciones: es el contrafactual de bienestar de la
% ecuacion (9) y es la prueba de consistencia del solver, porque debe devolver
% el estado estacionario inicial en todos los periodos.
tic;  tr_base = transition_path(pc,                dc,                A, p, ss_ini, ss_base);  t1 = toc;
tic;  tr_cfp  = transition_path(pc(1)*ones(T+1,1), dc,                A, p, ss_ini, ss_cfp );  t2 = toc;
tic;  tr_cfpd = transition_path(pc(1)*ones(T+1,1), dc(1)*ones(T+1,1), A, p, ss_ini, ss_cfpd);  t3 = toc;

fprintf('\nTransiciones, T = %d\n', T);
fprintf('  %-28s resid %8.2e  %3d iter  %5.1f s\n', 'base', tr_base.resid, tr_base.iter, t1);
fprintf('  %-28s resid %8.2e  %3d iter  %5.1f s\n', 'precio TIC fijo', tr_cfp.resid, tr_cfp.iter, t2);
fprintf('  %-28s resid %8.2e  %3d iter  %5.1f s\n', 'precio y depreciacion fijos', tr_cfpd.resid, tr_cfpd.iter, t3);

% Bienestar. El contrafactual relevante para la ecuacion (9) es el de precio y
% depreciacion constantes: mide lo que el hogar gana por el abaratamiento del
% capital TIC, no por su reasignacion entre tipos de capital.
t0_years = (p.year0:p.year1)';
lam = zeros(numel(t0_years),1);
for k = 1:numel(t0_years)
    lam(k) = welfare_gain(tr_base.a.c, tr_cfpd.a.c, t0_years(k)-p.year0+1, p.beta);
end
cons_gain = 100*(tr_base.a.c(1:iT)./tr_base.a.c(1) - 1);

fid = fopen(fullfile('out','welfare.csv'), 'w');
fprintf(fid, 'year,lambda_pct,cons_gain_pct\n');
for k = 1:numel(t0_years)
    fprintf(fid, '%d,%.6f,%.6f\n', t0_years(k), 100*lam(k), cons_gain(k));
end
fclose(fid);

fprintf('\nBienestar: lambda por ano de evaluacion (%%)\n');
marcas = [1950 1960 1970 1980 1990 2000 2013];
fprintf('  %4d  %5.2f\n', [marcas; 100*lam(ismember(t0_years, marcas))']);
fprintf('  Referencia del paper: 4 por ciento para quienes optimizan en 1980.\n');

make_figures(tr_base, tr_cfp, tr_cfpd, t0_years, lam, cons_gain, p, iT);
write_diagnostics(ss_ini, ss_base, ss_cfp, tr_base, tr_cfp, tr_cfpd, A, src, ...
                  lam(t0_years == 1980), fullfile('out','diagnostics.txt'));
