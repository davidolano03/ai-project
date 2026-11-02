# Lean: alcance comprobado de la entrega

La carpeta preliminary/ contiene **26 declaraciones comprobadas**: 15 en BaselineAudit.lean, 4 en Transparency.lean y 7 en SignalCARA.lean. Entorno: Lean 4.30.0-rc2 y Mathlib de la misma versión. Los informes junto a los archivos imprimen el cierre de axiomas estándar propext, Classical.choice y Quot.sound. No se usan sorry, admit ni axiomas propios.

| Resultado del manuscrito | Declaraciones | Alcance real |
|---|---|---|
| Prop. 1: información pública y oculta | posterior_square, public_variance, hidden_variance, public_hidden_covariance, total_variance / SignalCARA.lean | Identidades de momentos y completar el cuadrado. Bayes, variables aleatorias, normalidad conjunta y esperanza condicional permanecen abiertos en Lean. |
| Prop. 2: demanda CARA | cara_normal_exponent, gaussian_integral_square / SignalCARA.lean; demand_maximizes, demand_satisfies_FOC / BaselineAudit.lean | Identidades del exponente, CPO y máximo global del equivalente cierto. La integral gaussiana y equivalencia con utilidad esperada no están formalizadas probabilísticamente. |
| Prop. 3: precio | market_clearing / BaselineAudit.lean | Vaciado algebraico. La esperanza del precio requiere el puente probabilístico. |
| Prop. 4: monotonicidad | four_group_information_increases, full_information_endpoint / Transparency.lean | Probadas para el coeficiente algebraico de cuatro grupos y parámetros positivos explícitos. |
| Prop. 5: sentimiento que responde a la transparencia | Sin declaración Lean todavía | Resultado con prueba escrita y comprobaciones racionales en code/verify.py. **Abierto en Lean:** falta implementar a(μ), n₄(μ), sus derivadas y las cuatro partes en el procedimiento integral del curso. |
| Auditoría del paper | positive_transparency_counterexample, scaled_signal_reveals_theta / BaselineAudit.lean | Contraejemplo de las fórmulas impresas y señal determinista invertible. |

**Reproducir.** preliminary/verify.ps1 recibe -LeanExecutable y -PackagesDirectory. Este último debe contener Mathlib y sus dependencias compiladas. El script configura LEAN_PATH y comprueba los tres archivos; falla ante error o sorryAx y escribe sus informes. Con lake disponible, usar el lakefile y la versión fijada de preliminary/, y ejecutar lake env lean para cada archivo.

**Mapa de parámetros.** a=h₁+h₂, n₃=λ₃/γ, n₄=λ₄/g₄, e₃=e, e₄=e+τ²₂, t=s en Transparency.lean. La letra t de ese archivo es varianza fundamental, mientras t en SignalCARA.lean y el manuscrito es varianza del ruido público. Son nombres locales de archivos diferentes; no se intercambian.

**Procedimiento integral pendiente.** Esta carpeta continúa siendo una auditoría preliminar, no la carpeta generada por una corrida final de AppliedModelingLib. Antes del paper final del 26 de noviembre: fijar el commit del manuscrito, ejecutar la habilidad y comprobación paper_contribution.py check del repositorio vigente, copiar la carpeta generada completa y registrar el commit y el informe. Cada fila debe declarar si está probada, usa hipótesis adicionales o permanece abierta. No se atribuyen pruebas de probabilidad a identidades algebraicas.
