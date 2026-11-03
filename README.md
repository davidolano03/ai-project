# Transparencia, sentimiento y fundamentos
**David Julio Olano Silva Nevado · IA y Modelamiento Económico · UP 2026-II**

**Pregunta.** ¿Cuándo una señal pública más precisa aumenta la sensibilidad esperada del precio de una acción a sus fundamentos?

**Aplicación.** Negociación secundaria de acciones de una empresa cotizada. Instituciones informadas y particulares con una señal pública imperfecta. La empresa es el emisor, pero su divulgación es exógena. No se modelan filtraciones, operaciones de políticos ni un problema de elección estratégica del emisor.

**Contribución.** Revisión de Zhang y Zhang (2023), sección 6.2, ecuaciones (39)–(44), pp. 15–16, proposición 5(ii). Construyo y=θ+η, con θ~N(0,s), η~N(0,t) independientes. Bayes da μ=s/(s+t), κ=E[θ|y]=μy y ξ=θ−κ. Derivo Var(κ)=μs, Var(ξ)=(1−μ)s y Cov(κ,ξ)=0. La normalidad conjunta permite independencia. Los extremos sin señal y señal exacta se definen por separado.

**Elección y resultado.** Desde U(W)=−exp(−gW), normalidad y W=C₀+ω(F−RP), obtengo el equivalente cierto C₀+ω(m−RP)−gvω²/2. Su CPO es m−RP−gvω=0. Con hᵢ=λᵢ/(gᵢvᵢ), a=h₁+h₂ y B=h₃+h₄, el precio esperado tiene sensibilidad K=(a+μB)/(R(a+B)). Pruebo K(y)>K(x) para 0≤x<y≤1 y K(1)=1/R.

**Condiciones materiales.** Cuatro masas positivas, R>0, s>0 y riesgo final e>0; sesgos, estados sentimentales, aversiones y varianzas subjetivas fijos, independientes del ruido y fundamentos; oferta fija, posiciones reales y **ausencia de aprendizaje adicional desde precios**. El resultado no establece bienestar, rentabilidades extraordinarias ni subidas universales del precio.

**Extensión.** Si el sentimiento responde a la transparencia, con ρ₁(μ) y ρ₂(μ) independientes de θ, K sigue siendo creciente cuando ρ₁′≥0 y ρ₂′≤0. Con ρ₁ fijo, K′>0 si y solo si B²+a[n₃e₃/d₃²+(n₄/d₄)(e₄/d₄−(1−μ)bρ₂′)]>0. En el ejemplo del contraejemplo, con ρ₂=b⁻¹ln(1+cμ), K′(0)<0 si y solo si c>101/36. El efecto que puede invertir el resultado es ∂K/∂B=−a(1−μ)/(R(a+B)²)<0: más peso de los particulares reduce la sensibilidad con μ fijo.

| Componente | Estado al 3 de noviembre |
|---|---|
| [Primera entrega](proposal/proposal.pdf) y [slides iniciales](slides/topic.pdf) | Conservadas |
| [Presentación final](slides/final.pdf) | 38 diapositivas principales y 24 de consulta; variables, derivaciones e interpretación en orden, con fuentes LaTeX |
| [Manuscrito](paper/paper.pdf) | Derivaciones, cinco proposiciones (incluida la extensión con sentimiento que responde a la transparencia), pruebas, simulaciones, alcance y referencias |
| [Guion de exposición](slides/final-notes.md) | Ruta de 30 minutos, ejemplos y respuestas |
| [Código](code/verify.py) | Un comando, aritmética exacta, Monte Carlo e integración CARA |
| [Lean](lean/README.md) | Cinco proposiciones probadas, incluida probabilidad y sentimiento variable; --fast: código 0; comparación directa: 5 MATCH |
| [Apéndice manuscrito](hand/derivaciones-manuscritas.pdf) | Seis fotos reales ordenadas: Bayes, posterior, varianzas y CARA/CPO; incluidas también en el paper y el Beamer. Otras derivaciones manuscritas por aportar; alcance en hand/README.md |
| Corrida de Lean del curso | Ejecutada sobre el commit 55409d5; versiones e informes en lean/verification/. No se afirma aceptación automática integral v12 |
| [Registro IA](prompts.md) | Registro histórico conservado y seis intercambios reales de estudio del 3 de noviembre (19–24), con sus preguntas, respuestas y capturas; revisión del estudiante pendiente |

Los apartados 1–18 de prompts.md conservan el registro histórico de estudio; los apartados 19–24 contienen intercambios reales de la conversación del 3 de noviembre. Las afirmaciones históricas sobre pruebas pendientes preceden a la corrida actual: el estado vigente de las cinco proposiciones está en lean/README.md.

**Reproducir.** Python ≥3.10: python code/verify.py, sin bibliotecas externas. Desde cada carpeta, latexmk -pdf paper.tex, latexmk -pdf final.tex, latexmk -pdf topic.tex y latexmk -pdf proposal.tex. Los cuatro PDFs guardados proceden de la compilación de GitHub Actions, con el workflow intacto de la plantilla. Tectonic y el editor nativo se usaron además para comprobaciones locales. Lean: instrucciones en lean/README.md; las pruebas actuales están en la raíz de lean/, con soporte reproducible para AppliedModelingLib. preliminary/ conserva las pruebas históricas. El chequeo focalizado y la comparación independiente directa no equivalen a un recibo integral v12; su alcance se detalla en lean/README.md.

**Calendario verificado.** Presentación final: 4 de noviembre, 08:20–09:05 Lima. Preparación orientada a quedar lista esta noche por indicación del estudiante. La [instrucción vigente](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7) fija el paper final para el **26 de noviembre, 22:00**. La presentación es un avance para crítica. Repositorio: rama → PR → main. No se publica ningún comentario en el issue del profesor.
