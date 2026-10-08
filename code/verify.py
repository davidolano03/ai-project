"""Reproduce topic evidence with exact rational arithmetic.
Run: python code/verify.py. Graph: native PGFPlots LaTeX from the checked CSV.
This numerical/algebraic audit does not formalize Gaussian conditioning.
"""
from pathlib import Path
from fractions import Fraction as F
from itertools import product
import csv
import json

HERE=Path(__file__).resolve().parent
OUTPUT,FIGURES=HERE/"output",HERE/"figures"
OUTPUT.mkdir(exist_ok=True)
FIGURES.mkdir(exist_ok=True)

def printed(mu):
    a=F(3,8)
    B=F(1,4)/(1+mu**2)+F(1,4)/(2+mu**2)
    return (a+mu*B)/(a+B)

def retail(n3,n4,e3,e4,s,mu):
    return n3/(e3+(1-mu)*s)+n4/(e4+(1-mu)*s)

def coefficient(a,n3,n4,e3,e4,s,R,mu):
    B=retail(n3,n4,e3,e4,s,mu)
    return (a+mu*B)/(R*(a+B))

def derivative_formula(a,n3,n4,e3,e4,s,R,mu):
    d3,d4=e3+(1-mu)*s,e4+(1-mu)*s
    B=n3/d3+n4/d4
    Bprime=s*(n3/d3**2+n4/d4**2)
    quotient=((B+mu*Bprime)*(a+B)-(a+mu*B)*Bprime)/(R*(a+B)**2)
    reduced=(B**2+a*(n3*e3/d3**2+n4*e4/d4**2))/(R*(a+B)**2)
    assert quotient==reduced, "FAIL: derivative reduction"
    assert reduced>0, "FAIL: corrected derivative"
    return reduced

baseline=F(9,14)
assert printed(F(0))==F(1,2)
assert printed(F(1,10))==F(66943,121303)
assert printed(F(1,10))-baseline==-F(22075,242606)
assert printed(F(1,10))<baseline, "FAIL: claimed counterexample"
baseparams=(F(3,8),F(1,4),F(1,4),F(1),F(2),F(1),F(1))
assert coefficient(*baseparams,F(0))==baseline
assert coefficient(*baseparams,F(1))==1
assert coefficient(*baseparams,F(1,10))==F(583,871)

with (OUTPUT/"information.csv").open("w",newline="",encoding="utf-8") as f:
    writer=csv.writer(f)
    writer.writerow(["mu","baseline","printed","corrected"])
    for i in range(101):
        mu=F(i,100)
        writer.writerow([float(mu),float(baseline),float(printed(mu)),
                         float(coefficient(*baseparams,mu))])

checked_pairs=0
for a,n3,n4,e3,extra,s,R in product(
    [F(1,8),F(1),F(4)],[F(1,8),F(1)],[F(1,16),F(1,2),F(2)],
    [F(1,2),F(1)],[F(0),F(1)],[F(1,2),F(2)],[F(1),F(21,20)]):
    e4=e3+extra
    params=(a,n3,n4,e3,e4,s,R)
    assert coefficient(*params,F(1))==1/R
    for i in range(20):
        x,y=F(i,20),F(i+1,20)
        kx,ky=coefficient(*params,x),coefficient(*params,y)
        assert 0<kx<ky<=1/R
        derivative_formula(*params,x)
        Bx,By=retail(n3,n4,e3,e4,s,x),retail(n3,n4,e3,e4,s,y)
        dx3,dy3=e3+(1-x)*s,e3+(1-y)*s
        dx4,dy4=e4+(1-x)*s,e4+(1-y)*s
        difference=(y-x)*(Bx*By+a*(n3*e3/(dx3*dy3)+n4*e4/(dx4*dy4)))/(
            R*(a+Bx)*(a+By))
        assert ky-kx==difference, "FAIL: finite difference identity"
        checked_pairs+=1

market_cases=0
for mu,theta,kappa,delta2 in product(
        [F(0),F(1,10),F(1,2),F(1)],[F(-2),F(1)],
        [F(-2),F(-1),F(0),F(1)],[F(-1),F(0),F(2)]):
    if mu==0 and kappa!=0: continue
    if mu==1 and kappa!=theta: continue
    P0,R=F(18),F(21,20)
    masses=[F(1,4)]*4
    gs=[F(1),F(1,2),F(1),F(2)]
    vs=[F(1),F(2),F(2)-mu,F(3)-mu]
    ms=[P0+theta,P0+theta+F(1,2),P0+kappa,P0+kappa+delta2]
    hs=[lam/(g*v) for lam,g,v in zip(masses,gs,vs)]
    H=sum(hs)
    price=(sum(h*m for h,m in zip(hs,ms))-1)/(R*H)
    qs=[(m-R*price)/(g*v) for m,g,v in zip(ms,gs,vs)]
    assert sum(lam*q for lam,q in zip(masses,qs))==1
    for m,g,v,q in zip(ms,gs,vs,qs):
        assert m-R*price-g*v*q==0
        def ce(z): return z*(m-R*price)-g*v*z*z/2
        for offset in [F(-2),F(-1,3),F(1,3),F(2)]:
            assert ce(q)>ce(q+offset)
    for i in range(4):
        bump=F(1,100)
        hh=hs.copy()
        hh[i]+=bump
        changed=(sum(h*m for h,m in zip(hh,ms))-1)/(R*sum(hh))
        assert changed-price==bump*(ms[i]-R*price)/(R*(H+bump))
    market_cases+=1

figure=r"""% Generated from checked data. No screenshots of published figures.
\begin{tikzpicture}
\begin{axis}[
 width=10.6cm,height=5.7cm,
 xmin=0,xmax=1,ymin=0.45,ymax=1.03,
 xlabel={Transparencia $\mu$},ylabel={Sensibilidad informativa $\mathcal K$},
 tick label style={font=\small},label style={font=\small},
 legend style={font=\scriptsize,draw=none,at={(0.02,0.98)},anchor=north west},
 grid=major,grid style={gray!15},
]
\addplot[blue!70!black,very thick] table[x=mu,y=corrected,col sep=comma]{../code/output/information.csv};
\addlegendentry{Corrección: precio esperado}
\addplot[orange!85!black,thick] table[x=mu,y=printed,col sep=comma]{../code/output/information.csv};
\addlegendentry{Fórmula publicada}
\addplot[black,dashed] table[x=mu,y=baseline,col sep=comma]{../code/output/information.csv};
\addlegendentry{Modelo básico}
\end{axis}
\end{tikzpicture}
"""
(FIGURES/"information.tex").write_text(figure,encoding="utf-8")
report={"status":"PASS","comparison":"expected coefficient for corrected model",
        "baseline_exact":str(baseline),"printed_mu_01_exact":str(printed(F(1,10))),
        "corrected_mu_01_exact":str(coefficient(*baseparams,F(1,10))),
        "comparative_static_pairs":checked_pairs,"market_cases":market_cases,
        "formal_probability_bridge":"not checked by this script or preliminary Lean",
        "date":"2026-10-08"}
(OUTPUT/"verification.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
print(json.dumps(report,indent=2))
print("PASS: exact counterexample, four-group comparative statics, FOCs, clearing, figure data.")
