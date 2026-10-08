# Transparencia, sentimiento y fundamentos
**David Julio Olano Silva Nevado · IA y Modelamiento Económico · UP 2026-II**
Ruta A: corrección de [Zhang y Zhang (2023)](https://doi.org/10.1016/j.najef.2023.101920).

**Pregunta.** ¿Bajo qué condiciones una mayor transparencia aumenta la sensibilidad esperada del precio a los fundamentos cuando algunos inversionistas están afectados por sentimiento?

**Modelo.** Cuatro grupos, utilidad CARA y pago normal. El agente elige una posición real ω para maximizar C₀ + ω(m−RP) − gvω²/2; su FOC es m−RP−gvω=0. La oferta es una unidad. Sustituiré la información pública κ=μθ y la varianza impresa por θ=κ+ξ, con componentes gaussianos independientes, Var(κ)=μs y Var(ξ)=(1−μ)s. Así, más divulgación reduce la incertidumbre residual de los particulares. La propuesta explica cada variable y las restricciones informativas.

**Resultado y condiciones.** Para el precio esperado, K(μ)=(a+μB)/(R(a+B)), con a=h₁+h₂, B=h₃+h₄ y hᵢ=λᵢ/(gᵢvᵢ). Espero K(y)>K(x) para 0≤x<y≤1 y K(1)=1/R. Participaciones positivas, R>0, riesgo residual positivo, s>0 y varianzas sentimentales no negativas; estados sentimentales, sesgos, masas, aversiones de referencia y varianzas totales fijos y exógenos a la divulgación. Es respuesta a noticias, no un resultado de bienestar ni de precios siempre crecientes.

Los estados sentimentales son independientes de los componentes informativos; la sorpresa final es independiente y de media cero. La proposición 5(ii), p.16, requiere revisión: las fórmulas impresas admiten K₀=9/14 y Kᴵ(0.1)=66943/121303<K₀. Nuestra corrección recupera el caso sin información y tiene una prueba algebraica para los cuatro grupos.

| Componente | Estado |
|---|---|
| [Propuesta](proposal/proposal.pdf) y [diapositivas](slides/topic.pdf) | Primera entrega; 22 diapositivas principales y 4 de anexo, con ejemplos y guion de 20 minutos |
| [Código](code/verify.py) | PASS: 5,760 comparaciones exactas y 60 casos de mercado |
| [Lean preliminar](lean/README.md) | 19 declaraciones comprobadas, sin sorry; puente probabilístico pendiente |
| Paper y diapositivas finales | En preparación; archivos explícitos de estado, no entregas finales |
| Apéndice manuscrito | Pendiente de elaboración personal |
| AppliedModelingLib sobre commit final | Pendiente; no sustituido por la auditoría preliminar |

**Reproducir.** Python ≥3.10: python code/verify.py. Desde cada carpeta: tectonic proposal.tex, tectonic topic.tex, tectonic final.tex y tectonic paper.tex; alternativa latexmk -pdf. Lean: instrucciones y versiones en lean/README.md. El flujo del curso es rama → PR → main; se conservan los nombres y el workflow de la [plantilla](https://github.com/alexanderquispe/ai-project-template).

**Calendario.** Topic presentation: 9/10/2026, 07:55–08:15 Lima. Primera entrega en main: 8/10, 22:00. Instrucciones: [issue del curso](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7). Revisión de literatura: [registro](proposal/literature-search.md). Uso de IA: [prompts y respuestas](prompts.md).
