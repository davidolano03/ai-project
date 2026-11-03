# Guion de la presentación final

Secuencia alineada con el manual de estudio del modelo corregido y ampliado.
38 diapositivas principales y 18 de consulta. Mantiene el tema visual y el título.
La ruta principal está pensada para aproximadamente 30 minutos; el apéndice permite responder una pregunta en el momento.

## Ruta de exposición

| Bloque | Minutos orientativos | Propósito |
|---|---:|---|
| 1–6 | 4 | Pregunta, pago, varianza y actores |
| 7–14 | 7 | Señal, Bayes, componentes y extremos |
| 15–21 | 6 | Creencias, sentimiento, CARA y CPO |
| 22–27 | 5 | Mercado, sensibilidad y dos efectos |
| 28–34 | 6 | Corrección y extensión con umbral |
| 35–38 | 2 | Evidencia, alcance y respuesta final |

Los tiempos son una guía: conviene ensayar. No leer cada fila de las tablas; explicar qué cambia entre los grupos.

## Guion por diapositiva y vínculo con el manual

### 1. Portada

Presentar el tema como una corrección informativa y una extensión del sentimiento.

Manual: secciones 1.

### 2. La pregunta que queremos responder

Formular la pregunta sin usar K, rho ni derivadas todavía. La contribución tiene dos partes: señal coherente y reacción del sentimiento.

Manual: secciones 1, 18.

### 3. Precio de hoy y pago futuro

P0 es referencia del pago, no la riqueza del inversionista ni necesariamente el precio actual. Se negocia antes de conocer epsilon.

Manual: secciones 2.

### 4. Qué significa una varianza

Definir E y Var antes de usarlos en el modelo. Mostrar por qué el cuadrado impide que los errores positivo y negativo se cancelen.

Manual: secciones 3.

### 5. Las incertidumbres y las reglas que usaremos

m y v solo describen la notación normal en esta diapositiva; c y d son constantes auxiliares. s es incertidumbre fundamental previa y e la sorpresa final.

Manual: secciones 3.

### 6. Los cuatro grupos y la información disponible

Institucional no significa automáticamente información ilegal. Si solo el emisor conoce un dato, ambos grupos de inversionistas lo desconocen. La restricción sobre precios se declara aquí desde el inicio.

Manual: secciones 2, 17.

### 7. Nuestra señal pública contiene ruido

y es el reporte y eta su ruido; t es varianza del ruido. Un menor t significa más precisión, manteniendo fija s.

Manual: secciones 4.

### 8. Bayes: del reporte al pronóstico

Explicar que condicionar significa usar un dato ya conocido. La densidad previa y la probabilidad del reporte se multiplican. El término constante solo normaliza la densidad. El desarrollo completo está disponible en el apéndice, sin aplazar la definición de ninguna variable.

Manual: secciones 5.

### 9. Definir \mu, \kappa y \xi después de Bayes

mu es adimensional y es fracción de varianza explicada. Kappa es pronóstico público y xi el error residual, ambos en dinero por acción. No se conoce una fracción exacta de cada noticia realizada.

Manual: secciones 5, 6.

### 10. Derivación de la varianza pública

La varianza de y es s+t; multiplicar por mu al cuadrado y sustituir mu=s/(s+t) produce mu*s. No se asume la proporción.

Manual: secciones 6.

### 11. Derivación de la varianza oculta

Reescribir xi antes de calcular la varianza. El ruido eta y theta son independientes; sus coeficientes se elevan al cuadrado.

Manual: secciones 6.

### 12. Por qué el componente público no revela el residuo

Covarianza cero implica independencia aquí por normalidad conjunta. Distinguir varianza marginal de kappa de varianza posterior del fundamento.

Manual: secciones 6.

### 13. Un ejemplo que distingue promedio e incertidumbre

Un pronóstico de 104 no es un pago seguro. La desviación estándar traduce la varianza de nuevo a unidades monetarias.

Manual: secciones 6.

### 14. Los extremos ahora representan lo que queremos

En mu=0 se define ausencia de señal, no una normal de varianza infinita. En mu=1 se conoce theta, pero epsilon sigue incierto.

Manual: secciones 6.

