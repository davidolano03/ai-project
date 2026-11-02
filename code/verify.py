"""Reproduce topic evidence with exact rational arithmetic.
Run: python code/verify.py. Graph: native PGFPlots LaTeX from the checked CSV.
This numerical/algebraic audit does not formalize Gaussian conditioning.
"""
from pathlib import Path
from fractions import Fraction as F
from itertools import product
import csv
import json
from signal_checks import run as run_signal_checks

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
# The printed coefficient is increasing but starts below the baseline:
# it stays below on [0, 0.26] and crosses it before 0.27.
assert all(printed(F(i,100))<printed(F(i+1,100)) for i in range(100))
assert all(printed(F(i,100))<baseline for i in range(27)), "FAIL: failure interval grid"
assert printed(F(27,100))>baseline
# The continuous-interval claim additionally uses the monotonicity proof
# in the paper; a finite grid alone is not a proof over every real mu.
crossing_low,crossing_high=F(2649199,10**7),F(2649200,10**7)
assert printed(crossing_low)<baseline<printed(crossing_high)
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

# ---------------------------------------------------------------------------
# Additions for the final paper (Claude, 2026-11-02).
# (a) Expected-price bridge by Monte Carlo: kappa | theta ~ N(mu theta, mu(1-mu)s).
# (b) Sign of the weight channel: dK/dB < 0 for mu < 1.
# (c) Extension: sentiment that responds to transparency (Proposition 5).
# ---------------------------------------------------------------------------
import math
import random

rng=random.Random(20261102)

def realized_price(P0,R,theta,kappa,mu,s,se,t1,t2,lam,gam,b,r1,r2,d1,d2):
    g=[gam,gam*math.exp(-b*r1),gam,gam*math.exp(-b*r2)]
    v=[se,se+t1,se+(1-mu)*s,se+(1-mu)*s+t2]
    m=[P0+theta,P0+theta+d1,P0+kappa,P0+kappa+d2]
    h=[l/(gi*vi) for l,gi,vi in zip(lam,g,v)]
    return (sum(hi*mi for hi,mi in zip(h,m))-1)/(R*sum(h)),h

bridge_cases=[]
for mu in [0.25,0.6]:
    P0,R,s,se,t1,t2=18.0,1.05,1.0,0.5,0.1,0.3
    lam=[0.04,0.16,0.16,0.64]; gam,b,r1,r2,d1,d2=1.0,0.5,0.4,-0.2,0.2,0.3
    sd=math.sqrt(mu*(1-mu)*s); n=100000
    avg={}
    for theta in [-1.0,1.0]:
        tot=0.0
        for _ in range(n):
            k=rng.gauss(mu*theta,sd)
            tot+=realized_price(P0,R,theta,k,mu,s,se,t1,t2,lam,gam,b,r1,r2,d1,d2)[0]
        avg[theta]=tot/n
    _,h=realized_price(P0,R,0,0,mu,s,se,t1,t2,lam,gam,b,r1,r2,d1,d2)
    a_,B_=h[0]+h[1],h[2]+h[3]
    K_formula=(a_+mu*B_)/(R*(a_+B_))
    K_mc=(avg[1.0]-avg[-1.0])/2
    assert abs(K_mc-K_formula)<0.01, "FAIL: expected-price sensitivity bridge"
    bridge_cases.append({"mu":mu,"draws_per_theta":n,"K_formula":round(K_formula,5),
                         "K_monte_carlo":round(K_mc,5)})

# (b) weight channel: holding mu fixed, a larger retail weight lowers K.
for a_,B_,mu in product([F(1,8),F(1),F(4)],[F(1,8),F(1),F(3)],[F(0),F(1,2),F(9,10)]):
    dB=F(1,1000)
    K1=(a_+mu*B_)/(a_+B_); K2=(a_+mu*(B_+dB))/(a_+B_+dB)
    assert K2<K1, "FAIL: weight channel sign"
    assert (K2-K1)/dB==-a_*(1-mu)/((a_+B_)*(a_+B_+dB))

