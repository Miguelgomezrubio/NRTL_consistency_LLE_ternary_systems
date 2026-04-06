function LLE_consistency_gui(baseFolder)
% LLE_CONSISTENCY_GUI
% ES: Interfaz grafica para ejecutar LLE_consistency.
%     Permite elegir archivo Excel y hoja con desplegables.
% EN: GUI to run LLE_consistency.
%     Lets you pick Excel file and sheet from drop-downs.

if nargin < 1 || isempty(baseFolder)
    baseFolder = pwd;
end

if ~isfolder(baseFolder)
    error('Folder does not exist: %s', baseFolder);
end

% -------------------- LANGUAGE SYSTEM --------------------
currentLang = 'es';  % Default language: Spanish

% Translation dictionary
strings = struct();
% English
strings.en.windowTitle = 'Miguel Gomez Rubio - TFM 2026 - LLE Consistency in NRTL';
strings.en.folder = 'Folder:';
strings.en.changeFolder = 'Change folder';
strings.en.excel = 'Excel:';
strings.en.sheet = 'Sheet:';
strings.en.export = 'Export:';
strings.en.enableExport = 'Enable export';
strings.en.configExport = 'Configure export...';
strings.en.refreshLists = 'Refresh lists';
strings.en.runFunction = 'Run function';
strings.en.showFigures = 'Show figures:';
strings.en.surfaceGM = 'gM Surface';
strings.en.cutsGM = 'gM Cuts with tie line';
strings.en.binaries = 'Binaries';
strings.en.binodalCurve = 'Binodal Curve';
strings.en.status = 'Status:';
strings.en.close = 'Close';
strings.en.language = 'Language:';
strings.en.ready = 'Ready.';
strings.en.noFiles = '(no files)';
strings.en.noSheets = '(no sheets)';
strings.en.noExcelFound = 'No Excel files found in: %s';
strings.en.detectedExcel = 'Detected %d Excel files.';
strings.en.fileNoSheets = 'File has no available sheets: %s';
strings.en.file = 'File: %s';
strings.en.detectedSheets = 'Sheets detected: %d';
strings.en.errorReadingSheets = 'Error reading sheets from %s';
strings.en.selectValidFile = 'Select a valid file and sheet.';
strings.en.missingData = 'Missing data';
strings.en.functionNotFound = 'Function LLE_consistency_NRTL not found in path.';
strings.en.running = 'Running...';
strings.en.executionError = 'Execution error';
strings.en.done = 'Done.';
strings.en.figuresGenerated = 'Figures: Surface: %d | Cuts: %d | Binaries: %d | Binodal: %d';
strings.en.exported = 'Exported to: %s';
strings.en.noSurfaceFigures = 'No gM surface figures found.';
strings.en.noCutsFigures = 'No gM cuts figures with tie line found.';
strings.en.noBinaryFigures = 'No binary figures found.';
strings.en.noBinodalFigures = 'No binodal curve figures found.';
strings.en.warning = 'Warning';

% Spanish
strings.es.windowTitle = 'LLE Consistency - GUI';
strings.es.folder = 'Carpeta:';
strings.es.changeFolder = 'Cambiar carpeta';
strings.es.excel = 'Excel:';
strings.es.sheet = 'Hoja:';
strings.es.export = 'Exportar:';
strings.es.enableExport = 'Activar exportacion';
strings.es.configExport = 'Configurar exportacion...';
strings.es.refreshLists = 'Actualizar listas';
strings.es.runFunction = 'Ejecutar funcion';
strings.es.showFigures = 'Mostrar figuras:';
strings.es.surfaceGM = 'Superficie gM';
strings.es.cutsGM = 'Cortes gM con recta de reparto';
strings.es.binaries = 'Binarios';
strings.es.binodalCurve = 'Curva Binodal';
strings.es.status = 'Estado:';
strings.es.close = 'Cerrar';
strings.es.language = 'Idioma:';
strings.es.ready = 'Listo.';
strings.es.noFiles = '(sin archivos)';
strings.es.noSheets = '(sin hojas)';
strings.es.noExcelFound = 'No se encontraron archivos Excel en: %s';
strings.es.detectedExcel = 'Detectados %d archivos Excel.';
strings.es.fileNoSheets = 'El archivo no tiene hojas disponibles: %s';
strings.es.file = 'Archivo: %s';
strings.es.detectedSheets = 'Hojas detectadas: %d';
strings.es.errorReadingSheets = 'Error leyendo hojas de %s';
strings.es.selectValidFile = 'Selecciona un archivo y una hoja validos.';
strings.es.missingData = 'Faltan datos';
strings.es.functionNotFound = 'No se encuentra la funcion LLE_consistency_NRTL en el path.';
strings.es.running = 'Ejecutando...';
strings.es.executionError = 'Error de ejecucion';
strings.es.done = 'Hecho.';
strings.es.figuresGenerated = 'Figuras: Superficie: %d | Cortes: %d | Binarios: %d | Binodal: %d';
strings.es.exported = 'Exportado en: %s';
strings.es.noSurfaceFigures = 'No se encontraron figuras de superficie gM.';
strings.es.noCutsFigures = 'No se encontraron figuras de cortes gM con recta de reparto.';
strings.es.noBinaryFigures = 'No se encontraron figuras de binarios.';
strings.es.noBinodalFigures = 'No se encontraron figuras de curva binodal.';
strings.es.warning = 'Aviso';

    function txt = tr(key)
        % Get translated string for current language
        txt = strings.(currentLang).(key);
    end

