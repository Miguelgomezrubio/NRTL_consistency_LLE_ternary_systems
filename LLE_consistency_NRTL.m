function [gamma_fase1, gamma_fase2, a0, a1, alfa_vec] = LLE_consistency_NRTL(excel_file_name, dataname, export_pdf)
% LLE_CONSISTENCY_NRTL
% ES: Ejecuta el cálculo de consistencia LLE con formulación Wi para un sistema
%     ternario, leyendo datos desde Excel, calculando gammas y generando
%     figuras (binarios, cortes, superficie, binodales).
% EN: Runs LLE consistency calculation with the Wi formulation for a ternary 
%     system, reading Excel data, computing activity coefficients, and generating 
%     figures (binary plots, tie-line cuts, surface, binodals).

% =========================
% EXPORT (SETUP) - AÑADIDO
% ES: Configura exportación a PDF (opcional).
% EN: Configure optional PDF export.
% =========================
if nargin < 3 || isempty(export_pdf)
    export_pdf = true;
end

if export_pdf
    exportFolder = 'export';
    if ~exist(exportFolder, 'dir')
        mkdir(exportFolder);
    end
    % ES: Guardar figuras existentes antes de ejecutar (evita reexportar).
    % EN: Store existing figures before running (avoid re-exporting).
    figs_before = findall(0,'Type','figure');
else
    exportFolder = '';
    figs_before = [];
end

% =========================
% LEYENDAS (SETUP) - AÑADIDO
% ES: Ajuste global de leyendas (fuera, arriba a la derecha).
% EN: Global legend defaults (outside, upper right).
% =========================
set(groot, ...
    'defaultLegendLocation', 'northeastoutside', ...
    'defaultLegendBox', 'on');

% -------------------------------------------------------------------------
% funcion principal:
%   - lee datos desde el excel 'tfm_1_mgr.xlsx' (hoja = dataname)
%   - calcula coeficientes de actividad gamma en ambas fases
%   - calcula y grafica g^M/RT para los binarios
%   - grafica cortes de g^M/RT en las rectas de reparto
%   - grafica pares de equilibrio calculados vs experimentales
%
% salida:
%   gamma_fase1, gamma_fase2 : matrices Lx3 con coeficientes de actividad
%
% EN: Main function flow:
%   - read data from Excel (sheet = dataname)
%   - compute activity coefficients gamma in both phases
%   - compute/plot g^M/RT for binary systems
%   - plot g^M/RT cuts along tie lines
%   - plot calculated vs experimental equilibrium pairs
%
% output:
%   gamma_fase1, gamma_fase2 : Lx3 matrices with activity coefficients
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% LECTURA AUTOMÁTICA DE DATOS SEGÚN EL ARCHIVO DE EXCEL
% ES: Lectura de temperatura, composiciones y parámetros NRTL.
% EN: Read temperature, compositions, and NRTL parameters.
% -------------------------------------------------------------------------



   
        % ES: Temperatura (escala del modelo).
        % EN: Temperature (model scale).
        % TEMPLATE: Celda C3
        t = readmatrix(excel_file_name,'sheet', dataname, 'Range','C3:C3');

        % ES: Parámetros NRTL (a0, a1, alfa) - lectura en columna.
        % EN: NRTL parameters (a0, a1, alpha) - column reading.
        % TEMPLATE: a0 en B8:B13 (A12,A21,A13,A31,A23,A32)
        %           a1 en D8:D13 (A12,A21,A13,A31,A23,A32)
        %           alfa en F8:F10 (alfa12, alfa13, alfa23)
        
        % Leer vectores de parámetros
        a0_vec = readmatrix(excel_file_name,'sheet', dataname, 'Range','B8:B13');
        a1_vec = readmatrix(excel_file_name,'sheet', dataname, 'Range','D8:D13');
        alfa_vec = readmatrix(excel_file_name,'sheet', dataname, 'Range','F8:F10');
        
        % Construir matrices a0 y a1 desde vectores [A12;A21;A13;A31;A23;A32]
        a0 = [0,         a0_vec(1), a0_vec(3);
              a0_vec(2), 0,         a0_vec(5);
              a0_vec(4), a0_vec(6), 0];
        
        a1 = [0,         a1_vec(1), a1_vec(3);
              a1_vec(2), 0,         a1_vec(5);
              a1_vec(4), a1_vec(6), 0];

        % ES: Composiciones fase 1 experimentales y calculadas (hasta 100 puntos).
        % EN: Phase 1 experimental and calculated compositions (up to 100 points).
        % TEMPLATE: Exp en B19:D118, Cal en E19:G118
        x_fase1_exp = readmatrix(excel_file_name,'sheet', dataname, 'Range','B19:D118');
        x_fase1_exp = x_fase1_exp(all(~isnan(x_fase1_exp),2),:);

        x_fase1 = readmatrix(excel_file_name,'sheet', dataname, 'Range','E19:G118');
        x_fase1 = x_fase1(all(~isnan(x_fase1),2),:);

        % ES: Composiciones fase 2 experimentales y calculadas (hasta 100 puntos).
        % EN: Phase 2 experimental and calculated compositions (up to 100 points).
        % TEMPLATE: Exp en I19:K118, Cal en L19:N118
        x_fase2_exp = readmatrix(excel_file_name,'sheet', dataname, 'Range','I19:K118');
        x_fase2_exp = x_fase2_exp(all(~isnan(x_fase2_exp),2),:);

        x_fase2 = readmatrix(excel_file_name,'sheet', dataname, 'Range','L19:N118');
        x_fase2 = x_fase2(all(~isnan(x_fase2),2),:);

        % ES: Composiciones calculadas para comparación.
        % EN: Calculated compositions for comparison.
        x_fase2_calc = x_fase2;

    

