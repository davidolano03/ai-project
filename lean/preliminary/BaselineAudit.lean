import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Local algebraic audit of Zhang and Zhang (2023)

Source: Information asymmetry, sentiment interactions, and asset price,
NAJEF 67, 101920. This file checks explicitly transcribed algebraic claims.
It does not formalize Gaussian conditioning, all figures, or the whole paper.
No economic assumption is introduced as a theorem about observed markets.
-/

namespace ZhangAudit

noncomputable section

def certaintyEquivalent (c m R p a q : ℝ) : ℝ :=
  c + q * (m - R * p) - a * q ^ 2 / 2

def demand (m R p a : ℝ) : ℝ := (m - R * p) / a

/-- Completing the square for the mean-variance optimization problem. -/
theorem completion_of_square (c m R p a q : ℝ) (ha : a ≠ 0) :
    certaintyEquivalent c m R p a q =
      certaintyEquivalent c m R p a (demand m R p a) -
        a / 2 * (q - demand m R p a) ^ 2 := by
  unfold certaintyEquivalent demand
  field_simp [ha]
  ring

/-- The FOC solution is a global maximizer when risk-adjusted variance is positive. -/
theorem demand_maximizes (c m R p a q : ℝ) (ha : 0 < a) :
    certaintyEquivalent c m R p a q ≤
      certaintyEquivalent c m R p a (demand m R p a) := by
  rw [completion_of_square c m R p a q (ne_of_gt ha)]
  have hn : 0 ≤ a / 2 * (q - demand m R p a) ^ 2 := by positivity
  linarith

/-- Algebraic FOC, treating beliefs and aversion as fixed during the choice. -/
theorem demand_satisfies_FOC (m R p a : ℝ) (ha : a ≠ 0) :
    m - R * p - a * demand m R p a = 0 := by
  unfold demand
  field_simp [ha]
  ring

/-- Aggregate h-weighted beliefs M, total demand weight H, unit supply. -/
theorem market_clearing (M R H : ℝ) (hR : R ≠ 0) (hH : H ≠ 0) :
    M - R * ((M - 1) / (R * H)) * H = 1 := by
  field_simp [hR, hH]
  ring

/-- Coefficient on private information in the benchmark model, equation (23). -/
def benchmarkCoefficient (h1 h2 h3 h4 R : ℝ) : ℝ :=
  (h1 + h2) / (R * (h1 + h2 + h3 + h4))

/-- The information coefficient lies between zero and the discount factor. -/
theorem information_coefficient_bounds (h1 h2 h3 h4 R : ℝ)
    (h1p : 0 < h1) (h2n : 0 ≤ h2) (h3n : 0 ≤ h3) (h4n : 0 ≤ h4)
    (hRp : 0 < R) :
    0 < benchmarkCoefficient h1 h2 h3 h4 R ∧
      benchmarkCoefficient h1 h2 h3 h4 R ≤ 1 / R := by
  unfold benchmarkCoefficient
  have hsum : 0 < h1 + h2 + h3 + h4 := by linarith
  constructor
  · positivity
  · apply (div_le_iff₀ (mul_pos hRp hsum)).2
    have hid : 1 / R * (R * (h1 + h2 + h3 + h4)) =
        h1 + h2 + h3 + h4 := by field_simp
    rw [hid]
    linarith

/- Counterexample parameters: every lambda = 1/4; gamma = R = 1;
   epsilon, theta and BOTH sentiment variances = 1; actual sentiments = 0.
   Thus institutional weights h1 = 1/4, h2 = 1/8.
   All variances and population weights are strictly positive.
   Retail weights below follow the PRINTED mu^2 variances in (40)-(44).
-/

def counterexampleBaseline : ℝ :=
  benchmarkCoefficient (1 / 4) (1 / 8) (1 / 8) (1 / 12) 1

def printedTransparencyCoefficient (mu : ℝ) : ℝ :=
  let hi := (1 / 4 : ℝ) + 1 / 8
  let hu := (1 / 4 : ℝ) / (1 + mu ^ 2) + (1 / 4 : ℝ) / (2 + mu ^ 2)
  (hi + mu * hu) / (hi + hu)

theorem baseline_value : counterexampleBaseline = 9 / 14 := by
  norm_num [counterexampleBaseline, benchmarkCoefficient]

theorem transparency_zero_value : printedTransparencyCoefficient 0 = 1 / 2 := by
  norm_num [printedTransparencyCoefficient]

