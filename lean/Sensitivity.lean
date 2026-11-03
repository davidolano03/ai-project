import Olano26Transparencia.Model

/-!
# Fixed-sentiment transparency sensitivity

The finite-difference argument in this file is adapted from the author's
read-only preliminary `Transparency.lean` supplied with the pinned source.
That preliminary file proves algebra only.  Here it is connected to the
paper's source model; the probabilistic bridge used by Proposition 3 is proved
separately in `Price.lean`.
-/

namespace Olano26Transparencia

noncomputable section

def retailWeight (n e s mu : ℝ) : ℝ := n / (e + (1 - mu) * s)

def retailTotal (n3 n4 e3 e4 s mu : ℝ) : ℝ :=
  retailWeight n3 e3 s mu + retailWeight n4 e4 s mu

def fixedSensitivity
    (a n3 n4 e3 e4 s R mu : ℝ) : ℝ :=
  (a + mu * retailTotal n3 n4 e3 e4 s mu) /
    (R * (a + retailTotal n3 n4 e3 e4 s mu))

theorem retailWeight_pos (n e s mu : ℝ)
    (hn : 0 < n) (he : 0 < e) (hs : 0 ≤ s) (hmu : mu ≤ 1) :
    0 < retailWeight n e s mu := by
  unfold retailWeight
  have hm : 0 ≤ 1 - mu := by linarith
  positivity

theorem residualRetailWeight_strictAnti (n e s x y : ℝ)
    (hn : 0 < n) (he : 0 < e) (hs : 0 ≤ s)
    (hxy : x < y) (hy : y ≤ 1) :
    (1 - y) * retailWeight n e s y <
      (1 - x) * retailWeight n e s x := by
  have hx0 : 0 ≤ 1 - x := by linarith
  have hy0 : 0 ≤ 1 - y := by linarith
  have hdx : 0 < e + (1 - x) * s := by positivity
  have hdy : 0 < e + (1 - y) * s := by positivity
  unfold retailWeight
  rw [← mul_div_assoc, ← mul_div_assoc]
  apply (div_lt_div_iff₀ hdy hdx).2
  have hid :
      (1 - x) * n * (e + (1 - y) * s) -
        (1 - y) * n * (e + (1 - x) * s) = n * e * (y - x) := by
    ring
  have hdiff : 0 < y - x := by linarith
  have hp : 0 < n * e * (y - x) := by positivity
  linarith

theorem fixedSensitivity_strictMonoOn
    (a n3 n4 e3 e4 s R x y : ℝ)
    (ha : 0 < a) (hn3 : 0 < n3) (hn4 : 0 < n4)
    (he3 : 0 < e3) (he4 : 0 < e4) (hs : 0 ≤ s) (hR : 0 < R)
    (hx : 0 ≤ x) (hxy : x < y) (hy : y ≤ 1) :
    fixedSensitivity a n3 n4 e3 e4 s R x <
      fixedSensitivity a n3 n4 e3 e4 s R y := by
  have hx1 : x ≤ 1 := by linarith
  have hbx : 0 < retailTotal n3 n4 e3 e4 s x := by
    exact add_pos
      (retailWeight_pos n3 e3 s x hn3 he3 hs hx1)
      (retailWeight_pos n4 e4 s x hn4 he4 hs hx1)
  have hby : 0 < retailTotal n3 n4 e3 e4 s y := by
    exact add_pos
      (retailWeight_pos n3 e3 s y hn3 he3 hs hy)
      (retailWeight_pos n4 e4 s y hn4 he4 hs hy)
  have hr3 := residualRetailWeight_strictAnti n3 e3 s x y hn3 he3 hs hxy hy
  have hr4 := residualRetailWeight_strictAnti n4 e4 s x y hn4 he4 hs hxy hy
  have hres :
      (1 - y) * retailTotal n3 n4 e3 e4 s y <
        (1 - x) * retailTotal n3 n4 e3 e4 s x := by
    unfold retailTotal
    rw [mul_add, mul_add]
    exact add_lt_add hr3 hr4
  unfold fixedSensitivity
  apply (div_lt_div_iff₀
    (by positivity : 0 < R * (a + retailTotal n3 n4 e3 e4 s x))
    (by positivity : 0 < R * (a + retailTotal n3 n4 e3 e4 s y))).2
  have hid :
      (a + y * retailTotal n3 n4 e3 e4 s y) *
          (R * (a + retailTotal n3 n4 e3 e4 s x)) -
        (a + x * retailTotal n3 n4 e3 e4 s x) *
          (R * (a + retailTotal n3 n4 e3 e4 s y)) =
      R * (a * ((1 - x) * retailTotal n3 n4 e3 e4 s x -
          (1 - y) * retailTotal n3 n4 e3 e4 s y) +
        (y - x) * retailTotal n3 n4 e3 e4 s x *
          retailTotal n3 n4 e3 e4 s y) := by
    ring
  have hd : 0 < y - x := by linarith
  have hr :
      0 < (1 - x) * retailTotal n3 n4 e3 e4 s x -
        (1 - y) * retailTotal n3 n4 e3 e4 s y := by
    linarith
  have hp :
      0 < R * (a * ((1 - x) * retailTotal n3 n4 e3 e4 s x -
          (1 - y) * retailTotal n3 n4 e3 e4 s y) +
        (y - x) * retailTotal n3 n4 e3 e4 s x *
          retailTotal n3 n4 e3 e4 s y) := by
    positivity
  linarith

