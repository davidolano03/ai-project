# Guion de exposición — 20 minutos

**Pregunta central:** ¿cuándo la transparencia aumenta la sensibilidad esperada del precio a los fundamentos en presencia de sentimiento? El aporte es corregir una especificación y probar un resultado condicionado. Mantener esa pregunta en la apertura, el resultado y el cierre.

Los tiempos suman 20 minutos. Las notas amplían la lectura de variables; no es necesario leer todas las fórmulas en voz alta.

1. **Portada — 0:30.** Identificar el tema, la ruta A y el repositorio. Presentar la pregunta como una comparación entre niveles de información.

2. **Pregunta — 1:30.** Sensibilidad significa cuánto cambia el precio ante una unidad adicional de noticia fundamental. No equivale a rentabilidad ni a precios altos. La misma mejora debería amplificar la respuesta positiva y la negativa. Motivar por qué el sentimiento puede distorsionar esa respuesta.

3. **Supuesto cambiado — 1:30.** θ es noticia económica; κ es información pública; μ está entre cero y uno. Si κ=μθ exactamente y μ es conocido y positivo, basta dividir para conocer θ. No hay información parcial real. Además, la varianza publicada crece con μ y no recupera el riesgo previo en μ=0. Identificar sección 6.2 y proposición 5(ii), sin hacer un resumen completo del artículo.

4. **Contraejemplo — 1:30.** Usar participaciones iguales y riesgos positivos. Las fórmulas publicadas producen 0.551866 frente a 0.642857 del modelo básico en μ=0.1. Un caso admisible basta para cuestionar una afirmación universal. Puede haber un error de especificación o tipográfico. Esto no demuestra que las divulgaciones reales dañen mercados. Lean comprueba las fracciones exactas.

5. **Nueva información — 2:00.** θ=κ+ξ: κ es la parte observada y ξ la que queda oculta. Ambos componentes son normales independientes y de media cero. μ divide la varianza total s, no multiplica una realización observable. Condicionado a κ, el mejor pronóstico de θ es κ; la incertidumbre restante es (1−μ)s. En μ=0 no se revela noticia; en μ=1 se revela toda θ. La sorpresa ε sigue existiendo.

6. **Cuatro grupos — 2:00.** Instituciones conocen θ; particulares conocen κ. Racionales y sentimentales comparten esa diferencia informativa. m es la media subjetiva del pago y v su varianza. γ es aversión de referencia. Los estados ρ modifican la aversión g₂ y g₄ mediante una exponencial; b determina su intensidad. δ=ρ* es sesgo esperado y τ² es incertidumbre subjetiva adicional: no son el mismo objeto que ρ. Los sesgos no se incorporan al flujo objetivo de la empresa. Conservar los cuatro grupos evita eliminar la interacción central del paper.

7. **Problema y FOC — 2:00.** ω es cantidad comprada; negativa permite venta corta. P es precio actual y R el factor bruto seguro. m−RP es rendimiento monetario esperado por unidad. El equivalente cierto suma riqueza independiente C₀, ganancia esperada y penalización gvω²/2. La FOC iguala ganancia marginal a coste marginal de riesgo. La segunda derivada −gv es negativa. Por tanto ω*=(m−RP)/(gv). Menor v amplía compras o ventas a valoración y precio dados; no basta para concluir que el precio de equilibrio sube.

8. **Equilibrio — 1:30.** λ es la participación de cada grupo y h=λ/(gv) su peso efectivo de demanda. La oferta normalizada es uno. Sustituir las cuatro demandas en el vaciado da P*=(Σhm−1)/(RH). El numerador pondera valoraciones y resta oferta; el denominador agrega tolerancia al riesgo y descuento. Un grupo más relevante eleva P sólo si m>RP; si su valoración es menor, lo reduce.

