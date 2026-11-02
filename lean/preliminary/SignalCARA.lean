import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
Algebraic steps for the final-presentation manuscript, 2026-11-02.
These identities are not a probability-theoretic formalization of Bayes,
conditional expectation, Gaussian independence, or the Gaussian integral.
-/
namespace OlanoSignal
noncomputable section

theorem posterior_square (s t x y : ℝ)
    (hs : s ≠ 0) (ht : t ≠ 0) (hst : s + t ≠ 0) :
    x ^ 2 / s + (y - x) ^ 2 / t =
      (s + t) / (s * t) * (x - s / (s + t) * y) ^ 2 +
        y ^ 2 / (s + t) := by
  field_simp
  ring

theorem public_variance (s t : ℝ) (h : s + t ≠ 0) :
    (s / (s + t)) ^ 2 * (s + t) =
      (s / (s + t)) * s := by
  field_simp

theorem hidden_variance (s t : ℝ) (h : s + t ≠ 0) :
    (1 - s / (s + t)) ^ 2 * s + (s / (s + t)) ^ 2 * t =
      (1 - s / (s + t)) * s := by
  field_simp
  ring

theorem public_hidden_covariance (s t : ℝ) (h : s + t ≠ 0) :
    s / (s + t) * (1 - s / (s + t)) * s -
      (s / (s + t)) ^ 2 * t = 0 := by
  field_simp
  ring

theorem total_variance (s mu : ℝ) :
    mu * s + (1 - mu) * s = s := by ring

theorem cara_normal_exponent (c m R p g v q : ℝ) :
    -g * (c + q * (m - R * p)) + g ^ 2 * (q ^ 2 * v) / 2 =
      -g * (c + q * (m - R * p) - g * v * q ^ 2 / 2) := by ring

theorem gaussian_integral_square (a w M V : ℝ) (hV : V ≠ 0) :
    a * w - (w - M) ^ 2 / (2 * V) =
      -(w - (M + a * V)) ^ 2 / (2 * V) + a * M + a ^ 2 * V / 2 := by
  field_simp
  ring

#print axioms posterior_square
#print axioms public_variance
#print axioms hidden_variance
#print axioms public_hidden_covariance
#print axioms total_variance
#print axioms cara_normal_exponent
#print axioms gaussian_integral_square
end
end OlanoSignal
