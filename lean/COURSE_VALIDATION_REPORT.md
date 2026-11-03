# Informe de la corrida del curso


Las cinco proposiciones tienen enunciados transparentes en [PaperInterface.lean](PaperInterface.lean) y pruebas del tipo exacto en [ProofInterface.lean](ProofInterface.lean). Los nombres completos llevan el prefijo `Olano26Transparencia.`.

| Resultado | Declaración / implementación | Estado | Alcance |
|---|---|---|---|
| 1: información | `informationDecomposition` / `Information.lean` | **Probado** | Leyes gaussianas, independencia, posterior, esperanza y varianza condicional sobre kappa; extremos sin señal y señal exacta. |
| 2: demanda CARA | `optimalDemandResult` / `CARA.lean` | **Probado** | Integral real de utilidad CARA bajo creencia normal y máximo global único en (m−RP)/(gv). |
| 3: precio | `priceSensitivity` / `Price.lean` | **Probado** | Precio único que vacía el mercado; integración del ruido público dado theta y extremo sin señal. |
| 4: transparencia fija | `fixedSentimentMonotonicity` / `Sensitivity.lean` | **Probado** | Crecimiento estricto en [0,1], positividad, cota 1/R y extremo de información completa. |
| 5: sentimiento variable | `endogenousSentiment` / `Endogenous.lean` | **Probado** | Derivada lateral, condiciones de signos, criterio equivalente, trayectoria logarítmica, umbral 101/36 y reversión exacta con c=5. |

No se incorporaron hipótesis económicas adicionales. Los supuestos del manuscrito se codifican en el modelo; las cinco clausuras de axiomas solo contienen `propext`, `Classical.choice` y `Quot.sound`, sin `sorryAx` ni axiomas propios.

## Fuente y comprobaciones reales

- Manuscrito formalizado: commit [`55409d5`](https://github.com/davidolano03/ai-project/blob/55409d500deba8b66072bd75d042d1faa962cdad/paper/paper.pdf); los hashes completos están en [verification/provenance.json](verification/provenance.json).
- Biblioteca base: AppliedModelingLib `194edcc95df74806a39b961d10dedddc6e730cce`; Lean `4.30.0-rc2`; Mathlib `5450b53e5ddc75d46418fabb605edbf36bd0beb6`.
- Modelo usado en la formalización y revisión: `gpt-5.6-sol`, esfuerzo `xhigh`.
- Comando del curso: `python3 scripts/paper_contribution.py check Olano26Transparencia --fast`: **código de salida 0**. [Salida completa](verification/course-check.txt) y [código](verification/course-check-exit.txt).
- [Enunciados y axiomas emitidos por Lean](verification/direct-lean-displays.txt): código 0, cinco pruebas del tipo de sus respectivos Specs.
- [Comparación independiente directa](verification/direct-source-review.md): **5 MATCH**, sin cambios matemáticos requeridos. Revisor sin contexto de autoría; comparó la fuente fijada, el modelo y los enunciados emitidos por Lean.

El chequeo `--fast` comprueba compilación focalizada, aislamiento de importaciones y formato. La compilación de las cinco pruebas y la comparación de enunciados se registran por separado. Esta comparación directa se realizó por petición del estudiante para cerrar la entrega; **no equivale a un recibo de aceptación del protocolo integral v12 de AppliedModelingLib**. No se afirma que ese recibo haya sido emitido. Los JSON de `audit/` conservan el estado del procedimiento automatizado, que no llegó a emitirlo por el fallo de detección de fuentes del preflight en Windows. Esto es distinto de una proposición abierta o una prueba asumida.

## Reproducir

Seguir [support/README.md](support/README.md): copiar esta carpeta a `papers/Olano26Transparencia` en la biblioteca fijada, copiar el módulo raíz y añadir el target de Lake; aplicar el parche incluido de tres wrappers gaussianos. Después:

```sh
lake build +Olano26Transparencia
python3 scripts/paper_contribution.py check Olano26Transparencia --fast
```

La reproducción requiere las dependencias indicadas por `lake-manifest.json` de esa revisión. En Windows, la ejecución registrada utilizó un adaptador de funciones POSIX para Python; no se alteraron los validadores semánticos. Se incluye en `support/windows-compat/`. Las rutas de fuente descargada permanecen excluidas por `.gitignore`; se recuperan desde el commit fijado, sin `git add -f`.

La carpeta `preliminary/` conserva las 26 declaraciones algebraicas anteriores como historial. Las cinco pruebas actuales están en la raíz de `lean/`; las pruebas anteriores no se presentan como sustituto de los resultados probabilísticos actuales.

El documento y las diapositivas solo cambian el estado de las pruebas y su explicación. Las cinco proposiciones matemáticas siguen siendo las del commit formalizado. Una modificación posterior de sus enunciados exige repetir la comprobación y revisión correspondientes.
