# Revisión independiente de la integración

Base: e4be0600fcccbefde06ad43e2d207cb50e286e59. Fecha: 2 de noviembre de 2026.
Este archivo es una auditoría tipografiada. No es el apéndice manuscrito del estudiante.

## Proposición 5(i)

Partiendo de K=(a+μB)/[R(a+B)], con a=a(μ), B=B(μ), R constante:

K′=[(a′+B+μB′)(a+B)−(a+μB)(a′+B′)]/[R(a+B)²].

Expandir y agrupar da el numerador B(a+B)−(1−μ)(aB′−Ba′). La identidad es correcta y el código ahora compara ambas expresiones con fracciones.

## Proposición 5(ii)

dⱼ=eⱼ+(1−μ)s, B=n₃/d₃+n₄/d₄,
B′=s(n₃/d₃²+n₄/d₄²)+n₄′/d₄.
Sustituir produce

N=B²+a(n₃e₃/d₃²+n₄e₄/d₄²)−(1−μ)a n₄′/d₄+(1−μ)B a′.

El primer bloque es positivo. Si ρ₁′≥0 y ρ₂′≤0,
a′=bρ₁′h₂≥0 y n₄′=bρ₂′n₄≤0, por lo que los otros bloques son no negativos.
La prueba es correcta. Se precisa que ρ₂′≤0 significa menor optimismo y mayor aversión.

## Proposición 5(iii)

Con a′=0, el mismo numerador equivale exactamente a

B²+a[n₃e₃/d₃²+(n₄/d₄)(e₄/d₄−(1−μ)bρ₂′)].

El denominador R(a+B)² es positivo, de modo que su positividad es necesaria y suficiente para K′>0. La condición (1−μ)bρ₂′≤e₄/d₄ es suficiente, pues deja además el término n₃e₃/d₃²>0.

## Proposición 5(iv)

Con a=3/8, B(0)=5/24, d₃(0)=2, d₄(0)=3 y n₄=(1+cμ)/4:

N(0)=25/576+3/128+1/48−c/32=101/1152−c/32.

Como (a+B)²=49/144 y R=1, K′(0)=(101−36c)/392.
Así K′(0)<0 si y solo si c>101/36, y en el umbral vale cero.
El cálculo exacto confirma K(1/10; c=5)=1768/2803<9/14 y G(1/2; c=0)=23/55.
El caso c>−1 garantiza que 1+cμ sea positivo en todo [0,1].

## Otros contrastes

- El efecto de B tiene signo negativo con μ<1: ∂K/∂B=−a(1−μ)/[R(a+B)²].
- El coeficiente impreso crece dentro de su extensión, pero queda bajo el básico en [0; 0,26]. La afirmación sobre el continuo usa la prueba de monotonicidad del paper; la malla del código es un contraste adicional.
- El cruce está entre 0,2649199 y 0,2649200, según comparaciones racionales.
- El Monte Carlo del precio esperado es un diagnóstico de casos finitos, no una prueba probabilística general ni una prueba Lean.

## Citas comprobadas contra el PDF publicado

Zhang y Zhang (2023), NAJEF 67, 101920:

| Referencia | Ubicación comprobada | Uso |
|---|---|---|
| Ecuación (7) | p. 5 | Escribe utilidad esperada igual al criterio media-varianza; se aclara que es equivalente cierto |
| Ecuación (15) | p. 5 | Varianza básica del particular racional: e+s |
| Ecuación (23) | p. 9 | Coeficiente básico de información |
| Ecuaciones (38)–(43) | p. 15 | Partición y escenario de transparencia impresos |
| Ecuación (44) | p. 16 | Coeficiente con transparencia impresa |
| Proposición 5 | p. 16 | Comparación universal cuestionada |

Las páginas y ecuaciones solicitadas coinciden. No fue necesario cambiar esas localizaciones.
La auditoría de la nueva proposición no añade pruebas a Lean: su formalización sigue pendiente.

## Ejecución y compilación verificadas

- code/verify.py: PASS, incluidas las nuevas identidades exactas y el Monte Carlo del precio esperado.
- Lean preliminar: compilan los tres archivos existentes, con 26 declaraciones; ninguna afirmación nueva de la proposición 5 se presenta como probada en Lean.
- Las cuatro fuentes se compilaron con latexmk y pdfLaTeX en la [ejecución de Actions](https://github.com/davidolano03/ai-project/actions/runs/41537656352), a partir del commit de fuentes ec8fb24a08dc2fda8dc202b19baeec6145661ba9.
- Los cuatro PDFs generados por esa ejecución se copiaron a sus rutas y se revisaron: paper 14 páginas (10 de cuerpo), slides/final 44 (38 principales y 6 anexos), proposal 4 y slides/topic 26. Las referencias se resuelven después de las pasadas de latexmk.
- Workflow idéntico a la plantilla, SHA-256: 355acd36b49b4e552ab3b6859e99c81f550c2dfb245ad8c99f4fa1a266cbf9aa.

El commit anterior identifica las fuentes compiladas, no un commit formalizado. La corrida integral de Lean solo comenzará después de la revisión y fusión autorizada del PR.