### 15. Media y varianza del pago que cree cada grupo

Presentar m y v antes de la tabla de grupos. Conocer una cantidad elimina su incertidumbre condicional, aunque varíe entre escenarios.

Manual: secciones 8.

### 16. Tres parámetros distintos del sentimiento

Los parámetros sentimentales no añaden pagos reales distintos para cada grupo. Los errores subjetivos son independientes y añaden tau cuadrado a la varianza. rho=0 conserva aversión gamma positiva.

Manual: secciones 8.

### 17. Las creencias de los cuatro grupos

Leer la tabla como cuatro creencias sobre el mismo pago. Justificar cada suma de varianzas por independencia. gamma, b, rho, delta y tau ya están definidos.

Manual: secciones 8.

### 18. Comprar acciones: presupuesto y riesgo de riqueza

Definir todas las cantidades antes de la ecuación de riqueza. C0 es riqueza segura, diferente del intercepto de precio C(mu). P se toma como dado al elegir.

Manual: secciones 9.

### 19. CARA: cómo el agente valora la riqueza

CARA evalúa el riesgo que proviene de los pagos; no genera las varianzas. g puede variar entre estados y seguir siendo constante respecto de riqueza.

Manual: secciones 10.

### 20. De la utilidad al equivalente cierto

q es auxiliar y no es el peso institucional a. La identidad normal se obtiene completando el cuadrado y la integral queda en el apéndice para consulta inmediata. CE no es numéricamente utilidad esperada.

Manual: secciones 10.

### 21. Derivar la CPO, término por término

Derivar constante, término lineal y cuadrático. g y v son positivos. Una posición negativa es venta corta permitida; la prueba global se puede consultar en A3.

Manual: secciones 11.

### 22. Del tamaño de cada grupo a su peso en el mercado

lambda es masa de agentes, no participación accionaria. Definir h, H, a y B antes de cualquier fórmula que los use. La oferta es el 1 del numerador, no un dato de rentabilidad.

Manual: secciones 12.

### 23. Precio esperado y sensibilidad al fundamento

Distinguir E[theta|kappa] de E[kappa|theta]. Aquí se fija el fundamento y se promedia el ruido. C incluye referencia, sesgos y prima por absorber oferta.

Manual: secciones 7, 12.

### 24. La proposición propia y todas sus condiciones

mu_L y mu_H son dos niveles de precisión, bajo y alto. La afirmación requiere sentimiento fijo. K creciente no garantiza que toda noticia suba el precio.

Manual: secciones 13.

### 25. Preparar la derivada sin ocultar parámetros

n agrupa masa y aversión; e3/e4 es riesgo que no desaparece con el reporte; d es varianza total percibida. El índice j aquí toma 3 y 4; no es el j=1,2 de los estados sentimentales.

Manual: secciones 13.

### 26. Por qué la sensibilidad aumenta

Cada d_j menos la incertidumbre residual equivale a e_j positivo. La cancelación prueba que la derivada es positiva para todo el intervalo, no solo para una simulación.

Manual: secciones 13.

### 27. Dos efectos de signo opuesto

Explicar por qué dar más peso a particulares parcialmente informados reduce sensibilidad a mu fijo. Esta es la corrección de la intuición que antes sumaba dos efectos positivos.

Manual: secciones 13, 18.

### 28. La corrección frente a Zhang y Zhang

La crítica es específica a las fórmulas e interpretación de información parcial. La varianza marginal de una señal escalada no es la incertidumbre restante tras observarla.

Manual: secciones 4, 14.

### 29. El sentimiento también puede responder a la divulgación

Solo se relaja el estado sentimental fijo. delta y tau siguen constantes. rho creciente representa menor aversión, no un cambio automático de la media creída.

Manual: secciones 15.

### 30. La derivada general y los signos del sentimiento

Los dos términos nuevos son no negativos bajo los signos indicados. rho2 menor significa mayor aversión particular; evitar decir solamente que el mercado se calma.

Manual: secciones 15.

### 31. Con instituciones fijas: condición exacta y cota suficiente

La cota hace no negativo el último paréntesis; B al cuadrado y el término del particular racional siguen siendo positivos incluso cuando hay igualdad.

