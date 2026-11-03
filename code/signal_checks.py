"""Reproducible checks of the Gaussian signal and CARA reduction.

Exact algebra uses Fraction; simulations and quadrature are diagnostics,
not formal proofs of conditional probability or universal economic claims.
"""
from fractions import Fraction as Q
from itertools import product
from math import exp, sqrt, pi
from random import Random
from statistics import mean, variance, covariance
import csv
import json


def run(output):
    exact_cases = 0
    rows = []
    for s, t in product([Q(1, 2), Q(1), Q(4), Q(100)], repeat=2):
        mu = s / (s + t)
        vk = mu**2 * (s + t)
        vx = (1 - mu)**2 * s + mu**2 * t
        cross = mu * (1 - mu) * s - mu**2 * t
        assert vk == mu * s
        assert vx == (1 - mu) * s == s * t / (s + t)
        assert cross == 0
        assert vk + vx == s
        for x, y in product([Q(-3), Q(0), Q(2)], repeat=2):
            lhs = x*x/s + (y-x)**2/t
            rhs = (s+t)/(s*t)*(x-mu*y)**2+y*y/(s+t)
            assert lhs == rhs, "FAIL: Bayes square"
            exact_cases += 1
        rows.append([float(s), float(t), float(mu), float(vk), float(vx)])
    with (output/"signal.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["s", "t", "mu", "public_variance", "hidden_variance"])
        writer.writerows(rows)
    assert Q(100)/(100+100)*8 == 4
    assert Q(100)*100/(100+100)+4 == 54

    rng = Random(20261102)
    count = 120_000
    theta, public, hidden = [], [], []
    for _ in range(count):
        th, eta = rng.gauss(0, 10), rng.gauss(0, 10)
        k = (th+eta)/2
        theta.append(th)
        public.append(k)
        hidden.append(th-k)
    moments = {
        "theta_variance": variance(theta),
        "public_variance": variance(public),
        "hidden_variance": variance(hidden),
        "public_hidden_covariance": covariance(public, hidden),
        "public_mean": mean(public), "hidden_mean": mean(hidden),
        "public_on_theta_slope": covariance(public, theta)/variance(theta),
    }
    assert abs(moments["theta_variance"]-100) < 2
    assert abs(moments["public_variance"]-50) < 1
    assert abs(moments["hidden_variance"]-50) < 1
    assert abs(moments["public_hidden_covariance"]) < 1
    assert abs(moments["public_mean"]) < .1
    assert abs(moments["hidden_mean"]) < .1
    assert abs(moments["public_on_theta_slope"]-.5) < .015

    # Integrate over Z~N(0,1) on [-12,12], Simpson's rule.
    # Small g and variance make omitted weighted tails negligible here.
    nodes = 6000
    step = 24/nodes
    quadrature_errors = []
    for g, q in product([.1, .4, 1.0], [-2., -.5, 0., 1.5]):
        c, gap, v = 2., .3, .7
        M, V = c+q*gap, q*q*v
        ce = M-g*V/2
        analytic = -exp(-g*M+g*g*V/2)
        assert abs(analytic+exp(-g*ce)) < 1e-13
        def integrand(z):
            return -exp(-g*(M+sqrt(V)*z))*exp(-z*z/2)/sqrt(2*pi)
        total = integrand(-12)+integrand(12)
        total += sum((4 if i % 2 else 2)*integrand(-12+i*step)
                     for i in range(1, nodes))
        numerical = total*step/3
        error = abs(numerical-analytic)/max(1., abs(analytic))
        assert error < 1e-10, "FAIL: CARA normal integral"
        quadrature_errors.append(error)
    report = {
        "status": "PASS",
        "exact_posterior_cases": exact_cases,
        "exact_signal_parameter_cases": len(rows),
        "monte_carlo_seed": 20261102, "monte_carlo_draws": count,
        "monte_carlo_parameters": {"s": 100, "t": 100, "mu": .5},
        "moments": moments,
        "moment_tolerances": {"relative_variance": .02,
                             "absolute_covariance": 1.,
                             "absolute_mean": .1,
                             "absolute_slope": .015},
        "cara_quadrature_cases": len(quadrature_errors),
        "cara_max_relative_error": max(quadrature_errors),
        "cara_tolerance": 1e-10,
        "limitations": "Finite checks and simulation only; separate formal proof coverage is documented in lean/README.md.",
    }
    (output/"signal-verification.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8")
    return report
