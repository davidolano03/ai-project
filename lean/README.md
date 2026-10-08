# Lean: auditoría preliminar de la primera entrega

Estas pruebas apoyan la pregunta y la corrección. No son la carpeta final generada por AppliedModelingLib sobre el commit fijado del manuscrito: ese procedimiento se ejecutará cuando el paper propio esté terminado.

**Entorno comprobado:** Lean 4.30.0-rc2 y Mathlib de la misma versión. Archivos fuente y salidas del compilador en preliminary/. No se usan sorry, admit ni axiomas propios; los únicos axiomas reportados son propext, Classical.choice y Quot.sound.

| Afirmación | Declaración / archivo | Alcance |
|---|---|---|
| Demanda óptima y FOC | demand_maximizes; demand_satisfies_FOC / BaselineAudit.lean | Equivalente cierto cuadrático, coeficiente de riesgo positivo |
| Vaciado de mercado | market_clearing / BaselineAudit.lean | Identidad agregada; denominadores no nulos |
| Contraejemplo con μ=0.1 | positive_transparency_counterexample; not_universal_transparency_improvement / BaselineAudit.lean | Fórmulas publicadas y parámetros indicados |
| Señal escalada revela la noticia | scaled_signal_reveals_theta / BaselineAudit.lean | μ conocido, distinto de cero |
| Corrección con cuatro grupos | four_group_information_increases / Transparency.lean | a,n₃,n₄,e₃,e₄,R>0; t≥0; x<y≤1 |
| Información completa | full_information_endpoint / Transparency.lean | K(1)=1/R con pesos y varianzas positivos |

BaselineAudit.lean contiene 15 declaraciones: incluye identidades y una corrección preliminar con un solo bloque particular homogéneo. Transparency.lean añade 4 declaraciones y mantiene distintos los grupos particulares 3 y 4; a=h₁+h₂ suma las dos instituciones sin imponerles homogeneidad.

**Mapa:** n₃=λ₃/γ, n₄=λ₄/g₄, e₃=σ²ε, e₄=σ²ε+τ²₂, t=s. informationCoefficient es exactamente (a+μB)/(R(a+B)), con B=n₃/[e₃+(1−μ)t]+n₄/[e₄+(1−μ)t]. La prueba incluso admite t=0; la propuesta usa s>0 para su interpretación informativa.

**Falta formalizar:** las esperanzas gaussianas E[θ|κ]=κ y E[κ|θ,ρ]=μθ, la vinculación entre las creencias normales y las definiciones algebraicas, y el modelo estocástico completo. El sentimiento fijo/exógeno y la ausencia de inferencia adicional desde precios son supuestos económicos que la desigualdad racional no valida.

## Reproducir

Con elan/lake disponibles, desde preliminary/: lake update, lake exe cache get, lake env lean BaselineAudit.lean y lake env lean Transparency.lean. lean-toolchain y lakefile.toml fijan versiones.

Para reutilizar un Mathlib ya compilado en Windows, ejecutar preliminary/verify.ps1 con los parámetros -LeanExecutable y -PackagesDirectory (directorio que contiene mathlib y sus dependencias). El script configura LEAN_PATH y guarda ambos informes; no instala herramientas.

## Formalización final pendiente

Se seguirá el procedimiento de la plantilla: fijar el commit del paper propio, usar la habilidad paper-formalization de AppliedModelingLib, ejecutar el control paper-scoped con --fast, conservar la carpeta generada completa y mapear cada resultado numerado. No se atribuye ese estado a estas pruebas preliminares.