# (c) Proposition 5 with rational paths n4(mu)=n4(0)(1+c mu), i.e.
# rho2(mu)=rho2(0)+ln(1+c mu)/b, and institutional weight a(mu)=a0(1+ca mu).
# With the baseline h1=1/4 and h2(0)=1/8, the latter comes from
# rho1(mu)=ln(1+3*ca*mu)/b. Thus the four monotone paths have rho1'>=0.
def K_endo(mu,c,a0=F(3,8),n3=F(1,4),n40=F(1,4),e3=F(1),e4=F(2),s=F(1),R=F(1),ca=F(0)):
    a=a0*(1+ca*mu); n4=n40*(1+c*mu)
    B=n3/(e3+(1-mu)*s)+n4/(e4+(1-mu)*s)
    return (a+mu*B)/(R*(a+B))

def Kprime_endo(mu,c,a0=F(3,8),n3=F(1,4),n40=F(1,4),e3=F(1),e4=F(2),s=F(1),R=F(1),ca=F(0)):
    a=a0*(1+ca*mu); ap=a0*ca
    n4=n40*(1+c*mu); n4p=n40*c
    d3,d4=e3+(1-mu)*s,e4+(1-mu)*s
    B=n3/d3+n4/d4
    Bp=s*(n3/d3**2+n4/d4**2)+n4p/d4
    general=(B*(a+B)-(1-mu)*(a*Bp-B*ap))/(R*(a+B)**2)
    quotient=((ap+B+mu*Bp)*(a+B)-(a+mu*B)*(ap+Bp))/(R*(a+B)**2)
    decomposed=(B**2+a*(n3*e3/d3**2+n4*e4/d4**2)
                -(1-mu)*a*n4p/d4+(1-mu)*B*ap)/(R*(a+B)**2)
    assert general==quotient==decomposed, "FAIL: Proposition 5(i)-(ii) exact identities"
    if ca==0:
        brho=n4p/n4
        exact=(B**2+a*(n3*e3/d3**2+(n4/d4)*(e4/d4-(1-mu)*brho)))/(R*(a+B)**2)
        assert general==exact, "FAIL: Proposition 5(iii) decomposition"
    return general

for c in [F(-1,2),F(0),F(1),F(5)]:
    for mu in [F(1,10),F(1,2),F(9,10)]:
        hstep=F(1,10**6)
        dq=(K_endo(mu+hstep,c)-K_endo(mu-hstep,c))/(2*hstep)
        assert abs(dq-Kprime_endo(mu,c))<F(1,10**8), "FAIL: Proposition 5(i)"
monotone_paths=0
for c,ca in [(F(-1,2),F(0)),(F(-9,10),F(0)),(F(0),F(1)),(F(-1,2),F(2))]:
    vals=[K_endo(F(i,50),c,ca=ca) for i in range(51)]
    assert all(x<y for x,y in zip(vals,vals[1:])), "FAIL: Proposition 5(ii)"
    assert all(Kprime_endo(F(i,50),c,ca=ca)>0 for i in range(51))
    assert vals[-1]==1
    monotone_paths+=1
threshold=F(101,36)
threshold_sum=F(25,576)+F(3,128)+F(1,48)
assert threshold_sum==F(101,1152)
assert 32*threshold_sum==threshold
for c in [F(-1,2),F(0),threshold,F(5)]:
    assert Kprime_endo(F(0),c)==(101-36*c)/392
assert Kprime_endo(F(0),threshold)==0, "FAIL: threshold c*=101/36"
assert Kprime_endo(F(0),threshold-F(1,100))>0
assert Kprime_endo(F(0),threshold+F(1,100))<0
assert K_endo(F(1,10),F(5))<K_endo(F(0),F(5))==baseline, "FAIL: Proposition 5(iv)"
assert K_endo(F(1,10),F(5))==F(1768,2803)
assert K_endo(F(1),F(5))==1
reversal=str(K_endo(F(1,10),F(5)))

