# LLE Consistency - NRTL

## English

### Description

This MATLAB tool generates figures to verify the **thermodynamic consistency** of correlation results for **ternary Liquid-Liquid Equilibrium (LLE) systems** using the **NRTL model**.

The tool reads experimental and calculated equilibrium data from an Excel template and produces visualizations that help assess the quality and consistency of NRTL parameter correlations.

### Related Work and Acknowledgements

This software was independently developed from scratch by Miguel Gomez Rubio as part of his Master's Thesis. No source code from `GMcal_TieLinesLL` has been copied, modified or incorporated into this repository.

The scientific motivation and some of the thermodynamic consistency analyses implemented in this project were informed by the work of the University of Alicante research group responsible for the `GMcal_TieLinesLL` graphical user interface. `GMcal_TieLinesLL` was also used as a scientific reference tool during the academic work.

The software in this repository is an independent implementation with its own source code and workflow. The references to `GMcal_TieLinesLL`, its authors and the University of Alicante do not imply endorsement of this repository or its software.

### References

1. Marcilla et al. “Should we trust all the published LLE correlation parameters in phase equilibria? Necessity of their Assessment Prior to Publication.” *Fluid Phase Equilibria*, 433, 243–252, 2017. DOI: [10.1016/j.fluid.2016.11.009](https://doi.org/10.1016/j.fluid.2016.11.009).

2. Marcilla et al. “Ensuring that Correlation Parameters for Liquid-Liquid Equilibrium Produce the Right Results.” *Journal of Chemical & Engineering Data*, 63(5), 1133–1134, 2018. DOI: [10.1021/acs.jced.8b00260](https://doi.org/10.1021/acs.jced.8b00260).

3. Labarta et al. `GMcal_TieLinesLL`: Graphical User Interface (GUI) for the Topological Analysis of Calculated GM Surfaces and Curves, including Tie-Lines, Hessian Matrix, Spinodal Curve, Plait Point Location and Miscibility Boundaries for Binary and Ternary Liquid-Liquid Equilibrium Data. University of Alicante Institutional Repository, RUA, 2015. [http://hdl.handle.net/10045/51725](http://hdl.handle.net/10045/51725).

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

### Trabajo relacionado y reconocimientos

Este software fue desarrollado de manera independiente y desde cero por Miguel Gomez Rubio como parte de su Trabajo Fin de Máster. No se ha copiado, modificado ni incorporado en este repositorio código fuente procedente de `GMcal_TieLinesLL`.

La motivación científica y algunos de los análisis de consistencia termodinámica implementados en este proyecto se apoyan en los trabajos del grupo de investigación de la Universidad de Alicante responsable de la interfaz gráfica `GMcal_TieLinesLL`. Esta herramienta también fue utilizada como referencia científica durante el desarrollo del trabajo académico.

El software incluido en este repositorio constituye una implementación independiente, con código fuente y flujo de trabajo propios. Las referencias a `GMcal_TieLinesLL`, a sus autores y a la Universidad de Alicante no implican que respalden oficialmente este repositorio o su software.

### Referencias

1. Marcilla et al. “Should we trust all the published LLE correlation parameters in phase equilibria? Necessity of their Assessment Prior to Publication.” *Fluid Phase Equilibria*, 433, 243–252, 2017. DOI: [10.1016/j.fluid.2016.11.009](https://doi.org/10.1016/j.fluid.2016.11.009).

2. Marcilla et al. “Ensuring that Correlation Parameters for Liquid-Liquid Equilibrium Produce the Right Results.” *Journal of Chemical & Engineering Data*, 63(5), 1133–1134, 2018. DOI: [10.1021/acs.jced.8b00260](https://doi.org/10.1021/acs.jced.8b00260).

3. Labarta et al. `GMcal_TieLinesLL`: interfaz gráfica para el análisis topológico de superficies y curvas calculadas de energía de Gibbs de mezcla, incluyendo rectas de reparto, matriz hessiana, curva espinodal, localización del punto crítico y fronteras de miscibilidad para sistemas de equilibrio líquido-líquido binarios y ternarios. Repositorio Institucional de la Universidad de Alicante, RUA, 2015. [http://hdl.handle.net/10045/51725](http://hdl.handle.net/10045/51725).

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

This software is licensed under the [PolyForm Strict License 1.0.0](LICENSE).

The license permits certain personal, educational, academic and noncommercial research uses, subject to its complete terms. Please read the `LICENSE` file before using, copying or modifying this software.

Este software se distribuye bajo la [PolyForm Strict License 1.0.0](LICENSE).

La licencia permite determinados usos personales, educativos, académicos y de investigación no comercial, sujetos a sus términos completos. Consulta el archivo `LICENSE` antes de utilizar, copiar o modificar este software.

## Author / Autor

Miguel Gomez Rubio. 2026.
