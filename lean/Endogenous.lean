import Olano26Transparencia.Model

/-!
# Endogenous sentiment (Proposition 5)

This file is new relative to the author's preliminary Lean artifacts.  It
formalizes the quotient derivative, the sign argument, the exact pointwise
criterion, and the rational counter-trajectory computations.
-/

namespace Olano26Transparencia

noncomputable section

theorem EndogenousMarket.d3_pos (M : EndogenousMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.d3 mu := by
  unfold d3 e3
  have hgap : 0 ≤ 1 - mu := by linarith
  exact add_pos_of_pos_of_nonneg M.e_pos (mul_nonneg hgap M.s_pos.le)

theorem EndogenousMarket.d4_pos (M : EndogenousMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.d4 mu := by
  unfold d4 e4
  have hgap : 0 ≤ 1 - mu := by linarith
  have he4 : 0 < M.e + M.tau2Sq := add_pos_of_pos_of_nonneg M.e_pos M.tau2Sq_nonneg
  exact add_pos_of_pos_of_nonneg he4 (mul_nonneg hgap M.s_pos.le)

theorem EndogenousMarket.n3_pos (M : EndogenousMarket) : 0 < M.n3 := by
  unfold n3
  exact div_pos M.lambda3_pos M.gamma_pos

theorem EndogenousMarket.n4_pos (M : EndogenousMarket) (mu : ℝ) : 0 < M.n4 mu := by
  unfold n4
  exact mul_pos (div_pos M.lambda4_pos M.gamma_pos) (Real.exp_pos _)

theorem EndogenousMarket.a_pos (M : EndogenousMarket) (mu : ℝ) : 0 < M.a mu := by
  unfold a
  have hfirst : 0 < M.lambda1 / (M.gamma * M.e) :=
    div_pos M.lambda1_pos (mul_pos M.gamma_pos M.e_pos)
  have hvariance : 0 < M.e + M.tau1Sq :=
    add_pos_of_pos_of_nonneg M.e_pos M.tau1Sq_nonneg
  have hsecond :
      0 < (M.lambda2 / (M.gamma * (M.e + M.tau1Sq))) *
        Real.exp (M.b * M.rho1 mu) :=
    mul_pos (div_pos M.lambda2_pos (mul_pos M.gamma_pos hvariance))
      (Real.exp_pos _)
  exact add_pos hfirst hsecond

theorem EndogenousMarket.B_pos (M : EndogenousMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    0 < M.B mu := by
  unfold B
  exact add_pos (div_pos M.n3_pos (M.d3_pos mu hmu))
    (div_pos (M.n4_pos mu) (M.d4_pos mu hmu))

theorem EndogenousMarket.hasDerivWithinAt_a
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ∈ Set.Icc (0 : ℝ) 1) :
    HasDerivWithinAt M.a (M.aPrime mu) (Set.Icc (0 : ℝ) 1) mu := by
  have hrho : HasDerivWithinAt M.rho1
      (derivWithin M.rho1 (Set.Icc (0 : ℝ) 1) mu)
      (Set.Icc (0 : ℝ) 1) mu :=
    (M.rho1_differentiableOn mu hmu).hasDerivWithinAt
  unfold a aPrime
  convert (hasDerivWithinAt_const mu
      (Set.Icc (0 : ℝ) 1) (M.lambda1 / (M.gamma * M.e))).add
    (((hrho.const_mul M.b).exp).const_mul
      (M.lambda2 / (M.gamma * (M.e + M.tau1Sq)))) using 1
  · simp only [div_eq_mul_inv]
    ring

theorem EndogenousMarket.hasDerivWithinAt_n4
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ∈ Set.Icc (0 : ℝ) 1) :
    HasDerivWithinAt M.n4 (M.n4Prime mu) (Set.Icc (0 : ℝ) 1) mu := by
  have hrho : HasDerivWithinAt M.rho2
      (derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu)
      (Set.Icc (0 : ℝ) 1) mu :=
    (M.rho2_differentiableOn mu hmu).hasDerivWithinAt
  unfold n4 n4Prime
  convert (((hrho.const_mul M.b).exp).const_mul (M.lambda4 / M.gamma)) using 1
  · unfold EndogenousMarket.n4
    simp only [div_eq_mul_inv]
    ring

theorem EndogenousMarket.hasDerivWithinAt_B
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ∈ Set.Icc (0 : ℝ) 1) :
    HasDerivWithinAt M.B (M.BPrime mu) (Set.Icc (0 : ℝ) 1) mu := by
  have hd3 : HasDerivWithinAt M.d3 (-M.s) (Set.Icc (0 : ℝ) 1) mu := by
    unfold d3 e3
    have hgap : HasDerivWithinAt (fun x : ℝ => 1 - x) (-1)
        (Set.Icc (0 : ℝ) 1) mu :=
      by
        convert (hasDerivWithinAt_const mu (Set.Icc (0 : ℝ) 1) (1 : ℝ)).sub
          (hasDerivWithinAt_id mu (Set.Icc (0 : ℝ) 1)) using 1 <;>
          simp
    convert (hasDerivWithinAt_const mu (Set.Icc (0 : ℝ) 1) M.e).add
      (hgap.mul_const M.s) using 1 <;> ring
  have hd4 : HasDerivWithinAt M.d4 (-M.s) (Set.Icc (0 : ℝ) 1) mu := by
    unfold d4 e4
    have hgap : HasDerivWithinAt (fun x : ℝ => 1 - x) (-1)
        (Set.Icc (0 : ℝ) 1) mu :=
      by
        convert (hasDerivWithinAt_const mu (Set.Icc (0 : ℝ) 1) (1 : ℝ)).sub
          (hasDerivWithinAt_id mu (Set.Icc (0 : ℝ) 1)) using 1 <;>
          simp
    convert (hasDerivWithinAt_const mu
      (Set.Icc (0 : ℝ) 1) (M.e + M.tau2Sq)).add
      (hgap.mul_const M.s) using 1 <;> ring
  have hd3ne : M.d3 mu ≠ 0 := ne_of_gt (M.d3_pos mu hmu.2)
  have hd4ne : M.d4 mu ≠ 0 := ne_of_gt (M.d4_pos mu hmu.2)
  have hfirst := (hasDerivWithinAt_const mu (Set.Icc (0 : ℝ) 1) M.n3).div
    hd3 hd3ne
  have hsecond := (M.hasDerivWithinAt_n4 mu hmu).div hd4 hd4ne
  unfold B BPrime
  convert hfirst.add hsecond using 1 <;>
    field_simp [hd3ne, hd4ne] <;> ring

