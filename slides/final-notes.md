# Guion de la presentación final

Versión del 2 de noviembre de 2026. Presentación programada: 4 de noviembre, 08:20–09:05 Lima. Objetivo: 30 minutos de exposición y 15 de discusión. 35 diapositivas principales y 6 de consulta. Las fórmulas completas están en el manuscrito.

## Ruta y tiempos

| Diapositivas | Minutos | Propósito |
|---|---:|---|
| 1–5 | 3 | Pregunta, aplicación, quién sabe qué y unidades |
| 6–9 | 3 | Auditoría del básico y la extensión |
| 10–18 | 10 | Derivar Bayes, κ, ξ y sus varianzas |
| 19–20 | 2 | Creencias y varianzas del pago |
| 21–25 | 5 | CARA, riqueza, equivalente cierto y CPO |
| 26–30 | 4 | Mercado, sensibilidad y prueba |
| 31–35 | 3 | Código, Lean, correcciones y discusión |

Si falta tiempo, dedicar menos a la auditoría original y conservar las derivaciones 10–16 y 21–24.

## 1–5. Qué estamos estudiando

Decir: «Mi unidad de análisis es la negociación de una acción de una empresa cotizada. La empresa emite la acción, pero no decide estratégicamente qué divulgar dentro de este modelo. Comparo cómo negocian instituciones y particulares con información diferente».

Información oculta es relativa al observador. Un reporte público y un dato reservado a algunos inversionistas son cosas distintas. El modelo no dice que todos los bancos conozcan toda la empresa; observar θ exactamente es una idealización. Si un dato solo lo conoce el emisor, no pertenece a la información institucional observada.

θ es una innovación monetaria por acción, no una cantidad de noticias. F=P₀+θ+ε. Con P₀=100, θ=10, ε=−2, el pago es 108. Se observa información antes de negociar y ε después.

## 6–9. El contraejemplo sin confundir puntos de partida

Básico significa que las instituciones conocen θ y los particulares no reciben una señal sobre su realización. Sus pronósticos previos de θ tienen media cero y varianza s. La acción puede responder a noticias por la negociación institucional.

En la extensión impresa κ=μθ, conocer μ>0 permite dividir y recuperar θ. El argumento requiere factor conocido y observación exacta. El segundo problema son las varianzas: ausencia de información requiere conservar s; información completa requiere retirarla del riesgo residual.

La comparación del contraejemplo es **0,552 frente a 0,643**. La cifra 0,500 viene de evaluar la extensión en cero y evidencia que no recupera el básico. No afirmar que 0,552 sea menor que 0,500 ni atribuir el resultado a desconfianza. Estados y sesgos cero no eliminan las varianzas subjetivas fijadas en uno.

## 10–13. De primitivas a posterior

Decir: «Voy a justificar las proporciones desde un reporte con ruido, no solo a escribirlas». y=θ+η; θ y η son independientes con varianzas s y t.

Bayes combina la distribución previa y la precisión del reporte. Usar x para un posible fundamento evita confundirlo con y, el dato que ya observamos. Abrir (y−x)² y completar el cuadrado en x. El coeficiente del cuadrado determina la precisión posterior; su inverso es la varianza. La media es s y/(s+t).

Definir μ=s/(s+t) después de derivar el posterior. No es la proporción exacta del valor realizado θ: es el peso del reporte y la fracción explicada de varianza. κ=μy es un resumen público; ξ=θ−κ es el residuo.

## 14. Varianza pública

Nombrar las reglas: independencia anula Cov(θ,η); varianzas suman s+t. Var(μy)=μ²Var(y). Sustituir μ y cancelar un s+t. El resultado μs se deriva. Aunque la varianza de κ aumente con μ, observarla resuelve ese componente. Su varianza marginal describe diferencias entre escenarios.

## 15–16. Varianza oculta y covarianza

Reescribir ξ=(1−μ)θ−μη. No aplicar suma simple sin explicar el término cruzado. La regla general es Var(aX+bY)=a²Var(X)+b²Var(Y)+2abCov(X,Y). Aquí la covarianza original es cero.

Sustituir μ=s/(s+t) y 1−μ=t/(s+t). El numerador t²s+s²t se factoriza como st(s+t). Así sale (1−μ)s.

Calcular además Cov(κ,ξ)=0. Decir la condición que permite independencia: **son conjuntamente gaussianos**. Covarianza cero por sí sola no basta en general. De ahí E[ξ|κ]=0 y Var(ξ|κ)=Var(ξ).

## 17–18. Traducir las fórmulas

Ejemplo s=t=100, y=8: μ=0,5, κ=4, varianza residual 50. No afirmar que θ sea 4. Con pago base 100 y e=4, la media es 104 y la varianza 54.