% -------------------- UI --------------------
fig = uifigure('Name', tr('windowTitle'), ...
               'Position', [100 100 950 520]);

gl = uigridlayout(fig, [10 4]);
gl.RowHeight = {28, 28, 28, 28, 28, 28, 36, 36, '1x', 40};
gl.ColumnWidth = {140, '1x', '1x', '1x'};
gl.Padding = [12 12 12 12];
gl.RowSpacing = 8;
gl.ColumnSpacing = 8;

% Row 1: Language selector
lblLang = uilabel(gl, 'Text', tr('language'), 'HorizontalAlignment', 'right');
lblLang.Layout.Row = 1;
lblLang.Layout.Column = 1;
ddLang = uidropdown(gl, 'Items', {'English', 'Español'}, 'Value', 'Español');
ddLang.Layout.Row = 1;
ddLang.Layout.Column = 2;

% Row 2: Folder
lblFolder = uilabel(gl, 'Text', tr('folder'), 'HorizontalAlignment', 'right');
lblFolder.Layout.Row = 2;
etFolder = uieditfield(gl, 'text', 'Value', baseFolder, 'Editable', 'off');
etFolder.Layout.Row = 2;
etFolder.Layout.Column = [2 3];
btnFolder = uibutton(gl, 'push', 'Text', tr('changeFolder'));
btnFolder.Layout.Row = 2;
btnFolder.Layout.Column = 4;

% Row 3: Excel
lblExcel = uilabel(gl, 'Text', tr('excel'), 'HorizontalAlignment', 'right');
lblExcel.Layout.Row = 3;
ddExcel = uidropdown(gl, 'Items', {tr('noFiles')});
ddExcel.Layout.Row = 3;
ddExcel.Layout.Column = [2 4];

% Row 4: Sheet
lblSheet = uilabel(gl, 'Text', tr('sheet'), 'HorizontalAlignment', 'right');
lblSheet.Layout.Row = 4;
ddSheet = uidropdown(gl, 'Items', {tr('noSheets')});
ddSheet.Layout.Row = 4;
ddSheet.Layout.Column = [2 4];

% Row 5: Export with checkbox and configure button
lblExport = uilabel(gl, 'Text', tr('export'), 'HorizontalAlignment', 'right');
lblExport.Layout.Row = 5;
lblExport.Layout.Column = 1;
cbExport = uicheckbox(gl, 'Text', tr('enableExport'), 'Value', false);
cbExport.Layout.Row = 5;
cbExport.Layout.Column = 2;
btnExportConfig = uibutton(gl, 'push', 'Text', tr('configExport'), 'Enable', 'off');
btnExportConfig.Layout.Row = 5;
btnExportConfig.Layout.Column = 3;

% Row 6: Refresh/Run buttons
btnRefresh = uibutton(gl, 'push', 'Text', tr('refreshLists'));
btnRefresh.Layout.Row = 6;
btnRefresh.Layout.Column = 3;
btnRun = uibutton(gl, 'push', 'Text', tr('runFunction'), 'FontWeight', 'bold');
btnRun.Layout.Row = 6;
btnRun.Layout.Column = 4;

