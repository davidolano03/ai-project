import AppliedModelingLib.Foundations.Probability.GaussianModels
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic

/-!
# Source model for Olano (2026)

This file gives the concrete Gaussian signal, CARA objective, four-group
market, and endogenous-sentiment definitions used by the five source
propositions.  The notation follows the pinned manuscript: `e` is final-payoff
variance, `s` is fundamental variance, `t` is public-signal noise variance,
`mu = s / (s + t)`, public information is `kappa = mu * (theta + eta)`, and
hidden information is `xi = theta - kappa`.
-/

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory

namespace Olano26Transparencia

noncomputable section

/-! ## Gaussian public information -/

/-- Interior transparency weight, equation (mu) of the source. -/
def transparencyWeight (s t : ℝ) : ℝ := s / (s + t)

/-- Independent fundamental/noise law `N(0,s) x N(0,t)`. -/
abbrev informationLaw (s t : ℝ) : Measure (ℝ × ℝ) :=
  AppliedModelingLib.Probability.gaussianSignalPair 0 s t

/-- Fundamental innovation on the product probability space. -/
abbrev fundamental : ℝ × ℝ → ℝ := Prod.fst

/-- Public report `y = theta + eta`. -/
abbrev publicReport : ℝ × ℝ → ℝ :=
  AppliedModelingLib.Probability.gaussianSignalScore

/-- Public posterior-mean component `kappa = mu * y`. -/
def publicComponent (s t : ℝ) : ℝ × ℝ → ℝ :=
  fun pair => transparencyWeight s t * publicReport pair

/-- Hidden residual `xi = theta - kappa`. -/
def hiddenComponent (s t : ℝ) : ℝ × ℝ → ℝ :=
  fun pair => fundamental pair - publicComponent s t pair

/-- Residual posterior variance `s*t/(s+t) = (1-mu)*s`. -/
def residualVariance (s t : ℝ) : ℝ := s * t / (s + t)

/-- Posterior mean at a realised public report. -/
def posteriorMean (s t report : ℝ) : ℝ :=
  transparencyWeight s t * report

/-- No-signal endpoint definitions. -/
def noSignalPublic (_theta : ℝ) : ℝ := 0
def noSignalHidden (theta : ℝ) : ℝ := theta

/-- Full-signal endpoint definitions. -/
def fullSignalPublic (theta : ℝ) : ℝ := theta
def fullSignalHidden (_theta : ℝ) : ℝ := 0

/-! ## CARA choice -/

/-- Terminal wealth as a function of the Gaussian payoff draw. -/
def terminalWealth (c R price position payoff : ℝ) : ℝ :=
  c + position * (payoff - R * price)

/-- Expected CARA utility under a literal Gaussian payoff belief `N(mean,variance)`. -/
def expectedCARAUtility
    (mean variance c R price riskAversion position : ℝ) : ℝ :=
  ∫ payoff,
    -Real.exp (-riskAversion *
      terminalWealth c R price position payoff)
    ∂ProbabilityTheory.gaussianReal mean variance.toNNReal

/-- Gaussian CARA certainty equivalent, equation (ce). -/
def certaintyEquivalent
    (mean variance c R price riskAversion position : ℝ) : ℝ :=
  c + position * (mean - R * price) -
    riskAversion * variance * position ^ 2 / 2

/-- The source demand formula. -/
def optimalDemand (mean variance R price riskAversion : ℝ) : ℝ :=
  (mean - R * price) / (riskAversion * variance)

/-! ## Four-group market -/

/-- Primitive fixed-sentiment parameters in Assumptions 1, 3, and 4. -/
structure FixedMarket where
  P0 : ℝ
  R : ℝ
  gamma : ℝ
  b : ℝ
  e : ℝ
  s : ℝ
  tau1Sq : ℝ
  tau2Sq : ℝ
  lambda1 : ℝ
  lambda2 : ℝ
  lambda3 : ℝ
  lambda4 : ℝ
  rho1 : ℝ
  rho2 : ℝ
  delta1 : ℝ
  delta2 : ℝ
  R_pos : 0 < R
  gamma_pos : 0 < gamma
  b_pos : 0 < b
  e_pos : 0 < e
  s_pos : 0 < s
  tau1Sq_nonneg : 0 ≤ tau1Sq
  tau2Sq_nonneg : 0 ≤ tau2Sq
  lambda1_pos : 0 < lambda1
  lambda2_pos : 0 < lambda2
  lambda3_pos : 0 < lambda3
  lambda4_pos : 0 < lambda4
  lambda_sum : lambda1 + lambda2 + lambda3 + lambda4 = 1

