function write_table4(s0, sb, scf, ftxt, fcsv)
% Tabla 4: comparacion de estados estacionarios, en texto y en csv.
%
% Contrasta el estado estacionario inicial, con precio y depreciacion del TIC
% de 1950, contra el final de la simulacion base, con valores de 2013, y
% contra el del contrafactual. La ultima fila de cada panel es la diferencia
% en diferencias, que es la que el paper interpreta como el efecto del
% abaratamiento del capital TIC.
%
% El contrafactual mantiene constante el precio del TIC y deja que la
% depreciacion siga los datos, no ambos: es lo que dice la nota de la tabla
% original ("constant ICT price") y lo unico compatible con sus cifras. Con
% ambos fijos el contrafactual coincidiria con el estado estacionario inicial
% y las columnas de cambio serian cero, no las que reporta el paper.
%
% Entradas: s0    estado estacionario inicial
%           sb    estado estacionario final, base
%           scf   estado estacionario final, contrafactual
%           ftxt  ruta del archivo de texto
%           fcsv  ruta del archivo csv

    L  = @(s) 100*(s.s_r + s.s_nr);
    ly = @(s) log(s.y);   lc = @(s) log(s.c);
    lkc= @(s) log(s.kc);  lkn= @(s) log(s.kn);

    fid = fopen(ftxt, 'w');
    w = @(varargin) fprintf(fid, varargin{:});

    w('Tabla 4. Los efectos de la caida del precio del capital TIC\n');
    w('Replicacion de Eden & Gaggl (2018), RED 29, 15-43.\n');
    w('Contrafactual: precio del TIC constante en su nivel de 1950.\n\n');

    w('A. Producto y consumo\n');
    w('%-14s %9s %9s %8s   %9s %9s %8s\n', '', 'log y', 'contraf', 'dif', 'log c', 'contraf', 'dif');
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', 'EE inicial', ly(s0), ly(s0), 0, lc(s0), lc(s0), 0);
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', 'EE final', ly(sb), ly(scf), ly(sb)-ly(scf), lc(sb), lc(scf), lc(sb)-lc(scf));
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', '100 x cambio', ...
      100*(ly(sb)-ly(s0)), 100*(ly(scf)-ly(s0)), 100*(ly(sb)-ly(scf)), ...
      100*(lc(sb)-lc(s0)), 100*(lc(scf)-lc(s0)), 100*(lc(sb)-lc(scf)));

    w('\nB. Capital TIC y no TIC\n');
    w('%-14s %9s %9s %8s   %9s %9s %8s\n', '', 'log TIC', 'contraf', 'dif', 'log NTIC', 'contraf', 'dif');
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', 'EE inicial', lkc(s0), lkc(s0), 0, lkn(s0), lkn(s0), 0);
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', 'EE final', lkc(sb), lkc(scf), lkc(sb)-lkc(scf), lkn(sb), lkn(scf), lkn(sb)-lkn(scf));
    w('%-14s %9.2f %9.2f %8.2f   %9.2f %9.2f %8.2f\n', '100 x cambio', ...
      100*(lkc(sb)-lkc(s0)), 100*(lkc(scf)-lkc(s0)), 100*(lkc(sb)-lkc(scf)), ...
      100*(lkn(sb)-lkn(s0)), 100*(lkn(scf)-lkn(s0)), 100*(lkn(sb)-lkn(scf)));

    w('\nC. Participacion del trabajo (%%)\n');
    w('%-14s %8s %8s %7s  %8s %8s %7s  %8s %8s %7s\n', '', ...
      'agreg', 'contraf', 'dif', 'rutina', 'contraf', 'dif', 'no rut', 'contraf', 'dif');
    w('%-14s %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f\n', 'EE inicial', ...
      L(s0), L(s0), 0, 100*s0.s_r, 100*s0.s_r, 0, 100*s0.s_nr, 100*s0.s_nr, 0);
    w('%-14s %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f\n', 'EE final', ...
      L(sb), L(scf), L(sb)-L(scf), 100*sb.s_r, 100*scf.s_r, 100*(sb.s_r-scf.s_r), ...
      100*sb.s_nr, 100*scf.s_nr, 100*(sb.s_nr-scf.s_nr));
    w('%-14s %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f  %8.2f %8.2f %7.2f\n', 'cambio', ...
      L(sb)-L(s0), L(scf)-L(s0), L(sb)-L(scf), ...
      100*(sb.s_r-s0.s_r), 100*(scf.s_r-s0.s_r), 100*(sb.s_r-scf.s_r), ...
      100*(sb.s_nr-s0.s_nr), 100*(scf.s_nr-s0.s_nr), 100*(sb.s_nr-scf.s_nr));

    w('\nD. Participacion del capital TIC (%%)\n');
    w('%-14s %8s %8s %7s\n', '', 'TIC', 'contraf', 'dif');
    w('%-14s %8.2f %8.2f %7.2f\n', 'EE inicial', 100*s0.s_c, 100*s0.s_c, 0);
    w('%-14s %8.2f %8.2f %7.2f\n', 'EE final', 100*sb.s_c, 100*scf.s_c, 100*(sb.s_c-scf.s_c));
    w('%-14s %8.2f %8.2f %7.2f\n', 'cambio', ...
      100*(sb.s_c-s0.s_c), 100*(scf.s_c-s0.s_c), 100*(sb.s_c-scf.s_c));

    w('\nParticipacion del capital no TIC: %.2f%% en todo momento (igual a alpha).\n', 100*s0.s_n);
    w('Residuo maximo del solver de estado estacionario: %.2e\n', ...
      max([s0.resid, sb.resid, scf.resid]));
    fclose(fid);

    fid = fopen(fcsv, 'w');
    fprintf(fid, 'variable,ee_inicial,ee_final_base,ee_final_contraf\n');
    rows = {'log_y', ly(s0), ly(sb), ly(scf); 'log_c', lc(s0), lc(sb), lc(scf);
            'log_kc', lkc(s0), lkc(sb), lkc(scf); 'log_kn', lkn(s0), lkn(sb), lkn(scf);
            'labor_share_pct', L(s0), L(sb), L(scf);
            'routine_share_pct', 100*s0.s_r, 100*sb.s_r, 100*scf.s_r;
            'nonroutine_share_pct', 100*s0.s_nr, 100*sb.s_nr, 100*scf.s_nr;
            'ict_share_pct', 100*s0.s_c, 100*sb.s_c, 100*scf.s_c;
            'nict_share_pct', 100*s0.s_n, 100*sb.s_n, 100*scf.s_n};
    for k = 1:size(rows,1)
        fprintf(fid, '%s,%.6f,%.6f,%.6f\n', rows{k,1}, rows{k,2}, rows{k,3}, rows{k,4});
    end
    fclose(fid);
end
