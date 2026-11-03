# Apéndice manuscrito

Fotografías reales aportadas por David Julio Olano Silva Nevado. Se conservan los archivos originales sin retocar la escritura ni los cálculos.

**[Leer el PDF ordenado de tres páginas](derivaciones-manuscritas.pdf).**

| Orden | Fotografía | Contenido |
|---|---|---|
| 1 | [Bayes: definición](01-bayes-definicion.jpg) | Señal, distribuciones, densidades, regla de Bayes y preparación del cuadrado. |
| 2 | [Bayes: desarrollo](02-bayes-desarrollo.jpg) | Completar el cuadrado, posterior normal, media y varianza. |
| 3 | [Varianzas](03-varianzas.jpg) | Interpretación de mu, kappa y xi; derivación de Var(kappa)=mu*s y Var(xi)=(1−mu)*s. |

El PDF agrupa las tres fotos en este orden. Las imágenes también se incluyen en el apéndice del paper y en las diapositivas de consulta A17–A19. [originales.json](originales.json) registra el orden y los hashes de los archivos aportados.

**Alcance recibido.** Están fotografiados Bayes, la posterior y las varianzas pública y residual. Para el apéndice manuscrito completo del paper final quedan la covarianza entre kappa y xi y sus consecuencias condicionales, los extremos informativos, las creencias de los grupos, CARA y CPO, el precio, la monotonicidad y la extensión de sentimiento con el umbral 101/36. No se presentan esas partes como manuscritas.

**Notas de lectura.** Al omitir factores constantes respecto de x, la relación entre densidades y exponentes es de proporcionalidad (símbolo ∝); las expresiones intermedias sin normalizar no son una aproximación numérica de la densidad. Las simplificaciones usan s,t>0 e independencia entre theta y eta, supuestos expresos del modelo. En particular, A*m²=s*y²/[t*(s+t)]. Estas aclaraciones tipografiadas no alteran las fotografías.

La [guía de estudio](derivaciones-guia.md) detalla las derivaciones restantes. La guía no sustituye las fotos del trabajo personal.

**Regenerar el PDF:** instalar reportlab y ejecutar python hand/build_appendix.py. El script incorpora las imágenes originales a páginas con títulos y numeración.
