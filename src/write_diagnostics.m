function write_diagnostics(s0, sb, scf, tr_base, tr_cfp, tr_cfpd, A, src, lam80, f)
% Pruebas de validacion de la solucion numerica. Cuatro controles, tres de
% ellos con contraparte teorica conocida de antemano:
%
%   1. Residuos de los sistemas de Euler y de estado estacionario.
%   2. Si no varia nada exogeno, la transicion debe quedarse clavada en el
%      estado estacionario inicial. Verifica el solver de transicion contra el
%      de estado estacionario, que son codigos independientes.
%   3. Con retornos constantes a escala las cuatro participaciones suman uno
%      en cada periodo: el producto se agota entre los factores.
%   4. El ultimo periodo simulado debe coincidir con el estado estacionario
%      final calculado por separado.
%
% Entradas: estados estacionarios, las tres transiciones, A, la fuente de las
%           series exogenas, lambda en 1980 y la ruta del archivo

    fid = fopen(f, 'w');
    w = @(varargin) fprintf(fid, varargin{:});

    w('Validacion de la solucion numerica\n');
    w('==================================\n\n');
    w('Series exogenas del capital TIC: %s\n', src);
    w('PTF calibrada: A = %.8g\n\n', A);

    w('1. Residuos maximos\n');
    w('   estado estacionario inicial      %.3e\n', s0.resid);
    w('   estado estacionario final base   %.3e\n', sb.resid);
    w('   estado estacionario contraf.     %.3e\n', scf.resid);
    w('   transicion base                  %.3e (%d iteraciones)\n', tr_base.resid, tr_base.iter);
    w('   transicion precio fijo           %.3e (%d iteraciones)\n', tr_cfp.resid, tr_cfp.iter);
    w('   transicion precio y depr. fijos  %.3e (%d iteraciones)\n\n', tr_cfpd.resid, tr_cfpd.iter);

    dk = max(max(abs(tr_cfpd.K - repmat([s0.kn s0.kc], size(tr_cfpd.K,1), 1))));
    w('2. Contrafactual sin variacion exogena: desvio maximo del capital\n');
    w('   respecto al estado estacionario inicial: %.3e\n', dk);
    w('   (debe ser del orden de la tolerancia; confirma que el solver de\n');
    w('    transicion reproduce el estado estacionario cuando nada cambia)\n\n');

    sums = tr_base.a.s_n + tr_base.a.s_c + tr_base.a.s_r + tr_base.a.s_nr;
    w('3. Participaciones de ingreso: desvio maximo de la suma respecto a 1\n');
    w('   %.3e\n\n', max(abs(sums - 1)));

    w('4. Convergencia al estado estacionario final (ultimo periodo simulado)\n');
    w('   log kn: transicion %.6f, estado estacionario %.6f, dif %.2e\n', ...
      log(tr_base.K(end-1,1)), log(sb.kn), log(tr_base.K(end-1,1))-log(sb.kn));
    w('   log kc: transicion %.6f, estado estacionario %.6f, dif %.2e\n\n', ...
      log(tr_base.K(end-1,2)), log(sb.kc), log(tr_base.K(end-1,2))-log(sb.kc));

    w('5. Resultado de bienestar\n');
    w('   lambda en 1980: %.4f%% (paper: aproximadamente 4%%)\n', 100*lam80);
    fclose(fid);
end