% Row 7: Figure buttons (first row)
lblFiguras = uilabel(gl, 'Text', tr('showFigures'), 'HorizontalAlignment', 'right');
lblFiguras.Layout.Row = 7;
lblFiguras.Layout.Column = 1;
btnSurf = uibutton(gl, 'push', 'Text', tr('surfaceGM'), 'Enable', 'off');
btnSurf.Layout.Row = 7;
btnSurf.Layout.Column = 2;
btnCuts = uibutton(gl, 'push', 'Text', tr('cutsGM'), 'Enable', 'off');
btnCuts.Layout.Row = 7;
btnCuts.Layout.Column = 3;
btnBin = uibutton(gl, 'push', 'Text', tr('binaries'), 'Enable', 'off');
btnBin.Layout.Row = 7;
btnBin.Layout.Column = 4;

% Row 8: Figure buttons (second row)
lblFiguras2 = uilabel(gl, 'Text', '', 'HorizontalAlignment', 'right');
lblFiguras2.Layout.Row = 8;
lblFiguras2.Layout.Column = 1;
btnBinodal = uibutton(gl, 'push', 'Text', tr('binodalCurve'), 'Enable', 'off');
btnBinodal.Layout.Row = 8;
btnBinodal.Layout.Column = 2;

% Row 9: Status
lblStatus = uilabel(gl, 'Text', tr('status'), 'HorizontalAlignment', 'right');
lblStatus.Layout.Row = 9;
taStatus = uitextarea(gl, 'Editable', 'off');
taStatus.Layout.Column = [2 4];
taStatus.Layout.Row = 9;
taStatus.Value = {tr('ready')};

% Row 10: Close button
btnClose = uibutton(gl, 'push', 'Text', tr('close'), ...
    'ButtonPushedFcn', @(~,~) close(fig));
btnClose.Layout.Row = 10;
btnClose.Layout.Column = 4;

% Configuración de exportación (valores por defecto)
exportConfig = struct();
exportConfig.doPDF = true;
exportConfig.doSVG = false;
exportConfig.doPNG = false;
exportConfig.sizes = struct();
exportConfig.sizes.tfm_superficie = [15 12];
exportConfig.sizes.tfm_cortes = [15 12];
exportConfig.sizes.tfm_binarios = [15 12];
exportConfig.sizes.tfm_binodal = [15 12];

% Figuras creadas en la ultima ejecucion
lastRunFigures = gobjects(0);

% -------------------- Callbacks --------------------
btnFolder.ButtonPushedFcn = @onChangeFolder;
btnRefresh.ButtonPushedFcn = @onRefresh;
ddExcel.ValueChangedFcn = @onExcelChanged;
btnRun.ButtonPushedFcn = @onRun;
btnSurf.ButtonPushedFcn = @(~,~) showFigureByTag('tfm_superficie', tr('surfaceGM'));
btnCuts.ButtonPushedFcn = @(~,~) showCutsFigures();
btnBin.ButtonPushedFcn = @(~,~) showFigureByTag('tfm_binarios', tr('binaries'));
btnBinodal.ButtonPushedFcn = @(~,~) showBinodalFigures();
cbExport.ValueChangedFcn = @onExportCheckChanged;
btnExportConfig.ButtonPushedFcn = @onOpenExportConfig;
ddLang.ValueChangedFcn = @onLanguageChanged;

