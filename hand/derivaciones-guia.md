# Guía para elaborar el apéndice manuscrito

Esta guía es material tipografiado de estudio. El estudiante debe reproducir personalmente las derivaciones, nombrar las reglas y adjuntar sus fotografías o escaneos legibles. Aquí no se simulan páginas manuscritas ni se afirma que ya existan.

## 1. Primitivas y unidades

Escribir θ~N(0,s), η~N(0,t), ε~N(0,e), independientes, s,t,e>0.
F=P₀+θ+ε, y=θ+η. Explicar que F,P₀,θ,y,η,ε son dinero por acción; sus varianzas tienen esas unidades al cuadrado. μ es adimensional.
Separar el caso interior 0<μ<1 de los extremos.

## 2. Bayes, sin saltarse el cuadrado

1. Escribir f(x|y)=f(y|x)f(x)/f(y).
2. Introducir las densidades normales. Para hallar el núcleo en x, sacar todas las constantes que no dependen de x.
3. El exponente es −[x²/s+(y−x)²/t]/2.
4. Expandir (y−x)²=y²−2xy+x².
5. Agrupar A x²−2(y/t)x+y²/t con A=(s+t)/(st)>0.
6. Completar: A[x−s y/(s+t)]²+y²/(s+t). Desarrollar el nuevo cuadrado para comprobar igualdad.
7. Identificar media posterior s y/(s+t) y varianza 1/A=st/(s+t).
8. Definir μ=s/(s+t), κ=μy y ξ=θ−κ. Explicar que κ es el pronóstico público y ξ su error, todavía desconocido.

## 3. Varianza pública

1. Var(y)=Var(θ)+Var(η)+2Cov(θ,η).
2. Independencia implica Cov(θ,η)=0; por tanto Var(y)=s+t.
3. Var(κ)=Var(μy)=μ²Var(y).
4. Sustituir μ: s²(s+t)/(s+t)²=s²/(s+t).
5. Reconocer μs. Explicar por qué no se postuló sin derivación.

## 4. Varianza oculta

1. ξ=θ−μ(θ+η)=(1−μ)θ−μη.
2. Aplicar Var(aX+bY)=a²Var(X)+b²Var(Y)+2abCov(X,Y).
3. Obtener (1−μ)²s+μ²t−2μ(1−μ)Cov(θ,η).
4. Anular el término cruzado por independencia.
5. Sustituir 1−μ=t/(s+t).
6. El numerador es t²s+s²t=st(s+t). Dividir por (s+t)².
7. El resultado es st/(s+t)=(1−μ)s.

## 5. Covarianza e independencia

1. Expandir Cov(μθ+μη,(1−μ)θ−μη) usando bilinealidad.
2. Los términos cruzados con Cov(θ,η) son cero.
3. Quedan μ(1−μ)s−μ²t=μ[(1−μ)s−μt].
4. Sustituir μ y verificar que el corchete es cero.
5. Escribir la condición indispensable: κ y ξ son conjuntamente gaussianos, pues son transformaciones lineales de normales independientes.
6. Solo en ese marco usar covarianza cero implica independencia.
7. Concluir E[θ|κ]=κ y Var(θ|κ)=(1−μ)s.
8. Derivar E[κ|θ]=E[μθ+μη|θ]=μθ porque η es independiente y tiene media cero.
9. Verificar Var(κ)+Var(ξ)=s.
10. Extremos: μ=0 significa κ=0 y ξ=θ; μ=1 significa κ=θ y ξ=0. No escribir una normal de varianza infinita.

## 6. Medias y varianzas de los cuatro grupos

1. Institución racional: observa θ, por tanto m₁=P₀+θ y v₁=e.
2. Particular racional: F=P₀+κ+ξ+ε; κ es constante después de observarlo. m₃=P₀+κ y v₃=(1−μ)s+e por independencia.
3. Error subjetivo normal ζⱼ de media δⱼ y varianza τ²ⱼ, independiente. Añadirlo a la creencia desplaza media y varianza.
4. Institución sentimental: m₂=P₀+θ+δ₁, v₂=e+τ²₁.
5. Particular sentimental: m₄=P₀+κ+δ₂, v₄=e+(1−μ)s+τ²₂.
6. Explicar que F es común. ζ representa una creencia subjetiva, no otro pago de la empresa. Una constante δ no añade varianza.

## 7. De cartera a riqueza

1. Escribir presupuesto: se pagan Pω por acciones, quedan w₀−Pω en activo seguro.
2. W=R(w₀−Pω)+ωF.
3. Expandir: W=Rw₀+ω(F−RP)=C₀+ω(F−RP).
4. Esperanza: M=C₀+ω(m−RP).
5. Varianza: Var(W)=Var(ω(F−RP))=ω²Var(F−RP)=ω²v.
6. Nombrar las reglas: linealidad de esperanza, invarianza de varianza al sumar constantes y cuadrado del factor de escala.

## 8. CARA y su integral