Explicar la diferencia de unidades: la raíz de 50 es 7,071 en dinero por acción; la varianza 50 está en unidades al cuadrado. Los extremos se definen aparte: μ=0 sin señal y μ=1 señal exacta. No definir una normal de varianza infinita.

## 19–20. Los cuatro grupos

Dos diferencias independientes: información y sentimiento. δ cambia la media; τ² añade incertidumbre subjetiva; ρ cambia aversión. Una constante no tiene varianza. No decir que la empresa paga más a los sentimentales: todos reciben F, aunque sus creencias difieran.

Institución racional: solo ε incierto. Particular racional: ξ y ε inciertos. Sus varianzas suman porque son independientes, incluso después de observar κ. Los otros grupos añaden su error subjetivo independiente.

## 21–24. CARA y la CPO

CARA es una preferencia sobre riqueza; no determina s, t o e. Derivar U' y U'' muestra que se prefiere más riqueza y se evita riesgo. El cociente −U''/U'=g no depende de la riqueza.

Partir del presupuesto, no directamente de la fórmula de demanda. Si se gastan Pω en acciones, queda w₀−Pω en el activo seguro. La riqueza final es Rw₀+ω(F−RP).

Su media es C₀+ω(m−RP); su varianza es ω²v porque las constantes no contribuyen. La normalidad permite integrar la utilidad exponencial. Mostrar E[U]=−exp[−g(M−gV/2)]. El equivalente cierto CE=M−gV/2 genera la misma elección; no es numéricamente igual a E[U].

En la CPO, precio, creencias y aversión permanecen fijos. Derivar cada término: cero, m−RP y −gvω. Despejar solo tras comprobar gv>0. Segunda derivada negativa y completar el cuadrado justifican máximo único.

## 25–30. Precio y resultado

Interpretar numerador y denominador de demanda antes de agregar. λ representa masa, h reúne masa y respuesta al riesgo. Vaciado: demanda agregada igual a una acción. Despejar P paso a paso.

Para obtener el precio esperado usar E[κ|θ]=μθ, derivada del ruido de media cero. El coeficiente K pertenece a ese promedio. Mantener fija κ y derivar precio realizado sería otra comparación.

La prueba exige a fijo: sentimiento y riesgo institucional no cambian con μ. Definir nⱼ, eⱼ y dⱼ antes de mostrar K'. La resta B−(1−μ)B' se simplifica a suma de términos positivos. La conclusión es sensibilidad esperada, no bienestar ni aumento del nivel para cualquier noticia.

El gráfico compara fórmulas con los mismos parámetros. La curva publicada se interpreta como fórmula impresa, no como una estimación de datos reales.

## 31–33. Qué está verificado

El código revisa 5.760 comparaciones exactas, 60 mercados, 144 casos del cuadrado posterior, 16 pares de varianzas, 120.000 observaciones simuladas y 12 integrales CARA. Los informes incluyen tolerancias; Monte Carlo no sustituye una prueba.

Lean comprueba 26 declaraciones algebraicas. Bayes, la teoría gaussiana de independencia y la integral probabilística completa permanecen abiertos en Lean. No confundir un argumento matemático escrito con una formalización integral de probabilidad.

Para cumplir el requisito de mostrar una derivación manuscrita, preparar personalmente las páginas de hand/, fotografiarlas y agregarlas. Actualmente la guía es tipografiada y no se presenta como evidencia manuscrita.

## 34–35. Alcance y preguntas

El modelo no está calibrado a una sola empresa: caracteriza una clase de mercados estilizados bajo supuestos fuertes. La elección de acciones lo hace interpretable. No trasladar automáticamente el resultado a bonos del gobierno ni a ganancias de políticos.

El aprendizaje desde precios es la limitación principal. Si todos conocieran pesos y oferta fija, podrían despejar θ. Resolver ese equilibrio informativo requeriría introducir y analizar incertidumbre adicional. Las preguntas de discusión piden crítica precisamente sobre esa extensión y sobre sentimiento endógeno.

## Preguntas frecuentes

**¿Es una corrección o una extensión?** Audito una inconsistencia concreta y propongo una estructura alternativa. La representación gaussiana es estándar; la aportación es reparar esta especificación y rederivar su sensibilidad de cuatro grupos.

**¿La información oculta pertenece al emisor?** El modelo especifica qué conoce cada inversionista. No modela un propietario estratégico de la información.

**¿Las instituciones ganan siempre?** No hay un resultado de rentabilidad extraordinaria. Riesgo, precio, costos y referencia son necesarios para formularlo.

**¿Todo el resultado está probado en Lean?** La parte algebraica indicada sí. El puente probabilístico completo y la corrida integral del curso están pendientes.

**¿Por qué el ruido de la señal pública no es ε?** η afecta lo que se aprende antes de negociar. ε afecta el pago final y sigue incierto incluso para la institución informada.