refreshExcelList();

    function onLanguageChanged(~, ~)
        if strcmp(ddLang.Value, 'English')
            currentLang = 'en';
        else
            currentLang = 'es';
        end
        updateUILanguage();
    end

    function updateUILanguage()
        % Update all UI elements with current language
        fig.Name = tr('windowTitle');
        lblLang.Text = tr('language');
        lblFolder.Text = tr('folder');
        btnFolder.Text = tr('changeFolder');
        lblExcel.Text = tr('excel');
        lblSheet.Text = tr('sheet');
        lblExport.Text = tr('export');
        cbExport.Text = tr('enableExport');
        btnExportConfig.Text = tr('configExport');
        btnRefresh.Text = tr('refreshLists');
        btnRun.Text = tr('runFunction');
        lblFiguras.Text = tr('showFigures');
        btnSurf.Text = tr('surfaceGM');
        btnCuts.Text = tr('cutsGM');
        btnBin.Text = tr('binaries');
        btnBinodal.Text = tr('binodalCurve');
        lblStatus.Text = tr('status');
        btnClose.Text = tr('close');
        
        % Update dropdown placeholders if needed
        if strcmp(ddExcel.Enable, 'off')
            ddExcel.Items = {tr('noFiles')};
            ddExcel.Value = tr('noFiles');
        end
        if strcmp(ddSheet.Enable, 'off')
            ddSheet.Items = {tr('noSheets')};
            ddSheet.Value = tr('noSheets');
        end
    end

    function onExportCheckChanged(~, ~)
        if cbExport.Value
            btnExportConfig.Enable = 'on';
        else
            btnExportConfig.Enable = 'off';
        end
    end

    function onOpenExportConfig(~, ~)
        exportConfig = openExportConfigDialog(exportConfig, fig);
    end

    function onChangeFolder(~, ~)
        newFolder = uigetdir(baseFolder, 'Selecciona la carpeta con los Excels');
        if isequal(newFolder, 0)
            return;
        end
        baseFolder = newFolder;
        etFolder.Value = baseFolder;
        refreshExcelList();
    end

    function onRefresh(~, ~)
        refreshExcelList();
    end

    function refreshExcelList()
        excelFiles = listExcelFiles(baseFolder);

        if isempty(excelFiles)
            ddExcel.Items = {tr('noFiles')};
            ddExcel.Value = tr('noFiles');
            ddExcel.Enable = 'off';

            ddSheet.Items = {tr('noSheets')};
            ddSheet.Value = tr('noSheets');
            ddSheet.Enable = 'off';

            btnRun.Enable = 'off';
            disableFigureButtons();
            setStatus({sprintf(tr('noExcelFound'), baseFolder)});
            return;
        end

        ddExcel.Enable = 'on';
        ddExcel.Items = excelFiles;
        ddExcel.Value = excelFiles{1};
        btnRun.Enable = 'on';
        disableFigureButtons();

        updateSheetList();
        setStatus({sprintf(tr('detectedExcel'), numel(excelFiles))});
    end

    function onExcelChanged(~, ~)
        updateSheetList();
    end

    function updateSheetList()
        if strcmp(ddExcel.Enable, 'off')
            return;
        end

        excelPath = fullfile(baseFolder, ddExcel.Value);
        try
            sheets = getSheetNames(excelPath);
            if isempty(sheets)
                ddSheet.Items = {tr('noSheets')};
                ddSheet.Value = tr('noSheets');
                ddSheet.Enable = 'off';
                btnRun.Enable = 'off';
                disableFigureButtons();
                setStatus({sprintf(tr('fileNoSheets'), ddExcel.Value)});
                return;
            end

            ddSheet.Enable = 'on';
            ddSheet.Items = sheets;
            ddSheet.Value = sheets{1};
            btnRun.Enable = 'on';
            disableFigureButtons();
            setStatus({sprintf(tr('file'), ddExcel.Value), ...
                       sprintf(tr('detectedSheets'), numel(sheets))});
        catch ME
            ddSheet.Items = {tr('noSheets')};
            ddSheet.Value = tr('noSheets');
            ddSheet.Enable = 'off';
            btnRun.Enable = 'off';
            disableFigureButtons();
            setStatus({sprintf(tr('errorReadingSheets'), ddExcel.Value), ME.message});
        end
    end

    function onRun(~, ~)
        if strcmp(ddExcel.Enable, 'off') || strcmp(ddSheet.Enable, 'off')
            uialert(fig, tr('selectValidFile'), tr('missingData'));
            return;
        end

        if exist('LLE_consistency_NRTL', 'file') ~= 2
            uialert(fig, tr('functionNotFound'), tr('warning'));
            return;
        end

        excelPath = fullfile(baseFolder, ddExcel.Value);
        dataname = ddSheet.Value;
        
        % Opciones de exportación desde la configuración
        doExport = logical(cbExport.Value);
        doExportPDF = doExport && exportConfig.doPDF;
        doExportSVG = doExport && exportConfig.doSVG;
        doExportPNG = doExport && exportConfig.doPNG;
        exportSizes = exportConfig.sizes;

        % Evita acumular figuras de ejecuciones previas (causa duplicados al mostrar por Tag).
        closeTaggedFigures();
        lastRunFigures = gobjects(0);
        disableFigureButtons();

        figsBefore = findall(0, 'Type', 'figure');

        oldDefaultVis = get(groot, 'defaultFigureVisible');
        set(groot, 'defaultFigureVisible', 'off');
        cleanupObj = onCleanup(@() set(groot, 'defaultFigureVisible', oldDefaultVis)); %#ok<NASGU>

        exportInfo = '';
        if doExportPDF || doExportSVG || doExportPNG
            formats = {};
            if doExportPDF, formats{end+1} = 'PDF'; end
            if doExportSVG, formats{end+1} = 'SVG'; end
            if doExportPNG, formats{end+1} = 'PNG'; end
            exportInfo = sprintf('Export: %s', strjoin(formats, ', '));
        else
            exportInfo = '';
        end

        setStatus({tr('running'), ...
                   sprintf('%s: %s', tr('file'), ddExcel.Value), ...
                   sprintf('%s: %s', tr('sheet'), dataname)});
        drawnow;

        try
            % Ejecutar sin exportación interna (la haremos nosotros)
            [gamma_fase1, gamma_fase2, ~, ~, ~] = LLE_consistency_NRTL(excelPath, dataname, false); %#ok<ASGLU>

            figsAfter = findall(0, 'Type', 'figure');
            lastRunFigures = setdiff(figsAfter, figsBefore);
            lastRunFigures = lastRunFigures(:);
            
            % Configurar figuras: ocultar al cerrar + ventanas independientes + tamaño
            figSize = [650 500]; % Ancho x Alto en píxeles
            for ii = 1:numel(lastRunFigures)
                if isgraphics(lastRunFigures(ii))
                    set(lastRunFigures(ii), 'CloseRequestFcn', @(src,~) set(src, 'Visible', 'off'));
                    set(lastRunFigures(ii), 'WindowStyle', 'normal');
                    % Obtener posición actual y ajustar tamaño manteniendo esquina superior izquierda
                    pos = get(lastRunFigures(ii), 'Position');
                    set(lastRunFigures(ii), 'Position', [pos(1) pos(2) figSize(1) figSize(2)]);
                end
            end
            
            % Exportar figuras si se seleccionó algún formato
            if doExportPDF || doExportSVG || doExportPNG
                exportFigures(lastRunFigures, dataname, doExportPDF, doExportSVG, doExportPNG, exportSizes);
            end

            updateFigureButtons();

            setStatus({tr('done'), ...
                       sprintf(tr('figuresGenerated'), ...
                               countFiguresByTag('tfm_superficie'), ...
                               countFiguresByTag('tfm_cortes'), ...
                               countFiguresByTag('tfm_binarios'), ...
                               countFiguresByTag('tfm_binodal'))});

            uialert(fig, tr('done'), 'OK', 'Icon', 'success');
        catch ME
            disableFigureButtons();
            setStatus({tr('executionError'), ME.message});
            uialert(fig, sprintf('%s:\n%s', tr('executionError'), ME.message), 'Error', 'Icon', 'error');
        end
    end

    function showFigureByTag(tag, titleTxt)
        hGroup = getFiguresByTag(tag);
        if isempty(hGroup)
            if strcmp(tag, 'tfm_superficie')
                uialert(fig, tr('noSurfaceFigures'), tr('warning'));
            elseif strcmp(tag, 'tfm_binarios')
                uialert(fig, tr('noBinaryFigures'), tr('warning'));
            else
                uialert(fig, sprintf('No figures for "%s".', titleTxt), tr('warning'));
            end
            return;
        end

        for k = 1:numel(hGroup)
            h = hGroup(k);
            if isgraphics(h)
                set(h, 'WindowStyle', 'normal');
                set(h, 'Visible', 'on');
                figure(h);
                drawnow;
            end
        end
    end

    function showBinodalFigures()
        hGroup = getBinodalFigures();
        if isempty(hGroup)
            uialert(fig, tr('noBinodalFigures'), tr('warning'));
            return;
        end

        for k = 1:numel(hGroup)
            h = hGroup(k);
            if isgraphics(h)
                set(h, 'WindowStyle', 'normal');
                set(h, 'Visible', 'on');
                figure(h);
                drawnow;
            end
        end
    end

    function showCutsFigures()
        hGroup = getCutFigures();
        if isempty(hGroup)
            uialert(fig, tr('noCutsFigures'), tr('warning'));
            return;
        end

        for k = 1:numel(hGroup)
            h = hGroup(k);
            if isgraphics(h)
                set(h, 'WindowStyle', 'normal');
                set(h, 'Visible', 'on');
                figure(h);
                drawnow;
            end
        end
    end

    function h = getFiguresByTag(tag)
        % Buscar directamente usando findall para evitar problemas
        h = findall(0, 'Type', 'figure', 'Tag', tag);
        h = h(:);
    end

    function h = getBinodalFigures()
        % Buscar por tag 'tfm_binodal'
        h = getFiguresByTag('tfm_binodal');
    end

    function h = getCutFigures()
        % Buscar por tag 'tfm_cortes'
        h = getFiguresByTag('tfm_cortes');
    end

    function closeTaggedFigures()
        tags = {'tfm_superficie', 'tfm_cortes', 'tfm_binarios', 'tfm_binodal'};
        for ii = 1:numel(tags)
            hh = getFiguresByTag(tags{ii});
            if ~isempty(hh)
                delete(hh(isgraphics(hh)));
            end
        end
        lastRunFigures = gobjects(0);
    end

    function n = countFiguresByTag(tag)
        n = numel(getFiguresByTag(tag));
    end

    function disableFigureButtons()
        btnSurf.Enable = 'off';
        btnCuts.Enable = 'off';
        btnBin.Enable = 'off';
        btnBinodal.Enable = 'off';
    end

    function updateFigureButtons()
        try
            nSurf = countFiguresByTag('tfm_superficie');
            nCuts = countFiguresByTag('tfm_cortes');
            nBin = countFiguresByTag('tfm_binarios');
            nBinodal = countFiguresByTag('tfm_binodal');
            
            if nSurf > 0
                btnSurf.Enable = 'on';
            else
                btnSurf.Enable = 'off';
            end
            
            if nCuts > 0
                btnCuts.Enable = 'on';
            else
                btnCuts.Enable = 'off';
            end
            
            if nBin > 0
                btnBin.Enable = 'on';
            else
                btnBin.Enable = 'off';
            end
            
            if nBinodal > 0
                btnBinodal.Enable = 'on';
            else
                btnBinodal.Enable = 'off';
            end
        catch ME
            warning('Error en updateFigureButtons: %s', ME.message);
            disableFigureButtons();
        end
    end

    function out = ternary(cond, a, b)
        if cond
            out = a;
        else
            out = b;
        end
    end

    function setStatus(lines)
        if ischar(lines)
            lines = {lines};
        end
        taStatus.Value = lines;
    end

    function exportFigures(figList, dataname, doPDF, doSVG, doPNG, exportSizes)
        % Exporta las figuras en los formatos seleccionados con tamaños individuales
        exportFolder = 'export';
        if ~exist(exportFolder, 'dir')
            mkdir(exportFolder);
        end
        
        % Crear subcarpetas para cada formato
        if doPDF && ~exist(fullfile(exportFolder, 'pdf'), 'dir')
            mkdir(fullfile(exportFolder, 'pdf'));
        end
        if doSVG && ~exist(fullfile(exportFolder, 'svg'), 'dir')
            mkdir(fullfile(exportFolder, 'svg'));
        end
        if doPNG && ~exist(fullfile(exportFolder, 'png'), 'dir')
            mkdir(fullfile(exportFolder, 'png'));
        end
        
        % Tamaño por defecto si el tag no está en exportSizes
        defaultSize = [15 12];
        
        for ii = 1:numel(figList)
            f = figList(ii);
            if ~isgraphics(f)
                continue;
            end
            
            % Generar nombre base del archivo
            tag = get(f, 'Tag');
            if isempty(tag)
                tag = sprintf('figura_%d', ii);
            end
            
            % Obtener tamaño específico para este tipo de figura
            if isfield(exportSizes, tag)
                widthCm = exportSizes.(tag)(1);
                heightCm = exportSizes.(tag)(2);
            else
                widthCm = defaultSize(1);
                heightCm = defaultSize(2);
            end
            
            % Añadir número si hay múltiples figuras con el mismo tag
            sameTags = getFiguresByTag(tag);
            if numel(sameTags) > 1
                idx = find(sameTags == f, 1);
                baseName = sprintf('%s_%s_%d', dataname, tag, idx);
            else
                baseName = sprintf('%s_%s', dataname, tag);
            end
            
            % Configurar tamaño de la figura para exportación
            set(f, 'Units', 'centimeters');
            set(f, 'PaperUnits', 'centimeters');
            set(f, 'PaperSize', [widthCm heightCm]);
            set(f, 'PaperPosition', [0 0 widthCm heightCm]);
            
            % Exportar PDF (vectorizado)
            if doPDF
                pdfPath = fullfile(exportFolder, 'pdf', [baseName '.pdf']);
                exportgraphics(f, pdfPath, 'ContentType', 'vector');
            end
            
            % Exportar SVG (vectorizado)
            if doSVG
                svgPath = fullfile(exportFolder, 'svg', [baseName '.svg']);
                saveas(f, svgPath, 'svg');
            end
            
            % Exportar PNG (300 DPI)
            if doPNG
                pngPath = fullfile(exportFolder, 'png', [baseName '.png']);
                exportgraphics(f, pngPath, 'Resolution', 300);
            end
            
            % Restaurar unidades a píxeles
            set(f, 'Units', 'pixels');
        end
    end