% -------------------------------------------------------------------------
% calculo de gammas en cada punto de equilibrio
% ES: Calcula gammas para cada punto en fase 1 y fase 2.
% EN: Compute gammas for each phase-1/phase-2 point.
% -------------------------------------------------------------------------
L = size(x_fase1,1);
gamma_fase1 = zeros(L,3);
gamma_fase2 = zeros(L,3);

for i = 1:L
    % ES: Gamma para la fase 1 (usa NRTL).
    % EN: Gamma for phase 1 (using NRTL).
    [gamma_fase1(i,:), tau, G] = parametos_gamma_nrtl(x_fase1(i,:) , a0, a1, alfa_vec, t);
end

for i = 1:L
    % ES: Gamma para la fase 2 (usa NRTL).
    % EN: Gamma for phase 2 (using NRTL).
    [gamma_fase2(i,:), tau, G] = parametos_gamma_nrtl(x_fase2(i,:) , a0, a1, alfa_vec, t);
end

% ES: Generar superficie gM (con rectas de reparto).
% EN: Generate gM surface (with tie lines).
superficie_gM_ternario(tau, G, 91, 'x1x2', ...
                       x_fase1, x_fase2_calc, ...
                       x_fase1_exp,  x_fase2_exp);

% -------------------------------------------------------------------------
% binarios
% ES: Construye composiciones binarias y calcula g_M.
% EN: Build binary compositions and compute g_M.
% -------------------------------------------------------------------------
format short
n = 100;

x1 = linspace(0,1,n)'; x2 = 1 - x1; x3 = zeros(n,1);
binario12 = [x1 x2 x3];

x1 = linspace(0,1,n)'; x3 = 1 - x1; x2 = zeros(n,1);
binario13 = [x1 x2 x3];

x2 = linspace(0,1,n)'; x3 = 1 - x2; x1 = zeros(n,1);
binario23 = [x1 x2 x3];

g_M_binario12 = g_mezcla_binarios(binario12, tau, G);
g_M_binario13 = g_mezcla_binarios(binario13, tau, G);
g_M_binario23 = g_mezcla_binarios(binario23, tau, G);

% ES: Figura binario 1-2.
% EN: Binary 1-2 figure.
fig = figure; set(fig, 'Tag', 'tfm_binarios');
plot(binario12(:,2), g_M_binario12,"LineWidth",1.5); title('Binario 1-2'); xlabel('x_2'); ylabel('G^M/RT')
% ES: Figura binario 2-3.
% EN: Binary 2-3 figure.
fig = figure; set(fig, 'Tag', 'tfm_binarios');
plot(binario23(:,2), g_M_binario23,"LineWidth",1.5); title('Binario 2-3'); xlabel('x_2'); ylabel('G^M/RT')
% ES: Figura binario 1-3.
% EN: Binary 1-3 figure.
fig = figure; set(fig, 'Tag', 'tfm_binarios');
plot(binario13(:,1), g_M_binario13,"LineWidth",1.5); title('Binario 1-3'); xlabel('x_1'); ylabel('G^M/RT')