/-- Group-specific CARA coefficients. -/
def FixedMarket.g1 (M : FixedMarket) : ℝ := M.gamma
def FixedMarket.g2 (M : FixedMarket) : ℝ := M.gamma * Real.exp (-M.b * M.rho1)
def FixedMarket.g3 (M : FixedMarket) : ℝ := M.gamma
def FixedMarket.g4 (M : FixedMarket) : ℝ := M.gamma * Real.exp (-M.b * M.rho2)

/-- Residual fundamental uncertainty at transparency `mu`. -/
def FixedMarket.d (M : FixedMarket) (mu : ℝ) : ℝ := (1 - mu) * M.s

/-- Four subjective payoff variances. -/
def FixedMarket.v1 (M : FixedMarket) : ℝ := M.e
def FixedMarket.v2 (M : FixedMarket) : ℝ := M.e + M.tau1Sq
def FixedMarket.v3 (M : FixedMarket) (mu : ℝ) : ℝ := M.e + M.d mu
def FixedMarket.v4 (M : FixedMarket) (mu : ℝ) : ℝ := M.e + M.d mu + M.tau2Sq

/-- Demand weights `h_i = lambda_i/(g_i v_i)`. -/
def FixedMarket.h1 (M : FixedMarket) : ℝ := M.lambda1 / (M.g1 * M.v1)
def FixedMarket.h2 (M : FixedMarket) : ℝ := M.lambda2 / (M.g2 * M.v2)
def FixedMarket.h3 (M : FixedMarket) (mu : ℝ) : ℝ :=
  M.lambda3 / (M.g3 * M.v3 mu)
def FixedMarket.h4 (M : FixedMarket) (mu : ℝ) : ℝ :=
  M.lambda4 / (M.g4 * M.v4 mu)

def FixedMarket.a (M : FixedMarket) : ℝ := M.h1 + M.h2
def FixedMarket.B (M : FixedMarket) (mu : ℝ) : ℝ := M.h3 mu + M.h4 mu
def FixedMarket.H (M : FixedMarket) (mu : ℝ) : ℝ := M.a + M.B mu

/-- Four group means, in source order. -/
def FixedMarket.m1 (M : FixedMarket) (theta : ℝ) : ℝ := M.P0 + theta
def FixedMarket.m2 (M : FixedMarket) (theta : ℝ) : ℝ := M.P0 + theta + M.delta1
def FixedMarket.m3 (M : FixedMarket) (kappa : ℝ) : ℝ := M.P0 + kappa
def FixedMarket.m4 (M : FixedMarket) (kappa : ℝ) : ℝ := M.P0 + kappa + M.delta2

/-- Market-clearing price, equation (price). -/
def FixedMarket.equilibriumPrice
    (M : FixedMarket) (mu theta kappa : ℝ) : ℝ :=
  (M.H mu * M.P0 + M.a * theta + M.B mu * kappa +
      M.h2 * M.delta1 + M.h4 mu * M.delta2 - 1) /
    (M.R * M.H mu)

/-- Constant part of expected price at transparency `mu`. -/
def FixedMarket.priceIntercept (M : FixedMarket) (mu : ℝ) : ℝ :=
  (M.H mu * M.P0 + M.h2 * M.delta1 + M.h4 mu * M.delta2 - 1) /
    (M.R * M.H mu)

/-- Expected-price sensitivity `K(mu)`, equation (K). -/
def FixedMarket.sensitivity (M : FixedMarket) (mu : ℝ) : ℝ :=
  (M.a + mu * M.B mu) / (M.R * (M.a + M.B mu))

/-- Aggregate demand at a candidate price, using the four source beliefs. -/
def FixedMarket.aggregateDemand
    (M : FixedMarket) (mu theta kappa price : ℝ) : ℝ :=
  M.lambda1 * optimalDemand (M.m1 theta) (M.v1) M.R price M.g1 +
  M.lambda2 * optimalDemand (M.m2 theta) (M.v2) M.R price M.g2 +
  M.lambda3 * optimalDemand (M.m3 kappa) (M.v3 mu) M.R price M.g3 +
  M.lambda4 * optimalDemand (M.m4 kappa) (M.v4 mu) M.R price M.g4

/-- Expected price conditional on a fixed fundamental, integrating only public noise. -/
def FixedMarket.expectedPriceGivenFundamental
    (M : FixedMarket) (t theta : ℝ) : ℝ :=
  let mu := transparencyWeight M.s t
  ∫ eta,
    M.equilibriumPrice mu theta (mu * (theta + eta))
    ∂ProbabilityTheory.gaussianReal 0 t.toNNReal

/-! ## Endogenous sentiment -/