1. U(W)=−exp(−gW), g>0.
2. Derivar U'=g exp(−gW)>0 y U''=−g²exp(−gW)<0.
3. Calcular −U''/U'=g. Mantener g fijo al elegir.
4. Para W normal con media M y varianza V>0, escribir la integral de E[exp(aW)].
5. Completar: aw−(w−M)²/(2V)=−[w−(M+aV)]²/(2V)+aM+a²V/2.
6. Sacar exp(aM+a²V/2). La densidad restante integra uno.
7. Obtener E[exp(aW)]=exp(aM+a²V/2).
8. Tomar a=−g y el signo negativo de U.
9. Obtener E[U]=−exp[−g(M−gV/2)].
10. La transformación de CE=M−gV/2 es creciente. Por eso maximizar CE da la misma elección.
11. Si ω=0 y V=0, comprobar directamente la riqueza constante. No usar una densidad de varianza cero.

## 9. CPO y máximo global

1. CE=C₀+ω(m−RP)−gvω²/2.
2. Derivar constantes: 0.
3. Derivar el término lineal: m−RP.
4. Derivar el cuadrado: −gvω.
5. CPO: m−RP−gvω=0.
6. Mover términos y dividir por gv>0: ω*=(m−RP)/(gv).
7. Segunda derivada: −gv<0.
8. Completar el cuadrado y comprobar CE(ω*)−CE(ω)=gv(ω−ω*)²/2≥0.
9. La igualdad solo ocurre cuando ω=ω*, por lo que el máximo es único.

## 10. Precio

1. Escribir oferta uno: Σλᵢωᵢ*=1.
2. Sustituir demandas y definir hᵢ=λᵢ/(gᵢvᵢ)>0.
3. Expandir: Σhᵢmᵢ−RPΣhᵢ=1.
4. Definir H=Σhᵢ>0 y despejar P=(Σhᵢmᵢ−1)/(RH).
5. Sustituir las cuatro medias y agrupar P₀, θ, κ y δ.
6. Definir a=h₁+h₂ y B=h₃+h₄.
7. Tomar esperanza condicionada en θ y estados fijos, usando E[κ|θ]=μθ.
8. Obtener P̄=C(μ)+K(μ)θ, K=(a+μB)/(R(a+B)).
9. Explicar diferencia entre precio esperado y precio realizado con señal fija.

## 11. Derivada del coeficiente

1. n₃=λ₃/γ, n₄=λ₄/g₄, e₃=e, e₄=e+τ²₂.
2. dⱼ=eⱼ+(1−μ)s>0 y B=Σ nⱼ/dⱼ.
3. Derivar B'=Σ nⱼs/dⱼ².
4. Aplicar regla del cociente a K con a y R fijos.
5. Expandir y cancelar términos para obtener [B²+a(B−(1−μ)B')]/[R(a+B)²].
6. En cada término: nⱼ/dⱼ−(1−μ)nⱼs/dⱼ²=nⱼeⱼ/dⱼ²>0.
7. Concluir K'>0 con todos los signos justificados.
8. Verificar K(1)=1/R y K(0) coincide con el básico.
9. Copiar la identidad de diferencias finitas del apéndice y comprobarla poniendo fracciones sobre denominador común.

## 12. Defender el alcance

Escribir explícitamente: sentimiento fijo, oferta fija, posiciones sin restricciones, señal gaussiana y ausencia de inferencia adicional desde precios. Poder despejar θ de la ecuación de precio si todos los demás términos fueran conocidos, y explicar por qué ese aprendizaje cambiaría el problema. Información privada institucional no identifica un emisor estratégico ni garantiza ganancias extraordinarias.

## 13. Extensión con sentimiento que responde a la transparencia

Guía tipografiada para el trabajo personal; no es un manuscrito ni una conversación simulada.

1. Dejar que a y n₄ dependan de μ, conservando los estados independientes de θ.
2. Aplicar la regla del cociente a K=(a+μB)/[R(a+B)] y obtener el numerador B(a+B)−(1−μ)(aB′−Ba′).
3. Escribir n₄′=bρ₂′n₄ y a′=bρ₁′h₂.
4. Sustituir B′=sΣ nⱼ/dⱼ²+n₄′/d₄ y separar los tres bloques del numerador según la proposición 5(ii).
5. Comprobar positividad si ρ₁′≥0 y ρ₂′≤0.
6. Con a′=0, obtener la condición necesaria y suficiente de la parte (iii).
7. En el ejemplo logarítmico, calcular 25/576+3/128+1/48=101/1152 y multiplicar por 32.
8. Dividir por (a+B)²=49/144: K′(0)=(101−36c)/392.
9. Verificar el umbral 101/36 y sustituir c=5, μ=1/10 para obtener 1768/2803.
10. Explicar por qué el umbral pertenece a ese ejemplo y la condición (iii) es la general.

## Qué fotografiar

Cada bloque con nombre de regla, condiciones de división y explicación breve. Numerar páginas y comprobar que todas se lean. Colocar las fotografías o escaneos propios en esta carpeta. La presentación requiere mostrar una derivación personal revisada, por ejemplo los bloques 4 y 5.