% ---- figura combinada 3 binarios (hacerla más ancha para que no encoja el plot) ----
% ES: Figura combinada con tres curvas.
% EN: Combined figure with three curves.
fig = figure;
set(fig, 'Tag', 'tfm_binarios');
set(gcf,'Units','pixels');
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) pos(3)*1.35 pos(4)]); % +35% ancho

h12 = plot(binario12(:,2), g_M_binario12, '-', 'LineWidth', 2.5, 'Color', [0 0.4470 0.7410]); hold on
h13 = plot(binario13(:,1), g_M_binario13, '-', 'LineWidth', 1.8, 'Color', [0.8500 0.3250 0.0980]);
h23 = plot(binario23(:,2), g_M_binario23, '-', 'LineWidth', 1.2, 'Color', [0.4660 0.6740 0.1880]);
yline(0, '-', 'LineWidth', 1);

title('G^M/RT binarios')
xlabel('x_1, x_2')
ylabel('G^M/RT')

% leyenda fuera, derecha-arriba + un poco más grande
lgd = legend([h12 h13 h23], ...
    {'1-2 (x_2)', '1-3 (x_1)', '2-3 (x_2)'}, ...
    'Location','northeastoutside');
lgd.FontSize = 12;
lgd.Box = 'on';
% lgd.NumColumns = 2; % (opcional) si quieres que ocupe menos en altura

xtickformat('%.2f'); ytickformat('%.2f')
axis padded
xlim([0 1])
hold off

% -------------------------------------------------------------------------
% rectas de reparto + pares equilibrio
% ES: Plots de cortes y pares de equilibrio.
% EN: Tie-line cuts and equilibrium pairs plots.
% -------------------------------------------------------------------------
plot_cortes_rectas_reparto(x_fase1, x_fase2, tau, G)

plot_pares_equilibrio(x_fase1, x_fase2_calc, ...
                      x_fase1_exp,  x_fase2_exp,  ...
                      'x2-x3');

% =========================
% EXPORT (FINAL) - AÑADIDO
% ES: Exporta solo figuras nuevas si se pidió exportación.
% EN: Export only new figures if export is enabled.
% =========================
if export_pdf
    export_new_figures_to_pdf(figs_before, dataname, exportFolder);
end

end


% =========================================================================
% FUNCIONES LOCALES
% ES: Funciones auxiliares de graficado y utilidades.
% EN: Helper plotting/utility functions.
% =========================================================================
function h = plot_pares_equilibrio(x_fase1, x_fase2_calc, ...
                                   x_fase1_exp,  x_fase2_exp,  ...
                                   eje, varargin)
% plot_pares_equilibrio
% -------------------------------------------------------------------------
% grafica pares de equilibrio calculados y experimentales:
%   - para cada par (fase1, fase2) dibuja la recta que los une
%   - usa componentes indicados por 'eje' (ej. 'x3-x2')
%
% Cambios:
%   - extremos: exp -> cuadrados sólidos, cal -> círculos huecos
%   - "calc" -> "cal"
%   - leyenda: exp primero, cal segundo
%   - leyenda fuera (derecha arriba): 'northeastoutside'
%   - ejes con 2 decimales
% -------------------------------------------------------------------------
% EN:
%   - Plot calculated/experimental equilibrium pairs
%   - For each pair, draw the tie line connecting phase 1 and phase 2
%   - Uses the components indicated by 'eje' (e.g., 'x3-x2')
%
% Changes:
%   - exp endpoints: solid squares; cal endpoints: hollow circles
%   - "calc" -> "cal" in labels
%   - legend: exp first, cal second
%   - legend outside (upper right): 'northeastoutside'
%   - axes with 2 decimals
% -------------------------------------------------------------------------

[ix, iy] = parse_eje(eje);
etiquetas = {sprintf('x_%d', ix), sprintf('x_%d', iy)};

fig = figure;
set(fig, 'Tag', 'tfm_binodal');
hold on;

% --- calculados (cal) ---
nc = size(x_fase1,1);
hcal = gobjects(0);
for i = 1:nc
    x = [x_fase1(i,ix), x_fase2_calc(i,ix)];
    y = [x_fase1(i,iy), x_fase2_calc(i,iy)];

    hcal = plot(x, y, 'r--', 'LineWidth', 1.2, varargin{:}); % linea

    % ambos extremos: circulo hueco
    plot(x_fase1(i,ix), x_fase1(i,iy), 'ro', ...
        'MarkerFaceColor','none', 'LineWidth', 1.0);
    plot(x_fase2_calc(i,ix), x_fase2_calc(i,iy), 'ro', ...
        'MarkerFaceColor','none', 'LineWidth', 1.0);
