function make_figures(tr_base, tr_cfp, tr_cfpd, t0_years, lam, cons_gain, p, iT)
% Figuras 7 y 8.
%
% Figura 7: transicion 1950-2013 de la simulacion base y de los dos
% contrafactuales, para producto, capital TIC, participacion del trabajo,
% participacion del capital TIC, rutina y no rutina, y consumo. La distancia
% vertical entre la linea base y la contrafactual en cada panel es el efecto
% atribuible al abaratamiento del capital TIC.
%
% Figura 8: lambda por ano de evaluacion y ganancia contemporanea de consumo.
% El panel B explica la pendiente del panel A: como las diferencias de consumo
% son practicamente nulas hasta 1980, lo que separa a las cohortes tempranas
% de las tardias antes de esa fecha es descuento, no consumo perdido.
%
% Entradas: tr_base, tr_cfp, tr_cfpd  salidas de transition_path
%           t0_years, lam            anos de evaluacion y lambda
%           cons_gain                100*(c_t/c_1950 - 1)
%           p                        parametros
%           iT                       indice del ultimo ano de datos (2013)

    yr = (p.year0:p.year1)';
    r  = 1:iT;

    figure('position', [0 0 1100 780]);

    subplot(3,2,1)
    plot(yr, log(tr_base.a.y(r)), '-', 'linewidth', 2); hold on
    plot(yr, log(tr_cfp.a.y(r)),  '--', 'linewidth', 1.5);
    plot(yr, log(tr_cfpd.a.y(r)), ':',  'linewidth', 1.5);
    title('A. Producto (log)'); xlim([p.year0 p.year1]); grid on
    legend('base', 'precio TIC fijo', 'precio y depr. fijos', 'location', 'northwest');

    subplot(3,2,2)
    plot(yr, log(tr_base.K(r,2)), '-', 'linewidth', 2); hold on
    plot(yr, log(tr_cfp.K(r,2)),  '--', 'linewidth', 1.5);
    plot(yr, log(tr_cfpd.K(r,2)), ':',  'linewidth', 1.5);
    title('B. Capital TIC (log)'); xlim([p.year0 p.year1]); grid on

    subplot(3,2,3)
    plot(yr, 100*tr_base.a.s_L(r), '-', 'linewidth', 2); hold on
    plot(yr, 100*tr_cfp.a.s_L(r),  '--', 'linewidth', 1.5);
    plot(yr, 100*tr_cfpd.a.s_L(r), ':',  'linewidth', 1.5);
    title('C. Participacion del trabajo (%)'); xlim([p.year0 p.year1]); grid on

    subplot(3,2,4)
    plot(yr, 100*tr_base.a.s_c(r), '-', 'linewidth', 2); hold on
    plot(yr, 100*tr_cfp.a.s_c(r),  '--', 'linewidth', 1.5);
    plot(yr, 100*tr_cfpd.a.s_c(r), ':',  'linewidth', 1.5);
    title('D. Participacion del capital TIC (%)'); xlim([p.year0 p.year1]); grid on

    subplot(3,2,5)
    plot(yr, 100*tr_base.a.s_r(r),  '-',  'linewidth', 2); hold on
    plot(yr, 100*tr_base.a.s_nr(r), '-',  'linewidth', 2);
    plot(yr, 100*tr_cfpd.a.s_r(r),  ':',  'linewidth', 1.5);
    plot(yr, 100*tr_cfpd.a.s_nr(r), ':',  'linewidth', 1.5);
    title('E. Rutina y no rutina (%)'); xlim([p.year0 p.year1]); grid on
    legend('rutina, base', 'no rutina, base', 'rutina, contraf', 'no rutina, contraf', ...
           'location', 'west');

    subplot(3,2,6)
    plot(yr, log(tr_base.a.c(r)), '-', 'linewidth', 2); hold on
    plot(yr, log(tr_cfpd.a.c(r)), ':', 'linewidth', 1.5);
    title('F. Consumo (log)'); xlim([p.year0 p.year1]); grid on

    print(fullfile('out','fig7.png'), '-dpng', '-r140');
    close

    figure('position', [0 0 1000 380]);
    subplot(1,2,1)
    plot(t0_years, 100*lam, '-', 'linewidth', 2); grid on
    xlabel('ano de evaluacion t_0'); title('A. lambda: ganancia equivalente (%)');
    xlim([p.year0 p.year1]);
    subplot(1,2,2)
    plot(yr, cons_gain, '-', 'linewidth', 2); grid on
    xlabel('ano'); title('B. 100 x (c_t/c_{1950} - 1)');
    xlim([p.year0 p.year1]);
    print(fullfile('out','fig8.png'), '-dpng', '-r140');
    close
end