end

function files = listExcelFiles(folderPath)
% Devuelve lista de archivos Excel para poblar el desplegable.
patterns = {'*.xlsx', '*.xlsm', '*.xls', '*.xlsb'};
allNames = {};
for p = 1:numel(patterns)
    d = dir(fullfile(folderPath, patterns{p}));
    if ~isempty(d)
        allNames = [allNames, {d.name}]; %#ok<AGROW>
    end
end
allNames = unique(allNames);
files = sort(allNames);
end

function sheets = getSheetNames(excelPath)
% Compatible con versiones nuevas y antiguas de MATLAB.
if exist('sheetnames', 'file') == 2
    s = sheetnames(excelPath);
    sheets = cellstr(s);
else
    [~, sheets] = xlsfinfo(excelPath);
end

if isempty(sheets)
    sheets = {};
end
end

function newConfig = openExportConfigDialog(currentConfig, parentFig)
% Abre un diálogo modal para configurar las opciones de exportación

newConfig = currentConfig;

% Crear ventana de configuración
dlg = uifigure('Name', 'Configuracion de Exportacion', ...
               'Position', [150 150 500 400], ...
               'WindowStyle', 'modal');

% Centrar respecto a la ventana principal
if nargin >= 2 && isgraphics(parentFig)
    parentPos = parentFig.Position;
    dlgPos = dlg.Position;
    dlg.Position(1) = parentPos(1) + (parentPos(3) - dlgPos(3)) / 2;
    dlg.Position(2) = parentPos(2) + (parentPos(4) - dlgPos(4)) / 2;