/-- Source extension in which the two sentiment states vary with transparency. -/
structure EndogenousMarket where
  P0 : ℝ
  R : ℝ
  gamma : ℝ
  b : ℝ
  e : ℝ
  s : ℝ
  tau1Sq : ℝ
  tau2Sq : ℝ
  lambda1 : ℝ
  lambda2 : ℝ
  lambda3 : ℝ
  lambda4 : ℝ
  delta1 : ℝ
  delta2 : ℝ
  rho1 : ℝ → ℝ
  rho2 : ℝ → ℝ
  rho1_differentiableOn : DifferentiableOn ℝ rho1 (Set.Icc (0 : ℝ) 1)
  rho2_differentiableOn : DifferentiableOn ℝ rho2 (Set.Icc (0 : ℝ) 1)
  R_pos : 0 < R
  gamma_pos : 0 < gamma
  b_pos : 0 < b
  e_pos : 0 < e
  s_pos : 0 < s
  tau1Sq_nonneg : 0 ≤ tau1Sq
  tau2Sq_nonneg : 0 ≤ tau2Sq
  lambda1_pos : 0 < lambda1
  lambda2_pos : 0 < lambda2
  lambda3_pos : 0 < lambda3
  lambda4_pos : 0 < lambda4
  lambda_sum : lambda1 + lambda2 + lambda3 + lambda4 = 1

def EndogenousMarket.e3 (M : EndogenousMarket) : ℝ := M.e
def EndogenousMarket.e4 (M : EndogenousMarket) : ℝ := M.e + M.tau2Sq
def EndogenousMarket.d3 (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.e3 + (1 - mu) * M.s
def EndogenousMarket.d4 (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.e4 + (1 - mu) * M.s
def EndogenousMarket.n3 (M : EndogenousMarket) : ℝ := M.lambda3 / M.gamma
def EndogenousMarket.n4 (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  (M.lambda4 / M.gamma) * Real.exp (M.b * M.rho2 mu)
def EndogenousMarket.a (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.lambda1 / (M.gamma * M.e) +
    (M.lambda2 / (M.gamma * (M.e + M.tau1Sq))) *
      Real.exp (M.b * M.rho1 mu)
def EndogenousMarket.B (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.n3 / M.d3 mu + M.n4 mu / M.d4 mu
def EndogenousMarket.aPrime (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.b * derivWithin M.rho1 (Set.Icc (0 : ℝ) 1) mu *
    ((M.lambda2 / (M.gamma * (M.e + M.tau1Sq))) *
      Real.exp (M.b * M.rho1 mu))
def EndogenousMarket.n4Prime (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.b * derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu * M.n4 mu
def EndogenousMarket.BPrime (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.s * M.n3 / M.d3 mu ^ 2 +
    M.s * M.n4 mu / M.d4 mu ^ 2 + M.n4Prime mu / M.d4 mu
def EndogenousMarket.sensitivity (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  (M.a mu + mu * M.B mu) /
    (M.R * (M.a mu + M.B mu))

/-- The source derivative numerator in Proposition 5(i). -/
def endogenousDerivativeNumerator
    (mu a a' B B' : ℝ) : ℝ :=
  B * (a + B) - (1 - mu) * (a * B' - B * a')

/-- The source bracket in Proposition 5(iii). -/
def endogenousRetailBracket
    (M : EndogenousMarket) (mu : ℝ) : ℝ :=
  M.B mu ^ 2 + M.a mu *
    (M.n3 * M.e3 / M.d3 mu ^ 2 +
      M.n4 mu / M.d4 mu *
        (M.e4 / M.d4 mu - (1 - mu) * M.b *
          derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu))

/-! Exact counter-trajectory objects from Proposition 5(iv). -/

def counterLogTrajectoryN4 (b c mu : ℝ) : ℝ :=
  (1 / 4 : ℝ) * Real.exp (b * (b⁻¹ * Real.log (1 + c * mu)))

def counterLogTrajectoryB (b c mu : ℝ) : ℝ :=
  (1 / 4 : ℝ) / (2 - mu) + counterLogTrajectoryN4 b c mu / (3 - mu)

def counterLogTrajectorySensitivity (b c mu : ℝ) : ℝ :=
  ((3 / 8 : ℝ) + mu * counterLogTrajectoryB b c mu) /
    ((3 / 8 : ℝ) + counterLogTrajectoryB b c mu)

def counterTrajectoryB (c mu : ℝ) : ℝ :=
  (1 / 4 : ℝ) / (2 - mu) + ((1 / 4 : ℝ) * (1 + c * mu)) / (3 - mu)

def counterTrajectorySensitivity (c mu : ℝ) : ℝ :=
  ((3 / 8 : ℝ) + mu * counterTrajectoryB c mu) /
    ((3 / 8 : ℝ) + counterTrajectoryB c mu)

end

end Olano26Transparencia