theorem fixedSensitivity_bounds
    (a n3 n4 e3 e4 s R mu : ℝ)
    (ha : 0 < a) (hn3 : 0 < n3) (hn4 : 0 < n4)
    (he3 : 0 < e3) (he4 : 0 < e4) (hs : 0 ≤ s) (hR : 0 < R)
    (hmu0 : 0 ≤ mu) (hmu1 : mu ≤ 1) :
    0 < fixedSensitivity a n3 n4 e3 e4 s R mu ∧
      fixedSensitivity a n3 n4 e3 e4 s R mu ≤ 1 / R := by
  have hB : 0 < retailTotal n3 n4 e3 e4 s mu := by
    exact add_pos
      (retailWeight_pos n3 e3 s mu hn3 he3 hs hmu1)
      (retailWeight_pos n4 e4 s mu hn4 he4 hs hmu1)
  unfold fixedSensitivity
  constructor
  · have : 0 < a + mu * retailTotal n3 n4 e3 e4 s mu := by positivity
    positivity
  · apply (div_le_iff₀ (by positivity :
        0 < R * (a + retailTotal n3 n4 e3 e4 s mu))).2
    have hnum :
        a + mu * retailTotal n3 n4 e3 e4 s mu ≤
          a + retailTotal n3 n4 e3 e4 s mu := by
      nlinarith
    calc
      a + mu * retailTotal n3 n4 e3 e4 s mu
          ≤ a + retailTotal n3 n4 e3 e4 s mu := hnum
      _ = (1 / R) * (R * (a + retailTotal n3 n4 e3 e4 s mu)) := by
        field_simp

theorem fixedSensitivity_fullInformation
    (a n3 n4 e3 e4 s R : ℝ)
    (ha : 0 < a) (hn3 : 0 < n3) (hn4 : 0 < n4)
    (he3 : 0 < e3) (he4 : 0 < e4) (hR : 0 < R) :
    fixedSensitivity a n3 n4 e3 e4 s R 1 = 1 / R := by
  unfold fixedSensitivity retailTotal retailWeight
  simp only [sub_self, zero_mul, add_zero, one_mul]
  have hb : 0 < a + n3 / e3 + n4 / e4 := by positivity
  field_simp [ne_of_gt hb, ne_of_gt hR]

theorem FixedMarket.sensitivity_eq_fixedSensitivity
    (M : FixedMarket) (mu : ℝ) :
    M.sensitivity mu =
      fixedSensitivity M.a (M.lambda3 / M.g3) (M.lambda4 / M.g4)
        M.e (M.e + M.tau2Sq) M.s M.R mu := by
  unfold FixedMarket.sensitivity fixedSensitivity retailTotal retailWeight
  unfold FixedMarket.B FixedMarket.h3 FixedMarket.h4
  unfold FixedMarket.v3 FixedMarket.v4 FixedMarket.d
  simp only [div_div]
  congr 1 <;> ring

/-- Proposition 4, including strict finite changes, both bounds, and the
full-information endpoint. -/
theorem FixedMarket.fixedSentimentSensitivity
    (M : FixedMarket) :
    (∀ x y : ℝ, 0 ≤ x → x < y → y ≤ 1 →
      M.sensitivity x < M.sensitivity y) ∧
    (∀ mu : ℝ, 0 ≤ mu → mu ≤ 1 →
      0 < M.sensitivity mu ∧ M.sensitivity mu ≤ 1 / M.R) ∧
    M.sensitivity 1 = 1 / M.R := by
  have hg3 : 0 < M.g3 := by
    unfold FixedMarket.g3
    exact M.gamma_pos
  have hg4 : 0 < M.g4 := by
    unfold FixedMarket.g4
    positivity
  have hn3 : 0 < M.lambda3 / M.g3 := div_pos M.lambda3_pos hg3
  have hn4 : 0 < M.lambda4 / M.g4 := div_pos M.lambda4_pos hg4
  have he4 : 0 < M.e + M.tau2Sq := add_pos_of_pos_of_nonneg M.e_pos M.tau2Sq_nonneg
  have hg1 : 0 < M.g1 := by
    unfold FixedMarket.g1
    exact M.gamma_pos
  have hg2 : 0 < M.g2 := by
    unfold FixedMarket.g2
    positivity
  have hv1 : 0 < M.v1 := by
    exact M.e_pos
  have hv2 : 0 < M.v2 := by
    unfold FixedMarket.v2
    exact add_pos_of_pos_of_nonneg M.e_pos M.tau1Sq_nonneg
  have ha : 0 < M.a := by
    unfold FixedMarket.a FixedMarket.h1 FixedMarket.h2
    exact add_pos (div_pos M.lambda1_pos (mul_pos hg1 hv1))
      (div_pos M.lambda2_pos (mul_pos hg2 hv2))
  constructor
  · intro x y hx hxy hy
    rw [M.sensitivity_eq_fixedSensitivity, M.sensitivity_eq_fixedSensitivity]
    exact fixedSensitivity_strictMonoOn
      M.a (M.lambda3 / M.g3) (M.lambda4 / M.g4)
      M.e (M.e + M.tau2Sq) M.s M.R x y
      ha
      hn3 hn4 M.e_pos he4 M.s_pos.le M.R_pos hx hxy hy
  · constructor
    · intro mu hmu0 hmu1
      rw [M.sensitivity_eq_fixedSensitivity]
      exact fixedSensitivity_bounds
        M.a (M.lambda3 / M.g3) (M.lambda4 / M.g4)
        M.e (M.e + M.tau2Sq) M.s M.R mu
        ha
        hn3 hn4 M.e_pos he4 M.s_pos.le M.R_pos hmu0 hmu1
    · rw [M.sensitivity_eq_fixedSensitivity]
      exact fixedSensitivity_fullInformation
        M.a (M.lambda3 / M.g3) (M.lambda4 / M.g4)
        M.e (M.e + M.tau2Sq) M.s M.R
        ha
        hn3 hn4 M.e_pos he4 M.R_pos

end

end Olano26Transparencia