Manual: secciones 15.

### 32. Un escenario concreto de optimismo creciente

Todos los parámetros de la calibración ya se han definido. c>-1 garantiza que el argumento del logaritmo es positivo en todo el intervalo. c=0 recupera sentimiento fijo.

Manual: secciones 15.

### 33. Derivar el umbral de reversión

La derivada en cero es lateral dentro del intervalo. El umbral no afirma caída permanente: con información completa K vuelve a 1/R.

Manual: secciones 15.

### 34. Cuándo se invierte el resultado

Con c=5, K(0.1)=1768/2803 es menor que K(0)=9/14. La información es mejor, pero el cambio del peso particular domina al inicio.

Manual: secciones 15.

### 35. Qué comprueba el código

Explicar qué verifican el código y las simulaciones, con recuentos reales del repositorio. Una simulación no constituye la prueba general.

Manual: secciones 19.

### 36. Las cinco proposiciones comprobadas con Lean

Los cinco endpoints compilaron y sus axiomas son los estándares de Lean. El chequeo --fast terminó con código 0. La revisión independiente directa comparó las cinco proposiciones con sus Specs: 5 MATCH. Distinguir esta revisión de un recibo automático de aceptación integral v12, que no se ha emitido. El cuadro del apéndice del paper y lean/README.md indican los mismos estados.

Manual: secciones 19.

### 37. El límite principal: aprender del precio cambiaría el problema

La restricción de información se declaró desde el comienzo. Esta fórmula muestra por qué es material: si el particular usara el precio y conociera todos los pesos, podría despejar theta.

Manual: secciones 17.

### 38. Respuesta a la pregunta de investigación

Cerrar volviendo a la pregunta. La novedad es la condición y reversión, junto con la reparación de la señal. No extender la conclusión a alfa ni bienestar.

Manual: secciones 1, 18, 20.

## Regla para responder preguntas

Primero nombrar la variable y sus unidades; después indicar qué se mantiene fijo; finalmente interpretar la ecuación.
Las definiciones se introducen antes de la tabla o ecuación que las utiliza. Para una manipulación extensa, abrir en el momento la diapositiva de consulta correspondiente.

## Variables en su primera aparición

| Símbolo | Primera explicación |
|---|---|
| P, F, P0, theta, epsilon | 3: precio y pago |
| E, Var, desviación estándar | 4: incertidumbre |
| s, e, Cov y N(media,varianza) | 5: supuestos y reglas |
| i=1,2,3,4 | 6: grupos |
| y, eta, t | 7: reporte |
| x, f y proporcionalidad | 8: Bayes |
| mu, kappa, xi | 9: posterior y residuo |
| m_i, v_i, E_i, Var_i | 15: creencias |
| delta, tau², rho, gamma, b, g_i | 16: sentimiento |
| w0, omega, R, W, C0, M_i, V_i | 18: riqueza |
| U y aversión absoluta | 19: CARA |
| q y CE | 20: identidad normal y equivalente cierto |
| lambda, h, H, a, B | 22: mercado |
| C(mu), P medio y K | 23: precio esperado |
| n3/n4, e3/e4, d_j y prima | 25: derivada |
| a(mu), n4(mu) y sus derivadas | 29: extensión |
| c | 32: trayectoria logarítmica |
| c* | 33: umbral |
| G | Apéndice: fracción de brecha |

## Consultas preparadas

La varianza pública creciente y la residual decreciente se explican en 10–14; la derivación extendida usa A2.
La identidad exponencial normal se demuestra en A1; el máximo global de la CPO, en A3.
La comparación numérica con el modelo básico está en el apéndice y utiliza parámetros ya definidos en el cuerpo principal.
La auditoría específica de afirmaciones de IA conserva su tabla en el apéndice.
Los glosarios finales permiten recuperar de inmediato cualquier unidad o índice.

## Estado de integración

La diapositiva 36, el apéndice del paper y lean/README.md registran cinco proposiciones probadas, chequeo --fast con salida 0 y comparación directa 5 MATCH. El manuscrito formalizado es el commit 55409d5; no se alteraron sus cinco proposiciones.
No se generan fotos manuscritas ni conversaciones reales del estudiante.