def gap_closed(mu,c=F(0)):
    k0,k1=K_endo(F(0),c),K_endo(F(1),c)
    return (K_endo(mu,c)-k0)/(k1-k0)
gap_half=gap_closed(F(1,2))
assert gap_half==F(23,55)

with (OUTPUT/"endogenous.csv").open("w",newline="",encoding="utf-8") as f:
    writer=csv.writer(f)
    writer.writerow(["mu","fixed","calming","threshold","optimism"])
    for i in range(101):
        mu=F(i,100)
        writer.writerow([float(mu),float(K_endo(mu,F(0))),float(K_endo(mu,F(-1,2))),
                         float(K_endo(mu,threshold)),float(K_endo(mu,F(5)))])

figure2=r"""% Generated from checked data (code/verify.py, sentiment extension).
\begin{tikzpicture}
\begin{axis}[
 width=10.6cm,height=5.9cm,
 xmin=0,xmax=1,ymin=0.45,ymax=1.03,
 xlabel={Transparencia $\mu$},ylabel={$\mathcal K(\mu)$},
 tick label style={font=\small},label style={font=\small},
 legend columns=2,legend style={font=\scriptsize,draw=none,at={(0.5,-0.3)},anchor=north,/tikz/every even column/.append style={column sep=8pt}},
 grid=major,grid style={gray!15},
]
\addplot[blue!70!black,very thick] table[x=mu,y=fixed,col sep=comma]{../code/output/endogenous.csv};
\addlegendentry{Sentimiento fijo ($c=0$)}
\addplot[teal!70!black,thick,dotted] table[x=mu,y=calming,col sep=comma]{../code/output/endogenous.csv};
\addlegendentry{Menor optimismo ($c=-1/2$)}
\addplot[gray,thick,dashed] table[x=mu,y=threshold,col sep=comma]{../code/output/endogenous.csv};
\addlegendentry{Umbral ($c=101/36$)}
\addplot[red!70!black,thick] table[x=mu,y=optimism,col sep=comma]{../code/output/endogenous.csv};
\addlegendentry{Optimismo rápido ($c=5$)}
\end{axis}
\end{tikzpicture}
"""
(FIGURES/"endogenous.tex").write_text(figure2,encoding="utf-8")

signal_report=run_signal_checks(OUTPUT)
report={"status":"PASS","comparison":"expected coefficient for corrected model",
        "baseline_exact":str(baseline),"printed_mu_01_exact":str(printed(F(1,10))),
        "corrected_mu_01_exact":str(coefficient(*baseparams,F(1,10))),
        "printed_increasing_but_below_baseline_up_to":"0.26","comparative_static_pairs":checked_pairs,"market_cases":market_cases,
        "formal_probability_bridge":"Monte Carlo diagnostics only; not formally proved by preliminary Lean",
        "signal_and_cara":signal_report,
        "expected_price_bridge_monte_carlo":bridge_cases,
        "sentiment_extension":{"monotone_paths":monotone_paths,"threshold_c_star":str(threshold),
                               "threshold_sum":str(threshold_sum),
                               "initial_derivative_with_c_5":str(Kprime_endo(F(0),F(5))),
                               "exact_quotient_and_numerator_decomposition":True,
                               "K_at_0_1_with_c_5":reversal,"gap_closed_at_one_half":str(gap_half)},
        "printed_baseline_crossing_bracket":[str(crossing_low),str(crossing_high)],
        "date":"2026-11-02"}
(OUTPUT/"verification.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
print(json.dumps(report,indent=2))
print("PASS: counterexample and failure interval, four-group comparative statics, FOCs, clearing, signal and CARA checks, expected-price Monte Carlo, sentiment extension, figures.")