/-- Proposition 5(i), including the source's one-sided endpoint derivatives. -/
theorem EndogenousMarket.hasDerivWithinAt_sensitivity
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ∈ Set.Icc (0 : ℝ) 1) :
    HasDerivWithinAt M.sensitivity
      (endogenousDerivativeNumerator mu (M.a mu) (M.aPrime mu)
          (M.B mu) (M.BPrime mu) /
        (M.R * (M.a mu + M.B mu) ^ 2))
      (Set.Icc (0 : ℝ) 1) mu := by
  have ha := M.hasDerivWithinAt_a mu hmu
  have hB := M.hasDerivWithinAt_B mu hmu
  have hden : M.R * (M.a mu + M.B mu) ≠ 0 := by
    exact mul_ne_zero (ne_of_gt M.R_pos)
      (ne_of_gt (add_pos (M.a_pos mu) (M.B_pos mu hmu.2)))
  have hnum : HasDerivWithinAt
      (fun x : ℝ => M.a x + x * M.B x)
      (M.aPrime mu + (M.B mu + mu * M.BPrime mu))
      (Set.Icc (0 : ℝ) 1) mu := by
    convert ha.add ((hasDerivWithinAt_id mu (Set.Icc (0 : ℝ) 1)).mul hB) using 1 <;>
      simp
  have hdenDeriv : HasDerivWithinAt
      (fun x : ℝ => M.R * (M.a x + M.B x))
      (M.R * (M.aPrime mu + M.BPrime mu))
      (Set.Icc (0 : ℝ) 1) mu := by
    convert (ha.add hB).const_mul M.R using 1 <;> ring
  change HasDerivWithinAt
    (fun x : ℝ => (M.a x + x * M.B x) / (M.R * (M.a x + M.B x))) _
      (Set.Icc (0 : ℝ) 1) mu
  convert hnum.div hdenDeriv hden using 1
  unfold endogenousDerivativeNumerator
  field_simp [ne_of_gt M.R_pos,
    ne_of_gt (add_pos (M.a_pos mu) (M.B_pos mu hmu.2))]
  ring