end

% --- experimentales (exp) ---
ne = size(x_fase1_exp,1);
hexp = gobjects(0);
for i = 1:ne
    x = [x_fase1_exp(i,ix), x_fase2_exp(i,ix)];
    y = [x_fase1_exp(i,iy), x_fase2_exp(i,iy)];

    hexp = plot(x, y, 'b-', 'LineWidth', 1.4, varargin{:}); % linea

    % ambos extremos: cuadrado sólido
    plot(x_fase1_exp(i,ix), x_fase1_exp(i,iy), 'bs', ...
        'MarkerFaceColor','b', 'LineWidth', 1.0);
    plot(x_fase2_exp(i,ix), x_fase2_exp(i,iy), 'bs', ...
        'MarkerFaceColor','b', 'LineWidth', 1.0);
end

xlabel(etiquetas{1});
ylabel(etiquetas{2});
box on;

% --- formato de ejes: 2 decimales ---
xtickformat('%.2f')
ytickformat('%.2f')

% Ajuste de los límites de los ejes (con margen)
all_x = [x_fase1(:,ix); x_fase2_calc(:,ix); ...
         x_fase1_exp(:,ix);  x_fase2_exp(:,ix)];
all_y = [x_fase1(:,iy); x_fase2_calc(:,iy); ...
         x_fase1_exp(:,iy);  x_fase2_exp(:,iy)];

buffer = 0.05; % Margen adicional (5%)
x_lim = [min(all_x), max(all_x)] + [-1, 1] * (max(all_x) - min(all_x)) * buffer;
y_lim = [min(all_y), max(all_y)] + [-1, 1] * (max(all_y) - min(all_y)) * buffer;
axis([x_lim, y_lim]);

% Añade "aire" alrededor (ayuda y con leyenda fuera queda mejor)
axis padded


% --- leyenda: exp primero, cal segundo, fuera ---
lgd = legend([hexp, hcal], {'exp','cal'}, 'Location','northeastoutside');
lgd.Box = 'on';
lgd.FontSize = 9;

h = gca;
hold off
end


function [ix, iy] = parse_eje(eje)
% parse_eje
% -------------------------------------------------------------------------
% interpreta el argumento 'eje' para elegir componentes:
%   - si es vector numerico [i j], usa esos indices
%   - si es string tipo 'x3-x2', 'x2 vs x1', etc.
% EN: Parse the 'eje' argument to choose components:
%   - if numeric vector [i j], use those indices
%   - if string like 'x3-x2', 'x2 vs x1', etc.
% -------------------------------------------------------------------------
if isnumeric(eje) && numel(eje)==2
    ix = eje(1);
    iy = eje(2);
else
    s = lower(string(eje));
    s = regexprep(s, '\s+', '');
    s = strrep(s, 'vs', '-');
    s = strrep(s, 'w', '');
    s = strrep(s, 'x', '');
    tokens = regexp(s, '([123])[-]?([123])', 'tokens', 'once');
    if isempty(tokens)
        error('formato de "eje" no reconocido.');
    end
    ix = str2double(tokens{1});
    iy = str2double(tokens{2});
end

if any(~ismember([ix iy],[1 2 3])) || ix==iy
    error('indices de eje deben ser distintos y estar en {1,2,3}.');
end
end


function g_M = g_mezcla_binarios(x, tau, G)
% g_mezcla_binarios
% -------------------------------------------------------------------------
% calcula g^M/RT para un conjunto de composiciones de un sistema ternario
% usando el modelo NRTL (partes excesiva + ideal).
% EN: Compute g^M/RT for ternary compositions using NRTL (excess + ideal).
%
% entrada:
%   x   : kx3 (cada fila una composicion: [x1 x2 x3])
%   tau : 3x3 parametros NRTL (tau_ij)
%   G   : 3x3 matriz G_ij = exp(-alfa_ij * tau_ij)
% EN:
%   x   : kx3 (each row is a composition: [x1 x2 x3])
%   tau : 3x3 NRTL parameters (tau_ij)
%   G   : 3x3 matrix G_ij = exp(-alpha_ij * tau_ij)
%
% salida:
%   g_M : kx1 valores de g^M/RT
% EN:
%   g_M : kx1 values of g^M/RT
% -------------------------------------------------------------------------
k = size(x,1);
g_M = zeros(k,1);         % preasigna
x = max(x, eps);          % evita log(0)

