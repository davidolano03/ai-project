import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
Preliminary topic-presentation result: four-group corrected transparency.
Institutional groups are pooled only in the constant a = h1+h2.
Retail groups remain distinct: masses/aversions n3,n4 and residual variances e3,e4.
The stochastic bridge E[kappa | theta, rho] = mu * theta is explained in the
proposal and assumed by its interpretation, NOT proved by this algebraic file.
Conditions: fixed sentiment states, biases, masses and total information variance.
No assumption asserts the conclusion K(x)<K(y).
-/

namespace OlanoTopic
noncomputable section

def retailWeight (n e t mu : ℝ) : ℝ := n / (e + (1 - mu) * t)

def retailTotal (n3 n4 e3 e4 t mu : ℝ) : ℝ :=
  retailWeight n3 e3 t mu + retailWeight n4 e4 t mu

def informationCoefficient (a n3 n4 e3 e4 t R mu : ℝ) : ℝ :=
  (a + mu * retailTotal n3 n4 e3 e4 t mu) /
    (R * (a + retailTotal n3 n4 e3 e4 t mu))

theorem retail_weight_positive (n e t mu : ℝ)
    (hn : 0 < n) (he : 0 < e) (ht : 0 ≤ t) (hmu : mu ≤ 1) :
    0 < retailWeight n e t mu := by
  unfold retailWeight
  have hm : 0 ≤ 1 - mu := by linarith
  positivity

/-- Less unobserved information reduces the residual-information-weighted demand. -/
theorem residual_weight_decreases (n e t x y : ℝ)
    (hn : 0 < n) (he : 0 < e) (ht : 0 ≤ t)
    (hxy : x < y) (hy : y ≤ 1) :
    (1 - y) * retailWeight n e t y <
      (1 - x) * retailWeight n e t x := by
  have hx0 : 0 ≤ 1 - x := by linarith
  have hy0 : 0 ≤ 1 - y := by linarith
  have hdx : 0 < e + (1 - x) * t := by positivity
  have hdy : 0 < e + (1 - y) * t := by positivity
  unfold retailWeight
  rw [← mul_div_assoc, ← mul_div_assoc]
  apply (div_lt_div_iff₀ hdy hdx).2
  have hid : (1 - x) * n * (e + (1 - y) * t) -
      (1 - y) * n * (e + (1 - x) * t) = n * e * (y - x) := by ring
  have hp : 0 < n * e * (y - x) := by
    have hdiff : 0 < y - x := by linarith
    positivity
  linarith

/-- Strict increase for the corrected expected information coefficient, four groups. -/
theorem four_group_information_increases (a n3 n4 e3 e4 t R x y : ℝ)
    (ha : 0 < a) (hn3 : 0 < n3) (hn4 : 0 < n4)
    (he3 : 0 < e3) (he4 : 0 < e4) (ht : 0 ≤ t) (hR : 0 < R)
    (hxy : x < y) (hy1 : y ≤ 1) :
    informationCoefficient a n3 n4 e3 e4 t R x <
      informationCoefficient a n3 n4 e3 e4 t R y := by
  have hx1 : x ≤ 1 := by linarith
  have hbx : 0 < retailTotal n3 n4 e3 e4 t x := by
    unfold retailTotal
    exact add_pos (retail_weight_positive n3 e3 t x hn3 he3 ht hx1)
      (retail_weight_positive n4 e4 t x hn4 he4 ht hx1)
  have hby : 0 < retailTotal n3 n4 e3 e4 t y := by
    unfold retailTotal
    exact add_pos (retail_weight_positive n3 e3 t y hn3 he3 ht hy1)
      (retail_weight_positive n4 e4 t y hn4 he4 ht hy1)
  have hr3 := residual_weight_decreases n3 e3 t x y hn3 he3 ht hxy hy1
  have hr4 := residual_weight_decreases n4 e4 t x y hn4 he4 ht hxy hy1
  have hres : (1 - y) * retailTotal n3 n4 e3 e4 t y <
      (1 - x) * retailTotal n3 n4 e3 e4 t x := by
    unfold retailTotal
    rw [mul_add, mul_add]
    exact add_lt_add hr3 hr4
  unfold informationCoefficient
  apply (div_lt_div_iff₀ (by positivity : 0 < R * (a + retailTotal n3 n4 e3 e4 t x))
    (by positivity : 0 < R * (a + retailTotal n3 n4 e3 e4 t y))).2
  have hid :
      (a + y * retailTotal n3 n4 e3 e4 t y) *
        (R * (a + retailTotal n3 n4 e3 e4 t x)) -
      (a + x * retailTotal n3 n4 e3 e4 t x) *
        (R * (a + retailTotal n3 n4 e3 e4 t y)) =
      R * (a * ((1 - x) * retailTotal n3 n4 e3 e4 t x -
        (1 - y) * retailTotal n3 n4 e3 e4 t y) +
        (y - x) * retailTotal n3 n4 e3 e4 t x *
          retailTotal n3 n4 e3 e4 t y) := by ring
  have hd : 0 < y - x := by linarith
  have hr : 0 < (1 - x) * retailTotal n3 n4 e3 e4 t x -
      (1 - y) * retailTotal n3 n4 e3 e4 t y := by linarith
  have hp : 0 < R * (a * ((1 - x) * retailTotal n3 n4 e3 e4 t x -
      (1 - y) * retailTotal n3 n4 e3 e4 t y) +
      (y - x) * retailTotal n3 n4 e3 e4 t x * retailTotal n3 n4 e3 e4 t y) := by
    positivity
  linarith

theorem full_information_endpoint (a n3 n4 e3 e4 t R : ℝ)
    (ha : 0 < a) (hn3 : 0 < n3) (hn4 : 0 < n4)
    (he3 : 0 < e3) (he4 : 0 < e4) (hR : 0 < R) :
    informationCoefficient a n3 n4 e3 e4 t R 1 = 1 / R := by
  unfold informationCoefficient retailTotal retailWeight
  simp only [sub_self, zero_mul, add_zero, one_mul]
  have hb : 0 < a + n3 / e3 + n4 / e4 := by positivity
  have hb' : a + (n3 / e3 + n4 / e4) ≠ 0 := by
    have : 0 < a + (n3 / e3 + n4 / e4) := by positivity
    exact ne_of_gt this
  field_simp [hb', ne_of_gt hR]

#print axioms retail_weight_positive
#print axioms residual_weight_decreases
#print axioms four_group_information_increases
#print axioms full_information_endpoint

end
end OlanoTopic