end

gl = uigridlayout(dlg, [10 4]);
gl.RowHeight = {28, 28, 28, 28, 28, 28, 28, 28, '1x', 40};
gl.ColumnWidth = {140, '1x', '1x', '1x'};
gl.Padding = [12 12 12 12];
gl.RowSpacing = 8;
gl.ColumnSpacing = 8;

% Fila 1: Título formatos
lblFormatos = uilabel(gl, 'Text', 'Formatos de exportacion:', 'FontWeight', 'bold');
lblFormatos.Layout.Row = 1;
lblFormatos.Layout.Column = [1 4];

% Fila 2: Checkboxes de formatos
cbPDF = uicheckbox(gl, 'Text', 'PDF (vectorizado)', 'Value', currentConfig.doPDF);
cbPDF.Layout.Row = 2;
cbPDF.Layout.Column = 1;
cbSVG = uicheckbox(gl, 'Text', 'SVG (vectorizado)', 'Value', currentConfig.doSVG);
cbSVG.Layout.Row = 2;
cbSVG.Layout.Column = 2;
cbPNG = uicheckbox(gl, 'Text', 'PNG (300 DPI)', 'Value', currentConfig.doPNG);
cbPNG.Layout.Row = 2;
cbPNG.Layout.Column = 3;

% Fila 3: Título tamaños
lblTamanos = uilabel(gl, 'Text', 'Tamanos de exportacion (cm):', 'FontWeight', 'bold');
lblTamanos.Layout.Row = 3;
lblTamanos.Layout.Column = [1 2];
lblAncho = uilabel(gl, 'Text', 'Ancho', 'HorizontalAlignment', 'center');
lblAncho.Layout.Row = 3;
lblAncho.Layout.Column = 3;
lblAlto = uilabel(gl, 'Text', 'Alto', 'HorizontalAlignment', 'center');
lblAlto.Layout.Row = 3;
lblAlto.Layout.Column = 4;