for i = 1:k
    % termino i = 1
    num1 = x(i,1)*tau(1,1)*G(1,1) + x(i,2)*tau(2,1)*G(2,1) + x(i,3)*tau(3,1)*G(3,1);
    den1 = x(i,1)*G(1,1)           + x(i,2)*G(2,1)           + x(i,3)*G(3,1);
    t1   = x(i,1) * (num1/den1);

    % termino i = 2
    num2 = x(i,1)*tau(1,2)*G(1,2) + x(i,2)*tau(2,2)*G(2,2) + x(i,3)*tau(3,2)*G(3,2);
    den2 = x(i,1)*G(1,2)          + x(i,2)*G(2,2)          + x(i,3)*G(3,2);
    t2   = x(i,2) * (num2/den2);

    % termino i = 3
    num3 = x(i,1)*tau(1,3)*G(1,3) + x(i,2)*tau(2,3)*G(2,3) + x(i,3)*tau(3,3)*G(3,3);
    den3 = x(i,1)*G(1,3)          + x(i,2)*G(2,3)          + x(i,3)*G(3,3);
    t3   = x(i,3) * (num3/den3);

    g_E  = t1 + t2 + t3;  % g^E/RT
    g_id = x(i,1)*log(x(i,1)) + x(i,2)*log(x(i,2)) + x(i,3)*log(x(i,3));
    g_M(i) = g_E + g_id;  % g^M/RT
end
end

function plot_cortes_rectas_reparto(xf1, xf2, tau, G)
% plot_cortes_rectas_reparto
% -------------------------------------------------------------------------
% grafica cortes de g^M/RT en las rectas de reparto
% EN: Plot g^M/RT cuts along tie lines.
% -------------------------------------------------------------------------

L = size(xf1,1);