theorem EndogenousMarket.derivWithin_sensitivity
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ∈ Set.Icc (0 : ℝ) 1) :
    derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu =
      endogenousDerivativeNumerator mu (M.a mu) (M.aPrime mu)
          (M.B mu) (M.BPrime mu) /
        (M.R * (M.a mu + M.B mu) ^ 2) :=
  (M.hasDerivWithinAt_sensitivity mu hmu).derivWithin
    (uniqueDiffOn_Icc_zero_one.uniqueDiffWithinAt hmu)

theorem EndogenousMarket.derivativeNumerator_decomposition
    (M : EndogenousMarket) (mu : ℝ) (hmu : mu ≤ 1) :
    endogenousDerivativeNumerator mu (M.a mu) (M.aPrime mu)
        (M.B mu) (M.BPrime mu) =
      M.B mu ^ 2 + M.a mu *
          (M.n3 * M.e3 / M.d3 mu ^ 2 +
            M.n4 mu * M.e4 / M.d4 mu ^ 2) -
        (1 - mu) * M.a mu * (M.n4Prime mu / M.d4 mu) +
        (1 - mu) * M.B mu * M.aPrime mu := by
  have hd3ne : M.d3 mu ≠ 0 := ne_of_gt (M.d3_pos mu hmu)
  have hd4ne : M.d4 mu ≠ 0 := ne_of_gt (M.d4_pos mu hmu)
  have h3 :
      M.n3 / M.d3 mu - (1 - mu) * (M.s * M.n3 / M.d3 mu ^ 2) =
        M.n3 * M.e3 / M.d3 mu ^ 2 := by
    rw [show M.d3 mu = M.e3 + (1 - mu) * M.s by rfl]
    field_simp [hd3ne]
    ring
  have h4 :
      M.n4 mu / M.d4 mu - (1 - mu) *
          (M.s * M.n4 mu / M.d4 mu ^ 2 + M.n4Prime mu / M.d4 mu) =
        M.n4 mu * M.e4 / M.d4 mu ^ 2 -
          (1 - mu) * (M.n4Prime mu / M.d4 mu) := by
    rw [show M.d4 mu = M.e4 + (1 - mu) * M.s by rfl]
    field_simp [hd4ne]
    ring
  have hBidentity :
      M.B mu - (1 - mu) * M.BPrime mu =
        M.n3 * M.e3 / M.d3 mu ^ 2 + M.n4 mu * M.e4 / M.d4 mu ^ 2 -
          (1 - mu) * (M.n4Prime mu / M.d4 mu) := by
    unfold EndogenousMarket.B EndogenousMarket.BPrime
    linarith
  unfold endogenousDerivativeNumerator
  calc
    M.B mu * (M.a mu + M.B mu) -
          (1 - mu) * (M.a mu * M.BPrime mu - M.B mu * M.aPrime mu) =
        M.B mu ^ 2 + M.a mu * (M.B mu - (1 - mu) * M.BPrime mu) +
          (1 - mu) * M.B mu * M.aPrime mu := by ring
    _ = M.B mu ^ 2 + M.a mu *
          (M.n3 * M.e3 / M.d3 mu ^ 2 +
            M.n4 mu * M.e4 / M.d4 mu ^ 2) -
        (1 - mu) * M.a mu * (M.n4Prime mu / M.d4 mu) +
        (1 - mu) * M.B mu * M.aPrime mu := by
      rw [hBidentity]
      ring