% Fila 4: Superficie
uilabel(gl, 'Text', 'Superficie gM:', 'HorizontalAlignment', 'right');
etWidthSurf = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_superficie(1), 'Limits', [5 50]);
etWidthSurf.Layout.Row = 4;
etWidthSurf.Layout.Column = 3;
etHeightSurf = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_superficie(2), 'Limits', [5 50]);
etHeightSurf.Layout.Row = 4;
etHeightSurf.Layout.Column = 4;

% Fila 5: Cortes
uilabel(gl, 'Text', 'Cortes gM:', 'HorizontalAlignment', 'right');
etWidthCuts = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_cortes(1), 'Limits', [5 50]);
etWidthCuts.Layout.Row = 5;
etWidthCuts.Layout.Column = 3;
etHeightCuts = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_cortes(2), 'Limits', [5 50]);
etHeightCuts.Layout.Row = 5;
etHeightCuts.Layout.Column = 4;

% Fila 6: Binarios
uilabel(gl, 'Text', 'Binarios:', 'HorizontalAlignment', 'right');
etWidthBin = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_binarios(1), 'Limits', [5 50]);
etWidthBin.Layout.Row = 6;
etWidthBin.Layout.Column = 3;
etHeightBin = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_binarios(2), 'Limits', [5 50]);
etHeightBin.Layout.Row = 6;
etHeightBin.Layout.Column = 4;

