# Apéndice manuscrito

Fotografías reales aportadas por David Julio Olano Silva Nevado. Se conservan los archivos originales sin retocar la escritura ni los cálculos.

**[Leer el PDF ordenado de seis páginas](derivaciones-manuscritas.pdf).**

| Orden | Fotografía | Contenido |
|---|---|---|
| 1 | [Bayes: definición](01-bayes-definicion.jpg) | Señal, distribuciones, densidades, regla de Bayes y preparación del cuadrado. |
| 2 | [Bayes: desarrollo](02-bayes-desarrollo.jpg) | Completar el cuadrado, posterior normal, media y varianza. |
| 3 | [Varianzas](03-varianzas.jpg) | Interpretación de mu, kappa y xi; derivación de Var(kappa)=mu*s y Var(xi)=(1−mu)*s. |
| 4 | [CARA: riqueza](04-cara-riqueza.jpg) | Utilidad, presupuesto, financiamiento y media y varianza de la riqueza. |
| 5 | [CARA: integral](05-cara-integral.jpg) | Esperanza exponencial, cuadrado completo y normalización de la densidad. |
| 6 | [CARA: CPO](06-cara-cpo.jpg) | Utilidad esperada, equivalente cierto, problema de maximización y demanda óptima. |

El PDF agrupa las seis fotos en este orden. Las imágenes también se incluyen en el apéndice del paper y en las diapositivas de consulta A17–A22. [originales.json](originales.json) registra el orden y los hashes de los archivos aportados.

**Alcance recibido.** Están fotografiados Bayes, la posterior, las varianzas pública y residual y la derivación CARA/CPO. Para completar las derivaciones del paper final quedan la covarianza entre kappa y xi y sus consecuencias condicionales, los extremos informativos, las creencias de los grupos, el índice de Arrow–Pratt y la condición de segundo orden, el precio, la monotonicidad y la extensión de sentimiento con el umbral 101/36. No se presentan esas partes como manuscritas.

**Notas de lectura de Bayes.** Al omitir factores constantes respecto de x, la relación entre densidades y exponentes es de proporcionalidad (símbolo ∝); las expresiones intermedias sin normalizar no son una aproximación numérica de la densidad. Las simplificaciones usan s,t>0 e independencia entre theta y eta, supuestos expresos del modelo. En particular, A*m²=s*y²/[t*(s+t)].

**Precisiones de notación en CARA (sin alterar las fotos).**

- En la foto 4, v se define como Var(F|I). Con la convención N(media,varianza) del proyecto, debe leerse F|I ~ N(m,v), aunque la primera línea manuscrita escribe v². En las fórmulas siguientes V=omega²*v, v sí representa la varianza.
- R es un factor bruto seguro (por ejemplo, 1,05), no la tasa neta. Se supone el mismo factor para ahorro y préstamo. La riqueza condicionada a I es normal, o degenerada cuando omega=0.
- En una línea intermedia de la foto 5 falta el signo negativo: con q=−g, E[U(W)|I]=−E[exp(qW)|I]. El cálculo auxiliar E[exp(qW)|I]=exp(qM+q²V/2) es correcto; la foto 6 recupera el signo negativo en la utilidad esperada.
- En la foto 6, al derivar CE el término de riesgo se resta: CE′=m−RP−g*omega*v. El resultado final manuscrito usa ese signo correctamente. La justificación de máximo es CE″=−g*v<0, con g,v>0; esta comprobación está en el paper y las diapositivas, pero aún no aparece en la foto.
- U(CE)=E[U(W)|I] define el equivalente cierto; que U sea creciente justifica que maximizar CE y maximizar utilidad esperada den la misma elección.

Estas aclaraciones tipografiadas acompañan el trabajo personal; no son correcciones manuscritas del estudiante.

La [guía de estudio](derivaciones-guia.md) detalla las derivaciones restantes. La guía no sustituye las fotos del trabajo personal.

**Regenerar el PDF:** instalar reportlab y ejecutar python hand/build_appendix.py. El script incorpora las imágenes originales a páginas con títulos y numeración.