theorem EndogenousMarket.derivWithin_sensitivity_pos_of_sentiment_signs
    (M : EndogenousMarket) (mu : ℝ)
    (hmu0 : 0 ≤ mu) (hmu1 : mu ≤ 1)
    (hrho1 : 0 ≤ derivWithin M.rho1 (Set.Icc (0 : ℝ) 1) mu)
    (hrho2 : derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu ≤ 0) :
    0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu := by
  have hmu : mu ∈ Set.Icc (0 : ℝ) 1 := ⟨hmu0, hmu1⟩
  have haPrime : 0 ≤ M.aPrime mu := by
    unfold EndogenousMarket.aPrime
    have hweight : 0 <
        (M.lambda2 / (M.gamma * (M.e + M.tau1Sq))) *
          Real.exp (M.b * M.rho1 mu) := by
      have hvariance : 0 < M.e + M.tau1Sq :=
        add_pos_of_pos_of_nonneg M.e_pos M.tau1Sq_nonneg
      exact mul_pos
        (div_pos M.lambda2_pos (mul_pos M.gamma_pos hvariance))
        (Real.exp_pos _)
    exact mul_nonneg (mul_nonneg M.b_pos.le hrho1) hweight.le
  have hn4Prime : M.n4Prime mu ≤ 0 := by
    unfold EndogenousMarket.n4Prime
    have h := mul_nonpos_of_nonneg_of_nonpos
      (mul_nonneg M.b_pos.le (M.n4_pos mu).le) hrho2
    convert h using 1 <;> ring
  have hbase :
      0 < M.B mu ^ 2 + M.a mu *
        (M.n3 * M.e3 / M.d3 mu ^ 2 +
          M.n4 mu * M.e4 / M.d4 mu ^ 2) := by
    have he3 : 0 < M.e3 := M.e_pos
    have he4 : 0 < M.e4 := add_pos_of_pos_of_nonneg M.e_pos M.tau2Sq_nonneg
    have hd3 := M.d3_pos mu hmu1
    have hd4 := M.d4_pos mu hmu1
    have hB := M.B_pos mu hmu1
    have ha := M.a_pos mu
    have hterm1 : 0 < M.n3 * M.e3 / M.d3 mu ^ 2 := by
      exact div_pos (mul_pos M.n3_pos he3) (sq_pos_of_pos hd3)
    have hterm2 : 0 < M.n4 mu * M.e4 / M.d4 mu ^ 2 := by
      exact div_pos (mul_pos (M.n4_pos mu) he4) (sq_pos_of_pos hd4)
    have hsums : 0 < M.n3 * M.e3 / M.d3 mu ^ 2 +
        M.n4 mu * M.e4 / M.d4 mu ^ 2 := add_pos hterm1 hterm2
    exact add_pos (sq_pos_of_pos hB) (mul_pos ha hsums)
  have hnonneg1 :
      0 ≤ -(1 - mu) * M.a mu * (M.n4Prime mu / M.d4 mu) := by
    have hd4 := M.d4_pos mu hmu1
    have ha := M.a_pos mu
    have hgap : 0 ≤ 1 - mu := by linarith
    have hquot : M.n4Prime mu / M.d4 mu ≤ 0 :=
      div_nonpos_of_nonpos_of_nonneg hn4Prime hd4.le
    have hleft : -(1 - mu) * M.a mu ≤ 0 :=
      mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hgap) ha.le
    exact mul_nonneg_of_nonpos_of_nonpos hleft hquot
  have hnonneg2 : 0 ≤ (1 - mu) * M.B mu * M.aPrime mu := by
    have hB := M.B_pos mu hmu1
    have hgap : 0 ≤ 1 - mu := by linarith
    exact mul_nonneg (mul_nonneg hgap hB.le) haPrime
  rw [M.derivWithin_sensitivity mu hmu]
  rw [M.derivativeNumerator_decomposition mu hmu1]
  have hden : 0 < M.R * (M.a mu + M.B mu) ^ 2 := by
    have ha := M.a_pos mu
    have hB := M.B_pos mu hmu1
    exact mul_pos M.R_pos (sq_pos_of_pos (add_pos ha hB))
  exact div_pos (by linarith) hden

