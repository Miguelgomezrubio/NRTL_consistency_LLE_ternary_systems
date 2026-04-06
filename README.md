# LLE Consistency - NRTL

## English

### Description

This MATLAB tool generates figures to verify the **thermodynamic consistency** of correlation results for **ternary Liquid-Liquid Equilibrium (LLE) systems** using the **NRTL model**.

The tool reads experimental and calculated equilibrium data from an Excel template and produces visualizations that help assess the quality and consistency of NRTL parameter correlations.

### Generated Figures

1. **gᴹ/RT Surface** - 3D surface plot of the Gibbs excess energy with tie lines
2. **gᴹ/RT Cuts** - Cross-sections of gᴹ/RT along tie lines
3. **Binary Systems** - gᴹ/RT plots for the three binary subsystems (1-2, 1-3, 2-3)
4. **Binodal Curve** - Calculated vs experimental equilibrium pairs

### Requirements

- MATLAB R2020a or later (requires App Designer components)
- No additional toolboxes required

### Usage

#### Option 1: Using the GUI

1. Run `LLE_consistency_gui` in MATLAB
2. Select the folder containing your Excel file
3. Choose the Excel file and sheet with your data
4. Click "Run function" to generate figures
5. Use the "Show figures" buttons to display each figure type
6. Optionally enable export to PDF/SVG/PNG

#### Option 2: Direct function call

```matlab
[gamma1, gamma2, a0, a1, alpha] = LLE_consistency_NRTL('template.xlsx', 'TEMPLATE', false);
```

### Excel Template Structure

Use `template.xlsx` as a starting point. Fill in the yellow cells:

| Data | Cell Location |
|------|---------------|
| Temperature (K) | C3 |
| **a0 parameters** (A12, A21, A13, A31, A23, A32) | B8:B13 |
| **a1 parameters** (A12, A21, A13, A31, A23, A32) | D8:D13 |
| **alpha parameters** (α12, α13, α23) | F8:F10 |
| **Phase 1 experimental** (x1, x2, x3) | B19:D118 |
| **Phase 1 calculated** (x1, x2, x3) | E19:G118 |
| **Phase 2 experimental** (x1, x2, x3) | I19:K118 |
| **Phase 2 calculated** (x1, x2, x3) | L19:N118 |

### Example

The `template.xlsx` file includes a complete example with sample data. Exported figures from this example are available in the `export/` folder.

### Export Options

The GUI allows exporting figures in three formats:
- **PDF** - Vector format, ideal for publications
- **SVG** - Vector format, ideal for web
- **PNG** - Raster format at 300 DPI

Individual size settings can be configured for each figure type.

---

## Español

### Descripción

Esta herramienta de MATLAB genera figuras para verificar la **consistencia termodinámica** de los resultados de correlaciones de **sistemas ternarios de Equilibrio Líquido-Líquido (ELL)** utilizando el **modelo NRTL**.

La herramienta lee datos de equilibrio experimentales y calculados desde una plantilla Excel y produce visualizaciones que ayudan a evaluar la calidad y consistencia de las correlaciones de parámetros NRTL.

### Figuras Generadas

1. **Superficie gᴹ/RT** - Gráfico 3D de la energía de Gibbs de exceso con rectas de reparto
2. **Cortes gᴹ/RT** - Secciones transversales de gᴹ/RT a lo largo de las rectas de reparto
3. **Sistemas Binarios** - Gráficos gᴹ/RT para los tres subsistemas binarios (1-2, 1-3, 2-3)
4. **Curva Binodal** - Pares de equilibrio calculados vs experimentales

### Requisitos

- MATLAB R2020a o posterior (requiere componentes de App Designer)
- No se requieren toolboxes adicionales

### Uso

#### Opción 1: Usando la interfaz gráfica (GUI)

1. Ejecuta `LLE_consistency_gui` en MATLAB
2. Selecciona la carpeta que contiene tu archivo Excel
3. Elige el archivo Excel y la hoja con tus datos
4. Haz clic en "Ejecutar función" para generar las figuras
5. Usa los botones de "Mostrar figuras" para visualizar cada tipo de figura
6. Opcionalmente activa la exportación a PDF/SVG/PNG

#### Opción 2: Llamada directa a la función

```matlab
[gamma1, gamma2, a0, a1, alpha] = LLE_consistency_NRTL('template.xlsx', 'TEMPLATE', false);
```

### Estructura de la Plantilla Excel

Usa `template.xlsx` como punto de partida. Rellena las celdas amarillas:

| Dato | Ubicación |
|------|-----------|
| Temperatura (K) | C3 |
| **Parámetros a0** (A12, A21, A13, A31, A23, A32) | B8:B13 |
| **Parámetros a1** (A12, A21, A13, A31, A23, A32) | D8:D13 |
| **Parámetros alfa** (α12, α13, α23) | F8:F10 |
| **Fase 1 experimental** (x1, x2, x3) | B19:D118 |
| **Fase 1 calculada** (x1, x2, x3) | E19:G118 |
| **Fase 2 experimental** (x1, x2, x3) | I19:K118 |
| **Fase 2 calculada** (x1, x2, x3) | L19:N118 |

### Ejemplo

El archivo `template.xlsx` incluye un ejemplo completo con datos de muestra. Las figuras exportadas de este ejemplo están disponibles en la carpeta `export/`.

### Opciones de Exportación

La GUI permite exportar figuras en tres formatos:
- **PDF** - Formato vectorial, ideal para publicaciones
- **SVG** - Formato vectorial, ideal para web
- **PNG** - Formato raster a 300 DPI

Se pueden configurar tamaños individuales para cada tipo de figura.

---

## License / Licencia

MIT License

## Author / Autor

Miguel Gomez Rubio. 2026.