for i = 1:L
    % recta por los puntos (x2,x3) de ambas fases
    [m,b] = recta_por_puntos(xf1(i,2), xf1(i,3), xf2(i,2), xf2(i,3));

    % limites de x2 en el corte
    lb_x2 = min(xf1(i,2), xf2(i,2)); %#ok<NASGU>
    
    ub_x2 = 1.025 * max(xf1(i,2), xf2(i,2)); % factor para ver algo mas de curva

    % discretizacion
    x2_axis = linspace(0, ub_x2, 300);
    x3_axis = m .* x2_axis + b;
    x1_axis = 1 - x2_axis - x3_axis;

    x = [x1_axis' x2_axis' x3_axis'];

    % g^M/RT a lo largo de la recta de reparto
    gM = g_mezcla_binarios(x, tau, G);

    % g^M/RT en los puntos de equilibrio
    gM_puntos = g_mezcla_binarios([xf1(i,:); xf2(i,:)], tau, G);

    % grafica
    fig = figure;
    set(fig, 'Tag', 'tfm_cortes');
    plot(x2_axis, gM)
    hold on
    plot([xf1(i,2), xf2(i,2)], ...
         [gM_puntos(1), gM_puntos(2)], ...
         '--o', 'color', [1 0.5 0],...
         'MarkerSize', 5)
    xlabel('x_2')
    ylabel('G^M/RT')
    title(['Recta de reparto ' num2str(i)])

    % formato de ejes: 2 decimales
    xtickformat('%.2f')
    ytickformat('%.2f')

    % leyenda fuera, derecha arriba
    lgd = legend({'G^M/RT','LLE cal'}, 'Location','northeastoutside');
    lgd.FontSize = 10;
    lgd.ItemTokenSize = [16 10];
    lgd.Box = 'on';

    axis padded
   

    hold off
end
end


function [gamma, tau, G] = parametos_gamma_nrtl(x, a0, a1, alfa_vec, t)
% parametos_gamma_nrtl
% -------------------------------------------------------------------------
% calcula los parametros del modelo NRTL y los coeficientes de actividad
% EN: Compute NRTL parameters and activity coefficients.
% -------------------------------------------------------------------------

x = x(:);   % asegura vector columna 3x1

% construir matriz alfa simetrica desde alfa_vec = [alfa12; alfa13; alfa23]
alfa = zeros(3);
alfa(1,2) = alfa_vec(1); alfa(2,1) = alfa_vec(1);
alfa(1,3) = alfa_vec(2); alfa(3,1) = alfa_vec(2);
alfa(2,3) = alfa_vec(3); alfa(3,2) = alfa_vec(3);

% tau = (a0 + a1*t)/t
tau = (a0 + a1*t) ./ t;

% G = exp(-alfa .* tau)
G = exp(-alfa .* tau);

% calcular ln(gamma) segun expresion NRTL
lng = zeros(3,1);
for i = 1:3
    denom1 = x.' * G(:,i);
    num1   = x.' * (tau(:,i) .* G(:,i));
    term1  = num1 / denom1;

    term2 = 0;
    for j = 1:3
        denom2 = x.' * G(:,j);
        num2   = x.' * (tau(:,j) .* G(:,j));
        term2  = term2 + ( x(j)*G(i,j)/denom2 ) * ( tau(i,j) - num2/denom2 );
    end

    lng(i) = term1 + term2;
end

gamma = exp(lng);
end

% SUPERFÍCIE DE GM
function superficie_gM_ternario(tau, G, npts, eje, ...
                                x_fase1, x_fase2_calc, ...
                                ~,  ~)
% superficie_gM_ternario
% -------------------------------------------------------------------------
% genera y grafica la superficie de G^M/RT para un sistema ternario NRTL
% y superpone las rectas de reparto calculadas
% EN: Generate and plot the G^M/RT surface for a ternary NRTL system and
%     overlay calculated tie lines.
% -------------------------------------------------------------------------

if nargin < 3
    npts = 51;
end
if nargin < 4
    eje = [1 2];
end

% -------- interpretar el argumento "eje" --------
if ischar(eje) || isstring(eje)
    s = lower(strrep(strrep(char(eje),'(',''),')',''));
    s = strrep(s,' ','');
    s = strrep(s,'x','');
    if strcmp(s,'12') || strcmp(s,'1-2')
        idx = [1 2];
    elseif strcmp(s,'23') || strcmp(s,'2-3')
        idx = [2 3];
    else
        error('eje debe ser ''x1x2'', ''x2x3'' o similar.');
    end
else
    idx = eje(:).';
end

if numel(idx) ~= 2 || any(~ismember(idx,[1 2 3])) || idx(1)==idx(2)
    error('eje debe contener dos indices distintos en {1,2,3}.');
end

i = idx(1);
j = idx(2);
k = setdiff(1:3, [i j]);

% -------- malla de la superficie --------
eps_min = 1e-10;
eps_max = 1 - 1e-10;

[u_grid, v_grid] = meshgrid(linspace(eps_min, eps_max, npts));

x1_grid = zeros(size(u_grid));
x2_grid = zeros(size(u_grid));
x3_grid = zeros(size(u_grid));

x_grid = {x1_grid, x2_grid, x3_grid};
x_grid{i} = u_grid;
x_grid{j} = v_grid;
x_grid{k} = 1 - x_grid{i} - x_grid{j}-eps_min;

x1_grid = x_grid{1};
x2_grid = x_grid{2};
x3_grid = x_grid{3};

mask_valida = (x1_grid >= 0) & (x2_grid >= 0) & (x3_grid >= 0);

x_vect = [x1_grid(:), x2_grid(:), x3_grid(:)];
gM_vect = g_mezcla_binarios(x_vect, tau, G);
gM_vect(~mask_valida(:)) = NaN;
gM_grid = reshape(gM_vect, size(u_grid));

% -------- figura: malla tipo wireframe --------
fig = figure;
set(fig, 'Tag', 'tfm_superficie');
% hacerla más ancha para que la leyenda fuera no "encoja" el plot
set(gcf,'Units','pixels');
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) pos(3)*1.45 pos(4)]); % +45% ancho

mesh(u_grid, v_grid, gM_grid);
colormap(winter);
hold on;

xlabel(sprintf('x_%d', i));
ylabel(sprintf('x_%d', j));
zlabel('G^M/RT');
title('G^M/RT (NRTL)');
view(3);