/-- Proposition 5(ii): the source sign restrictions imply strict increase on
the full transparency interval. -/
theorem EndogenousMarket.strictMonoOn_sensitivity_of_sentiment_signs
    (M : EndogenousMarket)
    (hrho1 : ∀ mu ∈ Set.Icc (0 : ℝ) 1,
      0 ≤ derivWithin M.rho1 (Set.Icc (0 : ℝ) 1) mu)
    (hrho2 : ∀ mu ∈ Set.Icc (0 : ℝ) 1,
      derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu ≤ 0) :
    StrictMonoOn M.sensitivity (Set.Icc (0 : ℝ) 1) := by
  apply strictMonoOn_of_deriv_pos (convex_Icc (0 : ℝ) 1)
  · intro mu hmu
    exact (M.hasDerivWithinAt_sensitivity mu hmu).continuousWithinAt
  · intro mu hmu
    have hioo : mu ∈ Set.Ioo (0 : ℝ) 1 := by
      simpa only [interior_Icc] using hmu
    have hmem : mu ∈ Set.Icc (0 : ℝ) 1 := ⟨hioo.1.le, hioo.2.le⟩
    have hwithin := M.derivWithin_sensitivity_pos_of_sentiment_signs
      mu hmem.1 hmem.2 (hrho1 mu hmem) (hrho2 mu hmem)
    have hAt := (M.hasDerivWithinAt_sensitivity mu hmem).hasDerivAt
      (Icc_mem_nhds hioo.1 hioo.2)
    rw [hAt.deriv]
    rw [M.derivWithin_sensitivity mu hmem] at hwithin
    exact hwithin

theorem EndogenousMarket.derivativeNumerator_eq_retailBracket
    (M : EndogenousMarket) (mu constant : ℝ)
    (hmu : mu ∈ Set.Icc (0 : ℝ) 1)
    (hrho1 : Set.EqOn M.rho1 (fun _ => constant) (Set.Icc (0 : ℝ) 1)) :
    endogenousDerivativeNumerator mu (M.a mu) (M.aPrime mu)
        (M.B mu) (M.BPrime mu) = endogenousRetailBracket M mu := by
  have haPrime : M.aPrime mu = 0 := by
    unfold EndogenousMarket.aPrime
    rw [derivWithin_congr hrho1 (hrho1 hmu)]
    simp
  have hd3ne : M.d3 mu ≠ 0 := ne_of_gt (M.d3_pos mu hmu.2)
  have hd4ne : M.d4 mu ≠ 0 := ne_of_gt (M.d4_pos mu hmu.2)
  rw [M.derivativeNumerator_decomposition mu hmu.2, haPrime]
  unfold endogenousRetailBracket EndogenousMarket.n4Prime
  field_simp [hd3ne, hd4ne]
  ring

/-- Proposition 5(iii), exact iff and its stated sufficient condition. -/
theorem EndogenousMarket.constantInstitutionCriterion
    (M : EndogenousMarket) (mu constant : ℝ)
    (hmu0 : 0 ≤ mu) (hmu1 : mu ≤ 1)
    (hrho1 : Set.EqOn M.rho1 (fun _ => constant) (Set.Icc (0 : ℝ) 1)) :
    (0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu ↔
      0 < endogenousRetailBracket M mu) ∧
    ((1 - mu) * M.b * derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu ≤
        M.e4 / M.d4 mu →
      0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu) := by
  have hmu : mu ∈ Set.Icc (0 : ℝ) 1 := ⟨hmu0, hmu1⟩
  have hnum := M.derivativeNumerator_eq_retailBracket mu constant hmu hrho1
  have hden : 0 < M.R * (M.a mu + M.B mu) ^ 2 := by
    have ha := M.a_pos mu
    have hB := M.B_pos mu hmu1
    exact mul_pos M.R_pos (sq_pos_of_pos (add_pos ha hB))
  have hiff :
      0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu ↔
        0 < endogenousRetailBracket M mu := by
    rw [M.derivWithin_sensitivity mu hmu, hnum]
    exact div_pos_iff_of_pos_right hden
  constructor
  · exact hiff
  · intro hsuff
    apply hiff.mpr
    unfold endogenousRetailBracket
    have hd3 := M.d3_pos mu hmu1
    have hd4 := M.d4_pos mu hmu1
    have hn3 := M.n3_pos
    have hn4 := M.n4_pos mu
    have he3 : 0 < M.e3 := M.e_pos
    have hB := M.B_pos mu hmu1
    have ha := M.a_pos mu
    have hinner :
        0 ≤ M.e4 / M.d4 mu - (1 - mu) * M.b *
          derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu := by
      linarith
    have hfirst : 0 < M.n3 * M.e3 / M.d3 mu ^ 2 := by positivity
    have hsecond :
        0 ≤ M.n4 mu / M.d4 mu *
          (M.e4 / M.d4 mu - (1 - mu) * M.b *
            derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu) := by
      positivity
    positivity