9. **Resultado — 2:00.** Promediar señales públicas compatibles con un mismo θ. La identidad gaussiana E[κ|θ]=μθ convierte el peso particular en respuesta esperada μB; a es peso institucional. K=(a+μB)/(R(a+B)). Los estados sentimentales son independientes de κ y ξ; por eso condicionar también en ellos conserva la identidad. No mantener κ fijo al variar θ: sería otra derivada. Bajo sentimiento exógeno y fijo, masas y riesgos fijos, aumentar μ fortalece K. En μ=1 queda 1/R. Aun ahí el precio puede conservar un sesgo o prima de riesgo: K sólo mide pendiente.

10. **Gráfico — 1:00.** Negro: modelo básico constante. Naranja: fórmulas impresas bajo los parámetros del contraejemplo. Azul: modelo corregido y respuesta esperada. Su punto inicial coincide con el básico y el final con 1/R=1. La naranja cruza la línea negra sólo después de ciertos niveles; contradice una mejora universal. Son cálculos del modelo, no datos financieros. Más transparencia reduce riesgo residual y permite que particulares reaccionen a la noticia.

11. **Revisión y contribución — 1:00.** Zhang ya incluye transparencia y aprendizaje. Lo nuevo será reparar su representación, volver a derivar el equilibrio y explicitar las condiciones. Se revisó el apéndice y un artículo citante empírico; se buscaron versiones y correcciones. La búsqueda está delimitada: no afirmar que nadie haya estudiado información parcial.

12. **Lean — 1:30.** Mostrar una declaración con hipótesis primitivas: a,n₃,n₄,e₃,e₄,R positivos y varianza informativa t no negativa. La conclusión no está escondida en un supuesto. n₃ y n₄ capturan masas divididas por aversión, e₃ y e₄ son riesgos residuales distintos; t=s. Lean verifica identidades y desigualdades, no el ajuste del modelo al mundo. La conexión de esperanzas gaussianas sigue pendiente. Distinguir estas pruebas preliminares del workflow final de AppliedModelingLib.

13. **Plan y riesgo — 1:30.** Derivar cuatro FOC y el resultado; simular heterogeneidad; formalizar el manuscrito propio. Riesgo principal: divulgar puede cambiar sentimiento y, con él, g y h. En ese escenario cambia la derivada total y debe estudiarse el signo. La ausencia de inferencia adicional desde precios se conserva como limitación del punto de partida. El apéndice manuscrito será personal.

14. **Cierre — 0:30.** Repetir la pregunta y el aporte concreto: una información pública coherente, una pendiente esperada creciente bajo condiciones y un escenario adicional en que se relajará sentimiento fijo.

## Respuestas breves a preguntas posibles

**¿Estás diciendo que el paper es falso?** Las fórmulas impresas admiten un contraejemplo de una afirmación específica. La propuesta corrige ese bloque y vuelve a probar un resultado; no invalida todo el paper.

**¿Por qué no eliminas el sentimiento?** Se conservan sesgos, riesgos subjetivos y aversión emocional. Se mantiene fijo para identificar primero el efecto informativo.

**¿Lean prueba el modelo completo?** No. Prueba 19 declaraciones algebraicas preliminares. Las esperanzas condicionales y el puente al modelo estocástico aún deben formalizarse.

**¿Cuál sería la extensión más allá de la corrección?** Permitir que estados sentimentales o masas cambien con μ y determinar condiciones para conservar o perder monotonicidad.

**¿Es un equilibrio de expectativas racionales completo?** Se mantiene la restricción original de no inferir adicionalmente la noticia desde precios. Resolver esa inferencia ampliaría el proyecto y no es un resultado ya obtenido.

**¿Y si no se permite vender corto?** Las FOC interiores dejan de ser suficientes para todos los agentes. Habría esquinas/KKT y cambiaría el equilibrio; el resultado principal usa posiciones reales sin restricciones.

## Referencias para la exposición

- Zhang, X. y W. Zhang (2023). Information asymmetry, sentiment interactions, and asset price. North American Journal of Economics and Finance 67, 101920. https://doi.org/10.1016/j.najef.2023.101920
- Das, K. K. y M. Yaghoubi (2024). Migration fear and stock price crash risk. Journal of International Financial Markets, Institutions and Money 91, 101945. https://doi.org/10.1016/j.intfin.2024.101945