% Fila 7: Binodal
uilabel(gl, 'Text', 'Curva Binodal:', 'HorizontalAlignment', 'right');
etWidthBinodal = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_binodal(1), 'Limits', [5 50]);
etWidthBinodal.Layout.Row = 7;
etWidthBinodal.Layout.Column = 3;
etHeightBinodal = uieditfield(gl, 'numeric', 'Value', currentConfig.sizes.tfm_binodal(2), 'Limits', [5 50]);
etHeightBinodal.Layout.Row = 7;
etHeightBinodal.Layout.Column = 4;

% Fila 8: Info
lblInfo = uilabel(gl, 'Text', 'Los archivos se guardaran en la carpeta "export/" con subcarpetas por formato.', ...
    'FontAngle', 'italic');
lblInfo.Layout.Row = 8;
lblInfo.Layout.Column = [1 4];

% Fila 10: Botones
btnCancelar = uibutton(gl, 'push', 'Text', 'Cancelar');
btnCancelar.Layout.Row = 10;
btnCancelar.Layout.Column = 3;
btnAceptar = uibutton(gl, 'push', 'Text', 'Aceptar', 'FontWeight', 'bold');
btnAceptar.Layout.Row = 10;
btnAceptar.Layout.Column = 4;

% Variable para saber si se aceptó
accepted = false;

btnCancelar.ButtonPushedFcn = @(~,~) close(dlg);
btnAceptar.ButtonPushedFcn = @onAccept;

% Esperar a que se cierre el diálogo
uiwait(dlg);

    function onAccept(~, ~)
        % Guardar configuración
        newConfig.doPDF = cbPDF.Value;
        newConfig.doSVG = cbSVG.Value;
        newConfig.doPNG = cbPNG.Value;
        newConfig.sizes.tfm_superficie = [etWidthSurf.Value, etHeightSurf.Value];
        newConfig.sizes.tfm_cortes = [etWidthCuts.Value, etHeightCuts.Value];
        newConfig.sizes.tfm_binarios = [etWidthBin.Value, etHeightBin.Value];
        newConfig.sizes.tfm_binodal = [etWidthBinodal.Value, etHeightBinodal.Value];
        accepted = true;
        close(dlg);
    end
end