theorem EndogenousMarket.fullInformationSensitivity (M : EndogenousMarket) :
    M.sensitivity 1 = 1 / M.R := by
  unfold EndogenousMarket.sensitivity
  have hsum : 0 < M.a 1 + M.B 1 :=
    add_pos (M.a_pos 1) (M.B_pos 1 (by norm_num))
  field_simp [ne_of_gt M.R_pos, ne_of_gt hsum]

/-! ## Exact trajectory in Proposition 5(iv) -/

theorem counterLogTrajectorySensitivity_eq
    (b c mu : ℝ) (hb : 0 < b) (hc : -1 < c)
    (hmu0 : 0 ≤ mu) (hmu1 : mu ≤ 1) :
    counterLogTrajectorySensitivity b c mu = counterTrajectorySensitivity c mu := by
  have harg : 0 < 1 + c * mu := by
    by_cases hc0 : 0 ≤ c
    · have : 0 ≤ c * mu := mul_nonneg hc0 hmu0
      linarith
    · have hcneg : c < 0 := lt_of_not_ge hc0
      have hcmu : c ≤ c * mu := by
        nlinarith
      linarith
  have hcancel : b * (b⁻¹ * Real.log (1 + c * mu)) =
      Real.log (1 + c * mu) := by
    field_simp [ne_of_gt hb]
  have hn4 : counterLogTrajectoryN4 b c mu = (1 / 4 : ℝ) * (1 + c * mu) := by
    unfold counterLogTrajectoryN4
    rw [hcancel, Real.exp_log harg]
  unfold counterLogTrajectorySensitivity counterLogTrajectoryB
  unfold counterTrajectorySensitivity counterTrajectoryB
  rw [hn4]

theorem counterTrajectorySensitivity_hasDerivAt_zero (c : ℝ) :
    HasDerivAt (counterTrajectorySensitivity c) ((101 - 36 * c) / 392) 0 := by
  have htwo : HasDerivAt (fun mu : ℝ => 2 - mu) (-1) 0 :=
    by
      convert (hasDerivAt_const 0 (2 : ℝ)).sub (hasDerivAt_id (0 : ℝ)) using 1 <;>
        simp
  have hthree : HasDerivAt (fun mu : ℝ => 3 - mu) (-1) 0 :=
    by
      convert (hasDerivAt_const 0 (3 : ℝ)).sub (hasDerivAt_id (0 : ℝ)) using 1 <;>
        simp
  have hfirst : HasDerivAt (fun mu : ℝ => (1 / 4 : ℝ) / (2 - mu))
      (1 / 16) 0 := by
    convert (hasDerivAt_const 0 (1 / 4 : ℝ)).div htwo (by norm_num) using 1 <;>
      norm_num
  have hnumerator : HasDerivAt
      (fun mu : ℝ => (1 / 4 : ℝ) * (1 + c * mu)) (c / 4) 0 := by
    convert (hasDerivAt_const 0 (1 / 4 : ℝ)).mul
      ((hasDerivAt_const 0 1).add ((hasDerivAt_const 0 c).mul (hasDerivAt_id 0))) using 1 <;>
      norm_num <;> ring
  have hsecond : HasDerivAt
      (fun mu : ℝ => ((1 / 4 : ℝ) * (1 + c * mu)) / (3 - mu))
      ((3 * c + 1) / 36) 0 := by
    convert hnumerator.div hthree (by norm_num) using 1 <;> norm_num <;> ring
  have hB : HasDerivAt (counterTrajectoryB c) ((13 + 12 * c) / 144) 0 := by
    unfold counterTrajectoryB
    convert hfirst.add hsecond using 1 <;> norm_num <;> ring
  have hnum : HasDerivAt
      (fun mu : ℝ => (3 / 8 : ℝ) + mu * counterTrajectoryB c mu)
      (5 / 24) 0 := by
    convert (hasDerivAt_const 0 (3 / 8 : ℝ)).add ((hasDerivAt_id 0).mul hB) using 1 <;>
      norm_num [counterTrajectoryB] <;> ring
  have hden : HasDerivAt
      (fun mu : ℝ => (3 / 8 : ℝ) + counterTrajectoryB c mu)
      ((13 + 12 * c) / 144) 0 :=
    by
      convert (hasDerivAt_const 0 (3 / 8 : ℝ)).add hB using 1 <;> simp
  have hdenne : (3 / 8 : ℝ) + counterTrajectoryB c 0 ≠ 0 := by
    norm_num [counterTrajectoryB]
  unfold counterTrajectorySensitivity
  convert hnum.div hden hdenne using 1 <;>
    norm_num [counterTrajectoryB] <;> ring

