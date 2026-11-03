import Olano26Transparencia.Model

/-!
# Market clearing and the conditional expected price

The market-clearing rearrangement is adapted from the author's supplied
read-only `BaselineAudit.lean`.  The expectation statement is new: it is a
literal integral over the independent public-noise Gaussian, thereby supplying
the probabilistic bridge that the preliminary artifact explicitly left open.
-/

namespace Olano26Transparencia

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory

noncomputable section

theorem FixedMarket.h1_pos (M : FixedMarket) : 0 < M.h1 := by
  unfold h1 g1 v1
  exact div_pos M.lambda1_pos (mul_pos M.gamma_pos M.e_pos)

theorem FixedMarket.h2_pos (M : FixedMarket) : 0 < M.h2 := by
  unfold h2 g2 v2
  have hg : 0 < M.gamma * Real.exp (-M.b * M.rho1) :=
    mul_pos M.gamma_pos (Real.exp_pos _)
  have hv : 0 < M.e + M.tau1Sq := add_pos_of_pos_of_nonneg M.e_pos M.tau1Sq_nonneg
  exact div_pos M.lambda2_pos (mul_pos hg hv)

theorem FixedMarket.h3_pos (M : FixedMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.h3 mu := by
  unfold h3 g3 v3 d
  have : 0 ≤ 1 - mu := by linarith
  have hmul : 0 ≤ (1 - mu) * M.s := mul_nonneg this M.s_pos.le
  have hv : 0 < M.e + (1 - mu) * M.s := add_pos_of_pos_of_nonneg M.e_pos hmul
  exact div_pos M.lambda3_pos (mul_pos M.gamma_pos hv)

theorem FixedMarket.h4_pos (M : FixedMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.h4 mu := by
  unfold h4 g4 v4 d
  have hm : 0 ≤ 1 - mu := by linarith
  have hexp : 0 < Real.exp (-M.b * M.rho2) := Real.exp_pos _
  have hg : 0 < M.gamma * Real.exp (-M.b * M.rho2) := mul_pos M.gamma_pos hexp
  have hmul : 0 ≤ (1 - mu) * M.s := mul_nonneg hm M.s_pos.le
  have hv0 : 0 < M.e + (1 - mu) * M.s := add_pos_of_pos_of_nonneg M.e_pos hmul
  have hv : 0 < M.e + (1 - mu) * M.s + M.tau2Sq :=
    add_pos_of_pos_of_nonneg hv0 M.tau2Sq_nonneg
  exact div_pos M.lambda4_pos (mul_pos hg hv)

theorem FixedMarket.a_pos (M : FixedMarket) : 0 < M.a := by
  exact add_pos M.h1_pos M.h2_pos

theorem FixedMarket.B_pos (M : FixedMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.B mu := by
  exact add_pos (M.h3_pos mu hmu) (M.h4_pos mu hmu)

theorem FixedMarket.H_pos (M : FixedMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.H mu := by
  exact add_pos M.a_pos (M.B_pos mu hmu)

theorem FixedMarket.aggregateDemand_eq
    (M : FixedMarket) (mu theta kappa price : ℝ) :
    M.aggregateDemand mu theta kappa price =
      M.H mu * M.P0 + M.a * theta + M.B mu * kappa +
        M.h2 * M.delta1 + M.h4 mu * M.delta2 -
        M.R * M.H mu * price := by
  unfold aggregateDemand optimalDemand m1 m2 m3 m4
  unfold H a B h1 h2 h3 h4
  ring

/-- The unit-supply clearing equation has exactly the source price. -/
theorem FixedMarket.marketClearing_iff_uniquePrice
    (M : FixedMarket) (mu theta kappa price : ℝ) (hmu : mu ≤ 1) :
    M.aggregateDemand mu theta kappa price = 1 ↔
      price = M.equilibriumPrice mu theta kappa := by
  rw [M.aggregateDemand_eq]
  unfold equilibriumPrice
  have hR : M.R ≠ 0 := ne_of_gt M.R_pos
  have hH : M.H mu ≠ 0 := ne_of_gt (M.H_pos mu hmu)
  constructor <;> intro h
  · field_simp [hR, hH]
    field_simp [hR, hH] at h
    linarith
  · subst price
    field_simp [hR, hH]
    ring

theorem FixedMarket.equilibriumPrice_affine_in_noise
    (M : FixedMarket) (mu theta eta : ℝ) (hmu : mu ≤ 1) :
    M.equilibriumPrice mu theta (mu * (theta + eta)) =
      M.priceIntercept mu + M.sensitivity mu * theta +
        (M.B mu * mu / (M.R * M.H mu)) * eta := by
  unfold equilibriumPrice priceIntercept sensitivity H
  have hR : M.R ≠ 0 := ne_of_gt M.R_pos
  have hH : M.a + M.B mu ≠ 0 := ne_of_gt (M.H_pos mu hmu)
  field_simp [hR, hH]
  ring

/-- Proposition 3's probabilistic clause: conditional on a fixed fundamental,
integrating the independent public noise gives the stated affine price. -/
theorem FixedMarket.expectedPriceGivenFundamental_eq
    (M : FixedMarket) (t theta : ℝ) (ht : 0 ≤ t) :
    M.expectedPriceGivenFundamental t theta =
      M.priceIntercept (transparencyWeight M.s t) +
        M.sensitivity (transparencyWeight M.s t) * theta := by
  let mu := transparencyWeight M.s t
  have htotal : 0 < M.s + t := add_pos_of_pos_of_nonneg M.s_pos ht
  have hmu : mu ≤ 1 := by
    dsimp [mu, transparencyWeight]
    apply (div_le_one htotal).2
    linarith
  have hpointwise :
      (fun eta : ℝ => M.equilibriumPrice mu theta (mu * (theta + eta))) =
        (fun eta : ℝ =>
          (M.priceIntercept mu + M.sensitivity mu * theta) +
            (M.B mu * mu / (M.R * M.H mu)) * eta) := by
    funext eta
    simpa [add_assoc] using M.equilibriumPrice_affine_in_noise mu theta eta hmu
  have hid : Integrable id (gaussianReal 0 t.toNNReal) := by
    exact memLp_one_iff_integrable.mp
      (memLp_id_gaussianReal (μ := 0) (v := t.toNNReal) 1)
  have hlinear :
      Integrable
        (fun eta : ℝ => (M.B mu * mu / (M.R * M.H mu)) * eta)
        (gaussianReal 0 t.toNNReal) := by
    simpa only [id_eq] using hid.const_mul (M.B mu * mu / (M.R * M.H mu))
  unfold expectedPriceGivenFundamental
  dsimp only
  rw [show transparencyWeight M.s t = mu by rfl, hpointwise]
  rw [integral_add (integrable_const _) hlinear]
  have hconst :
      (∫ _eta : ℝ, M.priceIntercept mu + M.sensitivity mu * theta
        ∂gaussianReal 0 t.toNNReal) =
        M.priceIntercept mu + M.sensitivity mu * theta := by simp
  have hzero :
      (∫ eta : ℝ, (M.B mu * mu / (M.R * M.H mu)) * eta
        ∂gaussianReal 0 t.toNNReal) = 0 := by
    rw [integral_const_mul, integral_id_gaussianReal]
    ring
  rw [hconst, hzero]
  ring

/-- Proposition 3's no-signal endpoint.  At `μ = 0`, the public component
`κ` is identically zero, so the source affine price formula is a direct
deterministic identity rather than a finite-noise limit. -/
theorem FixedMarket.noSignalPrice_eq
    (M : FixedMarket) (theta : ℝ) :
    M.equilibriumPrice 0 theta 0 =
      M.priceIntercept 0 + M.sensitivity 0 * theta := by
  unfold equilibriumPrice priceIntercept sensitivity H
  have hR : M.R ≠ 0 := ne_of_gt M.R_pos
  have hH : M.a + M.B 0 ≠ 0 := ne_of_gt (M.H_pos 0 (by norm_num))
  field_simp [hR, hH]
  ring

end

end Olano26Transparencia
