# Transparencia, sentimiento y fundamentos
**David Julio Olano Silva Nevado · IA y Modelamiento Económico · UP 2026-II**

**Pregunta.** ¿Cuándo una señal pública más precisa aumenta la sensibilidad esperada del precio de una acción a sus fundamentos?

**Aplicación.** Negociación secundaria de acciones de una empresa cotizada. Instituciones informadas y particulares con una señal pública imperfecta. La empresa es el emisor, pero su divulgación es exógena. No se modelan filtraciones, operaciones de políticos ni un problema de elección estratégica del emisor.

**Contribución.** Revisión de Zhang y Zhang (2023), sección 6.2, ecuaciones (39)–(44), pp. 15–16, proposición 5(ii). Construyo y=θ+η, con θ~N(0,s), η~N(0,t) independientes. Bayes da μ=s/(s+t), κ=E[θ|y]=μy y ξ=θ−κ. Derivo Var(κ)=μs, Var(ξ)=(1−μ)s y Cov(κ,ξ)=0. La normalidad conjunta permite independencia. Los extremos sin señal y señal exacta se definen por separado.

**Elección y resultado.** Desde U(W)=−exp(−gW), normalidad y W=C₀+ω(F−RP), obtengo el equivalente cierto C₀+ω(m−RP)−gvω²/2. Su CPO es m−RP−gvω=0. Con hᵢ=λᵢ/(gᵢvᵢ), a=h₁+h₂ y B=h₃+h₄, el precio esperado tiene sensibilidad K=(a+μB)/(R(a+B)). Pruebo K(y)>K(x) para 0≤x<y≤1 y K(1)=1/R.

**Condiciones materiales.** Cuatro masas positivas, R>0, s>0 y riesgo final e>0; sesgos, estados sentimentales, aversiones y varianzas subjetivas fijos, independientes del ruido y fundamentos; oferta fija, posiciones reales y **ausencia de aprendizaje adicional desde precios**. El resultado no establece bienestar, rentabilidades extraordinarias ni subidas universales del precio.

| Componente | Estado al 2 de noviembre |
|---|---|
| [Primera entrega](proposal/proposal.pdf) y [slides iniciales](slides/topic.pdf) | Conservadas |
| [Presentación final](slides/final.pdf) | 35 diapositivas principales y 6 de anexo, fuentes LaTeX |
| [Manuscrito](paper/paper.pdf) | Derivaciones, cuatro proposiciones, prueba, simulaciones, alcance y referencias |
| [Guion de exposición](slides/final-notes.md) | Ruta de 30 minutos, ejemplos y respuestas |
| [Código](code/verify.py) | Un comando, aritmética exacta, Monte Carlo e integración CARA |
| [Lean](lean/README.md) | 26 declaraciones algebraicas comprobadas, sin sorry ni axiomas propios |
| [Guía manuscrita](hand/derivaciones-guia.md) | Preparada para reproducir personalmente; **escaneos manuscritos pendientes** |
| Formalización integral del curso | **Pendiente**: puente probabilístico, corrida AppliedModelingLib y commit fijado |
| [Registro IA](prompts.md) | Conversaciones de estudio simuladas, identificadas como tales |

**Reproducir.** Python ≥3.10: python code/verify.py, sin bibliotecas externas. Compilar desde paper/ con tectonic paper.tex y desde slides/ con tectonic final.tex. Lean: instrucciones en lean/README.md. Los PDFs se guardan junto a sus fuentes. La carpeta preliminar no se presenta como el resultado del procedimiento integral del curso.

**Calendario verificado.** Presentación final: 4 de noviembre, 08:20–09:05 Lima. Preparación orientada a quedar lista esta noche por indicación del estudiante. La [instrucción vigente](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7) fija el paper final para el **26 de noviembre, 22:00**. La presentación es un avance para crítica. Repositorio: rama → PR → main. No se publica ningún comentario en el issue del profesor.