/-- The literal logarithmic path has the source's right derivative at zero.
The proof transports the rational calculation only after proving equality of
the two functions on the full source interval. -/
theorem counterLogTrajectorySensitivity_hasDerivWithinAt_zero
    (b c : ℝ) (hb : 0 < b) (hc : -1 < c) :
    HasDerivWithinAt (counterLogTrajectorySensitivity b c)
      ((101 - 36 * c) / 392) (Set.Icc (0 : ℝ) 1) 0 := by
  exact (counterTrajectorySensitivity_hasDerivAt_zero c).hasDerivWithinAt.congr_of_mem
    (fun mu hmu => counterLogTrajectorySensitivity_eq b c mu hb hc hmu.1 hmu.2)
    (by norm_num)

theorem counterTrajectory_deriv_zero_lt_iff (c : ℝ) :
    deriv (counterTrajectorySensitivity c) 0 < 0 ↔ c > 101 / 36 := by
  rw [(counterTrajectorySensitivity_hasDerivAt_zero c).deriv]
  constructor <;> intro h <;> norm_num at h ⊢ <;> linarith

theorem counterLogTrajectory_derivWithin_zero_lt_iff
    (b c : ℝ) (hb : 0 < b) (hc : -1 < c) :
    derivWithin (counterLogTrajectorySensitivity b c)
        (Set.Icc (0 : ℝ) 1) 0 < 0 ↔
      c > 101 / 36 := by
  rw [(counterLogTrajectorySensitivity_hasDerivWithinAt_zero b c hb hc).derivWithin
    (uniqueDiffOn_Icc_zero_one.uniqueDiffWithinAt (by norm_num))]
  constructor <;> intro h <;> norm_num at h ⊢ <;> linarith

theorem counterTrajectory_c5_exact :
    counterTrajectorySensitivity 5 (1 / 10) = 1768 / 2803 ∧
      counterTrajectorySensitivity 5 (1 / 10) < 9 / 14 := by
  norm_num [counterTrajectorySensitivity, counterTrajectoryB]

theorem counterLogTrajectory_c5_exact (b : ℝ) (hb : 0 < b) :
    counterLogTrajectorySensitivity b 5 (1 / 10) = 1768 / 2803 ∧
      counterLogTrajectorySensitivity b 5 (1 / 10) < 9 / 14 := by
  rw [counterLogTrajectorySensitivity_eq b 5 (1 / 10) hb (by norm_num)
    (by norm_num) (by norm_num)]
  exact counterTrajectory_c5_exact

theorem counterTrajectory_fullInformation (c : ℝ) (hc : -1 < c) :
    counterTrajectorySensitivity c 1 = 1 := by
  unfold counterTrajectorySensitivity counterTrajectoryB
  have hpos : 0 < (3 / 8 : ℝ) + ((1 / 4 : ℝ) / (2 - 1) +
      (1 / 4 : ℝ) * (1 + c) / (3 - 1)) := by
    have hcpos : 0 < 1 + c := by linarith
    positivity
  simpa only [one_mul, mul_one] using div_self (ne_of_gt hpos)

theorem counterLogTrajectory_fullInformation
    (b c : ℝ) (hb : 0 < b) (hc : -1 < c) :
    counterLogTrajectorySensitivity b c 1 = 1 := by
  rw [counterLogTrajectorySensitivity_eq b c 1 hb hc (by norm_num) (by norm_num)]
  exact counterTrajectory_fullInformation c hc

end

end Olano26Transparencia