/-- Proposition 5(ii), as printed, fails at the included endpoint mu = 0. -/
theorem transparency_zero_counterexample :
    printedTransparencyCoefficient 0 - counterexampleBaseline = -(1 / 7) := by
  norm_num [printedTransparencyCoefficient, counterexampleBaseline, benchmarkCoefficient]

/-- Failure also occurs at a STRICTLY POSITIVE transparency, not only the endpoint. -/
theorem positive_transparency_counterexample :
    0 < (1 / 10 : ℝ) ∧ (1 / 10 : ℝ) < 1 ∧
      printedTransparencyCoefficient (1 / 10) < counterexampleBaseline := by
  norm_num [printedTransparencyCoefficient, counterexampleBaseline, benchmarkCoefficient]

theorem not_universal_transparency_improvement :
    ¬ (∀ mu : ℝ, 0 ≤ mu → mu ≤ 1 →
      counterexampleBaseline < printedTransparencyCoefficient mu) := by
  intro h
  have hx := h (1 / 10) (by norm_num) (by norm_num)
  have hc := positive_transparency_counterexample
  linarith [hc.2.2]

/-- In a deterministic public signal kappa = mu * theta, any nonzero mu reveals theta. -/
theorem scaled_signal_reveals_theta (mu theta : ℝ) (hmu : mu ≠ 0) :
    (mu * theta) / mu = theta := by
  field_simp

/-- A proposed correction: independent public/private components, pooled retail group.
    a = informed demand weight; n = retail mass / aversion; e = residual payoff variance;
    t = total information variance. Retail residual variance is e+(1-mu)*t.
    This algebraic result is for this explicitly stated corrected model only. -/
def correctedCoefficient (a n e t mu : ℝ) : ℝ :=
  (a * (e + (1 - mu) * t) + mu * n) /
    (a * (e + (1 - mu) * t) + n)

theorem corrected_no_information_endpoint (a n e t : ℝ) :
    correctedCoefficient a n e t 0 =
      a * (e + t) / (a * (e + t) + n) := by
  simp [correctedCoefficient]

theorem corrected_full_information_endpoint (a n e t : ℝ)
    (ha : 0 < a) (hn : 0 < n) (he : 0 < e) :
    correctedCoefficient a n e t 1 = 1 := by
  simp only [correctedCoefficient, sub_self, zero_mul, add_zero, one_mul]
  exact div_self (ne_of_gt (by positivity : 0 < a * e + n))

/-- The sign of a finite change is positive in the corrected pooled model. -/
theorem corrected_difference_identity (a n e t x y : ℝ)
    (hx : a * (e + (1 - x) * t) + n ≠ 0)
    (hy : a * (e + (1 - y) * t) + n ≠ 0) :
    correctedCoefficient a n e t y - correctedCoefficient a n e t x =
      n * (a * e + n) * (y - x) /
        ((a * (e + (1 - y) * t) + n) *
          (a * (e + (1 - x) * t) + n)) := by
  unfold correctedCoefficient
  rw [div_sub_div _ _ hy hx]
  congr 1
  ring

theorem corrected_coefficient_increases (a n e t x y : ℝ)
    (ha : 0 < a) (hn : 0 < n) (he : 0 < e) (ht : 0 ≤ t)
    (hxy : x < y) (hy1 : y ≤ 1) :
    correctedCoefficient a n e t x < correctedCoefficient a n e t y := by
  have hxpos : 0 < a * (e + (1 - x) * t) + n := by
    have hxm : 0 ≤ 1 - x := by linarith
    positivity
  have hypos : 0 < a * (e + (1 - y) * t) + n := by
    have hym : 0 ≤ 1 - y := by linarith
    positivity
  have hid := corrected_difference_identity a n e t x y
    (ne_of_gt hxpos) (ne_of_gt hypos)
  have hpos : 0 < n * (a * e + n) * (y - x) /
      ((a * (e + (1 - y) * t) + n) *
        (a * (e + (1 - x) * t) + n)) := by
    have hdiff : 0 < y - x := by linarith
    positivity
  linarith

#print axioms demand_maximizes
#print axioms completion_of_square
#print axioms demand_satisfies_FOC
#print axioms market_clearing
#print axioms information_coefficient_bounds
#print axioms baseline_value
#print axioms transparency_zero_value
#print axioms transparency_zero_counterexample
#print axioms positive_transparency_counterexample
#print axioms not_universal_transparency_improvement
#print axioms scaled_signal_reveals_theta
#print axioms corrected_no_information_endpoint
#print axioms corrected_full_information_endpoint
#print axioms corrected_difference_identity
#print axioms corrected_coefficient_increases

end
end ZhangAudit