% -------------------------------------------------------------------------
% superponer rectas de reparto (calculadas)
% -------------------------------------------------------------------------
if ~isempty(x_fase1)
    ncalc = size(x_fase1,1);
    h_calc = gobjects(1,1);
    for n = 1:ncalc
        x1 = x_fase1(n,:);
        x2 = x_fase2_calc(n,:);

        x_line = [x1(i), x2(i)];
        y_line = [x1(j), x2(j)];

        gM_line = g_mezcla_binarios([x1; x2], tau, G);

        h_calc = plot3(x_line, y_line, gM_line.', 'r-', 'linewidth', 1.5);
        plot3(x1(i), x1(j), gM_line(1), 'ko', 'markerfacecolor','r','markersize',5);
        plot3(x2(i), x2(j), gM_line(2), 'ko', 'markerfacecolor','r','markersize',5);
    end
end

% ------------------ LEYENDA ROBUSTA -----------------------
leg_handles = [];
leg_entries = {};

h_surf = findobj(gca,'Type','Surface');
if ~isempty(h_surf)
    leg_handles(end+1) = h_surf(1);
    leg_entries{end+1} = 'G^M/RT';
end

if exist('h_calc','var') && isgraphics(h_calc)
    leg_handles(end+1) = h_calc;
    leg_entries{end+1} = 'Rectas reparto cal';
end

if ~isempty(leg_handles)
    lgd = legend(leg_handles, leg_entries, 'Location','northeastoutside');
    lgd.FontSize = 12;  % más grande para superficie
    lgd.Box = 'on';
end

axis padded
hold off;

end


function [m,b] = recta_por_puntos(x2_1, x3_1, x2_2, x3_2)
% recta_por_puntos
% -------------------------------------------------------------------------
% devuelve la pendiente (m) y la ordenada en el origen (b)
% EN: Return slope (m) and intercept (b) of the line between two points.
% -------------------------------------------------------------------------
x1 = x2_1;
x2 = x2_2;
y1 = x3_1;
y2 = x3_2;

if x1 == x2
    error('la recta es vertical: pendiente infinita, no hay ordenada en el origen.')
end

m = (y2 - y1) / (x2 - x1);
b = y1 - m*x1;
end

% =========================
% EXPORT (FUNCIONES) - AÑADIDO
% =========================
function export_new_figures_to_pdf(figs_before, dataname, exportFolder)
% Exporta SOLO las figuras creadas después de empezar la función.
% EN: Export ONLY figures created after the function started.
figs_after = findall(0,'Type','figure');
new_figs = setdiff(figs_after, figs_before);

if isempty(new_figs)
    return;
end

% ordenar por número
[~, idx] = sort([new_figs.Number]);
new_figs = new_figs(idx);

nameCount = containers.Map('KeyType','char','ValueType','double');

for k = 1:numel(new_figs)
    fig = new_figs(k);

    % sacar título (si existe)
    ttl = "";
    ax = findall(fig, 'Type', 'axes');
    if ~isempty(ax)
        t = get(ax(1), 'Title');
        if isgraphics(t)
            ttl = string(t.String);
        end
    end
    if strlength(strtrim(ttl)) == 0
        ttl = string(fig.Name);
    end
    if strlength(strtrim(ttl)) == 0
        ttl = "figura";
    end

    base = sanitize_filename(ttl);

    key = char(base);
    if isKey(nameCount, key)
        nameCount(key) = nameCount(key) + 1;
    else
        nameCount(key) = 1;
    end
    nn = nameCount(key);

    file = sprintf('%s__%s__%02d.pdf', sanitize_filename(dataname), base, nn);
    outpath = fullfile(exportFolder, file);

    % export PDF
    try
        % Exporta “tight” (sin página tipo A4), vectorial
        exportgraphics(fig, outpath, 'ContentType','vector');
    catch
        % Fallback para MATLAB antiguos: intenta ajustar al tamaño de figura
        set(fig, 'PaperPositionMode', 'auto');
        print(fig, outpath, '-dpdf', '-painters', '-bestfit');
    end

end
end

function s = sanitize_filename(str)
% Convierte texto (dataname/título) en nombre seguro de archivo.
% EN: Convert text (sheet name/title) into a safe filename.
s = string(str);
s = strtrim(s);
s = regexprep(s, '[\s]+', '_');     % espacios -> _
s = regexprep(s, '[^\w\-]+', '');   % quitar raros
s = regexprep(s, '_+', '_');        % __ -> _
s = regexprep(s, '^_+|_+$', '');    % trim _
if strlength(s) == 0
    s = "figura";
end
end
