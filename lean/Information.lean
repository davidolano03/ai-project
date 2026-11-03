import Olano26Transparencia.Model
import Mathlib.Probability.CondVar
import Mathlib.Probability.ConditionalExpectation

/-!
# Gaussian public/hidden information decomposition

The algebraic identities below agree with the author's supplied read-only
`SignalCARA.lean`.  The distributional statements are new: they use the
repository's exact Gaussian product law, independence theorem, and regular
conditional distribution for an additive Gaussian signal.
-/

namespace Olano26Transparencia

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory

noncomputable section

theorem transparencyWeight_pos (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    0 < transparencyWeight s t := by
  unfold transparencyWeight
  positivity

theorem transparencyWeight_lt_one (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    transparencyWeight s t < 1 := by
  unfold transparencyWeight
  apply (div_lt_one (add_pos hs ht)).2
  linarith

theorem information_decomposition (s t : ℝ) (pair : ℝ × ℝ) :
    fundamental pair = publicComponent s t pair + hiddenComponent s t pair := by
  unfold hiddenComponent
  ring

theorem hiddenComponent_eq_gaussianResidual
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    hiddenComponent s t =
      AppliedModelingLib.Probability.gaussianSignalResidual s t := by
  funext pair
  unfold hiddenComponent publicComponent transparencyWeight fundamental publicReport
  unfold AppliedModelingLib.Probability.gaussianSignalResidual
  unfold AppliedModelingLib.Probability.gaussianSignalWeight
  unfold AppliedModelingLib.Probability.gaussianSignalPriorWeight
  field_simp [ne_of_gt (add_pos hs ht)]
  ring

theorem publicComponent_marginal
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (informationLaw s t).map (publicComponent s t) =
      gaussianReal 0 (transparencyWeight s t * s).toNNReal := by
  let mu := transparencyWeight s t
  have htotal : 0 < s + t := add_pos hs ht
  have hmu : 0 < mu := transparencyWeight_pos s t hs ht
  calc
    (informationLaw s t).map (publicComponent s t) =
        ((informationLaw s t).map publicReport).map (fun y : ℝ => mu * y) := by
      rw [Measure.map_map (by fun_prop) (by fun_prop)]
      rfl
    _ = (gaussianReal 0 (s + t).toNNReal).map (fun y : ℝ => mu * y) := by
      rw [AppliedModelingLib.Probability.gaussianSignalPair_score_marginal
        0 s t hs ht]
    _ = gaussianReal 0
        (NNReal.mk (mu ^ 2) (sq_nonneg mu) * (s + t).toNNReal) := by
      simpa using ProbabilityTheory.gaussianReal_map_const_mul
        (μ := (0 : ℝ)) (v := (s + t).toNNReal) mu
    _ = gaussianReal 0 (transparencyWeight s t * s).toNNReal := by
      congr 1
      ext
      rw [NNReal.coe_mul, NNReal.coe_mk]
      rw [Real.coe_toNNReal _ htotal.le]
      rw [Real.coe_toNNReal _ (mul_nonneg hmu.le hs.le)]
      dsimp [mu, transparencyWeight]
      field_simp [ne_of_gt htotal]

theorem hiddenComponent_marginal
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (informationLaw s t).map (hiddenComponent s t) =
      gaussianReal 0 ((1 - transparencyWeight s t) * s).toNNReal := by
  have htotal : 0 < s + t := add_pos hs ht
  rw [hiddenComponent_eq_gaussianResidual s t hs ht]
  rw [AppliedModelingLib.Probability.gaussianSignalPair_residual_marginal
    0 s t hs ht]
  simp only [mul_zero]
  congr 1
  ext
  have hpost : 0 ≤ s * t / (s + t) := by positivity
  have hres : 0 ≤ (1 - transparencyWeight s t) * s := by
    have hmu := transparencyWeight_lt_one s t hs ht
    have : 0 ≤ 1 - transparencyWeight s t := by linarith
    positivity
  unfold AppliedModelingLib.Probability.gaussianSignalPosteriorVariance
  rw [Real.coe_toNNReal _ hpost, Real.coe_toNNReal _ hres]
  unfold transparencyWeight
  field_simp [ne_of_gt htotal]
  ring

theorem public_hidden_independent
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    publicComponent s t ⟂ᵢ[informationLaw s t] hiddenComponent s t := by
  have h :=
    AppliedModelingLib.Probability.gaussianSignalPair_score_residual_independent
      0 s t hs ht
  have hcomp := h.comp
    (φ := fun y : ℝ => transparencyWeight s t * y)
    (ψ := id) (by fun_prop) measurable_id
  rw [hiddenComponent_eq_gaussianResidual s t hs ht]
  simpa [publicComponent, Function.comp_def] using hcomp

theorem information_component_moments
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (∫ x, x ∂((informationLaw s t).map (publicComponent s t))) = 0 ∧
    Var[id; (informationLaw s t).map (publicComponent s t)] =
      transparencyWeight s t * s ∧
    (∫ x, x ∂((informationLaw s t).map (hiddenComponent s t))) = 0 ∧
    Var[id; (informationLaw s t).map (hiddenComponent s t)] =
      (1 - transparencyWeight s t) * s := by
  have hmu : 0 < transparencyWeight s t := transparencyWeight_pos s t hs ht
  have hmul : 0 ≤ transparencyWeight s t * s := mul_nonneg hmu.le hs.le
  have hres : 0 ≤ (1 - transparencyWeight s t) * s := by
    have hweight := transparencyWeight_lt_one s t hs ht
    have : 0 ≤ 1 - transparencyWeight s t := by linarith
    positivity
  rw [publicComponent_marginal s t hs ht,
    hiddenComponent_marginal s t hs ht]
  simp [Real.coe_toNNReal _ hmul, Real.coe_toNNReal _ hres]

/-- The literal conditional mean identity in Proposition 1:
`E[theta | sigma(kappa)] = kappa` almost everywhere. -/
theorem fundamental_condExp_given_publicComponent
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (informationLaw s t)[fundamental |
      MeasurableSpace.comap (publicComponent s t) Real.measurableSpace] =ᵐ[informationLaw s t]
      publicComponent s t := by
  let P := informationLaw s t
  let kappa := publicComponent s t
  let xi := hiddenComponent s t
  have hkappa_meas : @Measurable (ℝ × ℝ) ℝ
      (inferInstance : MeasurableSpace (ℝ × ℝ)) Real.measurableSpace kappa := by
    change Measurable (fun pair : ℝ × ℝ =>
      transparencyWeight s t * (pair.1 + pair.2))
    exact measurable_const.mul (measurable_fst.add measurable_snd)
  have hxi_meas : @Measurable (ℝ × ℝ) ℝ
      (inferInstance : MeasurableSpace (ℝ × ℝ)) Real.measurableSpace xi := by
    change Measurable (fun pair : ℝ × ℝ =>
      pair.1 - transparencyWeight s t * (pair.1 + pair.2))
    exact measurable_fst.sub
      (measurable_const.mul (measurable_fst.add measurable_snd))
  have hmKappa : MeasurableSpace.comap kappa Real.measurableSpace ≤
      Prod.instMeasurableSpace :=
    hkappa_meas.comap_le
  have hmXi : MeasurableSpace.comap xi Real.measurableSpace ≤
      Prod.instMeasurableSpace :=
    hxi_meas.comap_le
  letI : IsFiniteMeasure (P.trim hmKappa) := isFiniteMeasure_trim hmKappa
  have hkappa_integrable : Integrable kappa P := by
    have hmap : Integrable id (P.map kappa) := by
      rw [show P.map kappa =
          gaussianReal 0 (transparencyWeight s t * s).toNNReal by
        simpa [P, kappa] using publicComponent_marginal s t hs ht]
      exact memLp_one_iff_integrable.mp
        (memLp_id_gaussianReal (μ := 0)
          (v := (transparencyWeight s t * s).toNNReal) 1)
    simpa [Function.comp_def] using hmap.comp_measurable hkappa_meas
  have hxi_integrable : Integrable xi P := by
    have hmap : Integrable id (P.map xi) := by
      rw [show P.map xi =
          gaussianReal 0 ((1 - transparencyWeight s t) * s).toNNReal by
        simpa [P, xi] using hiddenComponent_marginal s t hs ht]
      exact memLp_one_iff_integrable.mp
        (memLp_id_gaussianReal (μ := 0)
          (v := ((1 - transparencyWeight s t) * s).toNNReal) 1)
    simpa [Function.comp_def] using hmap.comp_measurable hxi_meas
  have hkappa_cond : P[kappa |
      MeasurableSpace.comap kappa Real.measurableSpace] = kappa :=
    condExp_of_stronglyMeasurable hmKappa
      (comap_measurable kappa).stronglyMeasurable hkappa_integrable
  have hindep : Indep (MeasurableSpace.comap xi Real.measurableSpace)
      (MeasurableSpace.comap kappa Real.measurableSpace) P := by
    exact ((IndepFun_iff_Indep kappa xi P).mp
      (by simpa [P, kappa, xi] using public_hidden_independent s t hs ht)).symm
  have hxi_cond : P[xi |
      MeasurableSpace.comap kappa Real.measurableSpace] =ᵐ[P] fun _ => 0 := by
    have hcond := condExp_indep_eq hmXi hmKappa
      (comap_measurable xi).stronglyMeasurable hindep
    have hmean : ∫ pair, xi pair ∂P = 0 := by
      calc
        ∫ pair, xi pair ∂P = ∫ x, x ∂(P.map xi) := by
          simpa [Function.comp_def] using
            (integral_map hxi_meas.aemeasurable aestronglyMeasurable_id).symm
        _ = ∫ x, x ∂gaussianReal 0
            ((1 - transparencyWeight s t) * s).toNNReal := by
          rw [show P.map xi =
              gaussianReal 0 ((1 - transparencyWeight s t) * s).toNNReal by
            simpa [P, xi] using hiddenComponent_marginal s t hs ht]
        _ = 0 := by simp
    rw [hmean] at hcond
    exact hcond
  have hdecomp : fundamental = kappa + xi := by
    funext pair
    simpa [kappa, xi] using information_decomposition s t pair
  have hkappa_cond_ae : P[kappa |
      MeasurableSpace.comap kappa Real.measurableSpace] =ᵐ[P] kappa :=
    Filter.Eventually.of_forall fun pair => congrFun hkappa_cond pair
  calc
    P[fundamental | MeasurableSpace.comap kappa Real.measurableSpace] =ᵐ[P]
        P[kappa + xi | MeasurableSpace.comap kappa Real.measurableSpace] := by
      rw [hdecomp]
    _ =ᵐ[P] P[kappa | MeasurableSpace.comap kappa Real.measurableSpace] +
        P[xi | MeasurableSpace.comap kappa Real.measurableSpace] :=
      condExp_add hkappa_integrable hxi_integrable _
    _ =ᵐ[P] kappa + (fun _ => 0) :=
      hkappa_cond_ae.add hxi_cond
    _ =ᵐ[P] kappa :=
      Filter.Eventually.of_forall fun pair => by
        simp only [Pi.add_apply, add_zero]

/-- The literal residual second-moment identity in Proposition 1:
`E[xi^2 | sigma(kappa)] = (1-mu)s` almost everywhere. -/
theorem hiddenComponent_sq_condExp_given_publicComponent
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (informationLaw s t)[(fun pair => hiddenComponent s t pair ^ 2) |
      MeasurableSpace.comap (publicComponent s t) Real.measurableSpace] =ᵐ[informationLaw s t]
      fun _ => (1 - transparencyWeight s t) * s := by
  let P := informationLaw s t
  let kappa := publicComponent s t
  let xi := hiddenComponent s t
  have hkappa_meas : @Measurable (ℝ × ℝ) ℝ
      (inferInstance : MeasurableSpace (ℝ × ℝ)) Real.measurableSpace kappa := by
    change Measurable (fun pair : ℝ × ℝ =>
      transparencyWeight s t * (pair.1 + pair.2))
    exact measurable_const.mul (measurable_fst.add measurable_snd)
  have hxi_meas : @Measurable (ℝ × ℝ) ℝ
      (inferInstance : MeasurableSpace (ℝ × ℝ)) Real.measurableSpace xi := by
    change Measurable (fun pair : ℝ × ℝ =>
      pair.1 - transparencyWeight s t * (pair.1 + pair.2))
    exact measurable_fst.sub
      (measurable_const.mul (measurable_fst.add measurable_snd))
  have hmKappa : MeasurableSpace.comap kappa Real.measurableSpace ≤
      Prod.instMeasurableSpace :=
    hkappa_meas.comap_le
  have hmXi : MeasurableSpace.comap xi Real.measurableSpace ≤
      Prod.instMeasurableSpace :=
    hxi_meas.comap_le
  letI : IsFiniteMeasure (P.trim hmKappa) := isFiniteMeasure_trim hmKappa
  have hindep : Indep (MeasurableSpace.comap xi Real.measurableSpace)
      (MeasurableSpace.comap kappa Real.measurableSpace) P := by
    exact ((IndepFun_iff_Indep kappa xi P).mp
      (by simpa [P, kappa, xi] using public_hidden_independent s t hs ht)).symm
  have hcond := condExp_indep_eq hmXi hmKappa
    ((comap_measurable xi).pow_const 2).stronglyMeasurable hindep
  have hres_nonneg : 0 ≤ (1 - transparencyWeight s t) * s := by
    have hmu := transparencyWeight_lt_one s t hs ht
    exact mul_nonneg (sub_nonneg.mpr hmu.le) hs.le
  have hsecond : ∫ pair, xi pair ^ 2 ∂P =
      (1 - transparencyWeight s t) * s := by
    calc
      ∫ pair, xi pair ^ 2 ∂P = ∫ x, x ^ 2 ∂(P.map xi) := by
        simpa [Function.comp_def] using
          (integral_map hxi_meas.aemeasurable
            (by fun_prop : AEStronglyMeasurable (fun x : ℝ => x ^ 2) (P.map xi))).symm
      _ = ∫ x, x ^ 2 ∂gaussianReal 0
          ((1 - transparencyWeight s t) * s).toNNReal := by
        rw [show P.map xi =
            gaussianReal 0 ((1 - transparencyWeight s t) * s).toNNReal by
          simpa [P, xi] using hiddenComponent_marginal s t hs ht]
      _ = ((1 - transparencyWeight s t) * s).toNNReal := by
        rw [← variance_id_gaussianReal (μ := 0)]
        rw [variance_eq_integral measurable_id.aemeasurable]
        simp
      _ = (1 - transparencyWeight s t) * s :=
        Real.coe_toNNReal _ hres_nonneg
  rw [hsecond] at hcond
  simpa [P, kappa, xi] using hcond

/-- Proposition 1's conditional-variance statement, formally connected to
the two preceding conditional expectations. -/
theorem fundamental_condVar_given_publicComponent
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    Var[fundamental; informationLaw s t |
      MeasurableSpace.comap (publicComponent s t) Real.measurableSpace] =ᵐ[informationLaw s t]
      fun _ => (1 - transparencyWeight s t) * s := by
  unfold ProbabilityTheory.condVar
  refine (condExp_congr_ae ?_).trans
    (hiddenComponent_sq_condExp_given_publicComponent s t hs ht)
  filter_upwards [fundamental_condExp_given_publicComponent s t hs ht] with pair hpair
  simp only [Pi.sub_apply, Pi.pow_apply]
  rw [hpair]
  rfl

/-- The exact posterior law.  Since `publicComponent = mu * publicReport`
with `mu > 0` (proved below), this is also conditioning on the public
component, not merely an algebraic moment identity. -/
theorem latent_condDistrib_given_publicReport
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) :
    ⇑(condDistrib fundamental publicReport (informationLaw s t)) =ᶠ[
      ae ((informationLaw s t).map publicReport)]
      (fun report : ℝ =>
        gaussianReal (posteriorMean s t report) (residualVariance s t).toNNReal) := by
  have h :=
    AppliedModelingLib.Probability.gaussianSignal_condDistrib_latent_given_score
      0 s t hs ht
  filter_upwards [h] with report hreport
  rw [hreport]
  congr 1
  simp [posteriorMean, transparencyWeight,
    AppliedModelingLib.Probability.gaussianSignalWeight,
    AppliedModelingLib.Probability.gaussianSignalPriorWeight]

theorem posterior_kernel_mean_variance
    (s t report : ℝ) (hs : 0 < s) (ht : 0 < t) :
    (∫ theta, theta ∂gaussianReal (posteriorMean s t report)
      (residualVariance s t).toNNReal) = posteriorMean s t report ∧
    Var[id; gaussianReal (posteriorMean s t report)
      (residualVariance s t).toNNReal] = residualVariance s t := by
  have htotal : 0 < s + t := add_pos hs ht
  have hres : 0 ≤ residualVariance s t := by
    unfold residualVariance
    positivity
  simp [Real.coe_toNNReal _ hres]

theorem report_recovered_from_publicComponent
    (s t : ℝ) (hs : 0 < s) (ht : 0 < t) (pair : ℝ × ℝ) :
    publicComponent s t pair / transparencyWeight s t = publicReport pair := by
  unfold publicComponent
  field_simp [ne_of_gt (transparencyWeight_pos s t hs ht)]

/-- Literal integration over independent signal noise proves
`E[kappa | theta] = mu * theta`. -/
theorem publicComponent_mean_given_fundamental
    (s t theta : ℝ) (ht : 0 ≤ t) :
    (∫ eta, transparencyWeight s t * (theta + eta)
      ∂gaussianReal 0 t.toNNReal) = transparencyWeight s t * theta := by
  have hid : Integrable id (gaussianReal 0 t.toNNReal) := by
    exact memLp_one_iff_integrable.mp
      (memLp_id_gaussianReal (μ := 0) (v := t.toNNReal) 1)
  have hlinear : Integrable
      (fun eta : ℝ => transparencyWeight s t * eta)
      (gaussianReal 0 t.toNNReal) := by
    simpa only [id_eq] using hid.const_mul (transparencyWeight s t)
  have hfun :
      (fun eta : ℝ => transparencyWeight s t * (theta + eta)) =
        (fun eta : ℝ => transparencyWeight s t * theta +
          transparencyWeight s t * eta) := by
    funext eta
    ring
  rw [hfun, integral_add (integrable_const _) hlinear]
  have hconst :
      (∫ _eta : ℝ, transparencyWeight s t * theta
        ∂gaussianReal 0 t.toNNReal) = transparencyWeight s t * theta := by simp
  have hzero :
      (∫ eta : ℝ, transparencyWeight s t * eta
        ∂gaussianReal 0 t.toNNReal) = 0 := by
    rw [integral_const_mul, integral_id_gaussianReal]
    ring
  rw [hconst, hzero]
  ring

theorem fundamental_marginal (s t : ℝ) :
    (informationLaw s t).map fundamental = gaussianReal 0 s.toNNReal := by
  change ((gaussianReal 0 s.toNNReal).prod
    (gaussianReal 0 t.toNNReal)).map Prod.fst = gaussianReal 0 s.toNNReal
  rw [Measure.map_fst_prod]
  simp

private theorem fundamental_integrable (s t : ℝ) :
    Integrable fundamental (informationLaw s t) := by
  have hmap : Integrable id ((informationLaw s t).map fundamental) := by
    rw [fundamental_marginal]
    exact memLp_one_iff_integrable.mp
      (memLp_id_gaussianReal (μ := 0) (v := s.toNNReal) 1)
  simpa [Function.comp_def] using hmap.comp_measurable measurable_fst

private theorem fundamental_mean (s t : ℝ) :
    ∫ pair, fundamental pair ∂informationLaw s t = 0 := by
  calc
    ∫ pair, fundamental pair ∂informationLaw s t =
        ∫ x, x ∂((informationLaw s t).map fundamental) := by
      simpa [Function.comp_def] using
        (integral_map (μ := informationLaw s t) (φ := fundamental) (f := id)
          measurable_fst.aemeasurable
          (by fun_prop : AEStronglyMeasurable (fun x : ℝ => x)
            ((informationLaw s t).map fundamental))).symm
    _ = ∫ x, x ∂gaussianReal 0 s.toNNReal := by rw [fundamental_marginal]
    _ = 0 := by simp

private theorem fundamental_secondMoment
    (s t : ℝ) (hs : 0 ≤ s) :
    ∫ pair, fundamental pair ^ 2 ∂informationLaw s t = s := by
  calc
    ∫ pair, fundamental pair ^ 2 ∂informationLaw s t =
        ∫ x, x ^ 2 ∂((informationLaw s t).map fundamental) := by
      simpa [Function.comp_def] using
        (integral_map measurable_fst.aemeasurable
          (by fun_prop : AEStronglyMeasurable (fun x : ℝ => x ^ 2)
            ((informationLaw s t).map fundamental))).symm
    _ = ∫ x, x ^ 2 ∂gaussianReal 0 s.toNNReal := by rw [fundamental_marginal]
    _ = s.toNNReal := by
      rw [← variance_id_gaussianReal (μ := 0)]
      rw [variance_eq_integral measurable_id.aemeasurable]
      simp
    _ = s := Real.coe_toNNReal s hs

/-- At the no-signal endpoint, `kappa = 0` and `xi = theta` retain the
Gaussian laws and are independent. -/
theorem noSignal_components_gaussian_independent (s t : ℝ) :
    (informationLaw s t).map
        (fun pair => noSignalPublic (fundamental pair)) = gaussianReal 0 0 ∧
    (informationLaw s t).map
        (fun pair => noSignalHidden (fundamental pair)) = gaussianReal 0 s.toNNReal ∧
    (fun pair => noSignalPublic (fundamental pair)) ⟂ᵢ[informationLaw s t]
      (fun pair => noSignalHidden (fundamental pair)) := by
  constructor
  · simp [noSignalPublic, gaussianReal_zero_var]
  constructor
  · simpa [noSignalHidden] using fundamental_marginal s t
  · simpa [noSignalPublic, noSignalHidden] using
      (indepFun_const_left (μ := informationLaw s t) (0 : ℝ) fundamental)

/-- At the full-signal endpoint, `kappa = theta` and `xi = 0` retain the
Gaussian laws and are independent. -/
theorem fullSignal_components_gaussian_independent (s t : ℝ) :
    (informationLaw s t).map
        (fun pair => fullSignalPublic (fundamental pair)) = gaussianReal 0 s.toNNReal ∧
    (informationLaw s t).map
        (fun pair => fullSignalHidden (fundamental pair)) = gaussianReal 0 0 ∧
    (fun pair => fullSignalPublic (fundamental pair)) ⟂ᵢ[informationLaw s t]
      (fun pair => fullSignalHidden (fundamental pair)) := by
  constructor
  · simpa [fullSignalPublic] using fundamental_marginal s t
  constructor
  · simp [fullSignalHidden, gaussianReal_zero_var]
  · simpa [fullSignalPublic, fullSignalHidden] using
      (indepFun_const_right (μ := informationLaw s t) fundamental (0 : ℝ))

/-- Literal no-signal conditional mean: conditioning on `kappa = 0` leaves
the centered fundamental mean equal to zero. -/
theorem noSignal_fundamental_condExp
    (s t : ℝ) :
    (informationLaw s t)[fundamental |
      MeasurableSpace.comap
        (fun pair => noSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun pair => noSignalPublic (fundamental pair) := by
  simpa [noSignalPublic, condExp_bot] using fundamental_mean s t

/-- Literal no-signal residual second moment.  Together with the preceding
zero conditional mean, this is residual conditional variance `s`. -/
theorem noSignal_hidden_sq_condExp
    (s t : ℝ) (hs : 0 ≤ s) :
    (informationLaw s t)[
      (fun pair => noSignalHidden (fundamental pair) ^ 2) |
      MeasurableSpace.comap
        (fun pair => noSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun _ => s := by
  simpa [noSignalPublic, noSignalHidden, condExp_bot] using
    fundamental_secondMoment s t hs

theorem noSignal_fundamental_condVar
    (s t : ℝ) (hs : 0 ≤ s) :
    Var[fundamental; informationLaw s t |
      MeasurableSpace.comap
        (fun pair => noSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun _ => s := by
  unfold ProbabilityTheory.condVar
  refine (condExp_congr_ae ?_).trans (noSignal_hidden_sq_condExp s t hs)
  filter_upwards [noSignal_fundamental_condExp s t] with pair hpair
  simp only [Pi.sub_apply, Pi.pow_apply]
  rw [hpair]
  simp [noSignalPublic, noSignalHidden]

/-- Literal full-signal conditional mean: conditioning on `kappa = theta`
recovers the fundamental itself. -/
theorem fullSignal_fundamental_condExp
    (s t : ℝ) :
    (informationLaw s t)[fundamental |
      MeasurableSpace.comap
        (fun pair => fullSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun pair => fullSignalPublic (fundamental pair) := by
  have hle : MeasurableSpace.comap fundamental Real.measurableSpace ≤
      Prod.instMeasurableSpace := measurable_fst.comap_le
  letI : IsFiniteMeasure ((informationLaw s t).trim hle) :=
    isFiniteMeasure_trim hle
  have hcond : (informationLaw s t)[fundamental |
      MeasurableSpace.comap fundamental Real.measurableSpace] = fundamental :=
    condExp_of_stronglyMeasurable hle
      (comap_measurable fundamental).stronglyMeasurable
      (fundamental_integrable s t)
  simpa [fullSignalPublic] using
    (Filter.Eventually.of_forall fun pair => congrFun hcond pair)

/-- Literal full-signal residual second moment (and hence conditional
variance) is zero. -/
theorem fullSignal_hidden_sq_condExp
    (s t : ℝ) :
    (informationLaw s t)[
      (fun pair => fullSignalHidden (fundamental pair) ^ 2) |
      MeasurableSpace.comap
        (fun pair => fullSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun _ => 0 := by
  have hfun : (fun pair : ℝ × ℝ =>
      fullSignalHidden (fundamental pair) ^ 2) = (0 : (ℝ × ℝ) → ℝ) := by
    funext pair
    simp [fullSignalHidden]
  rw [hfun]
  change (informationLaw s t)[(0 : (ℝ × ℝ) → ℝ) |
    MeasurableSpace.comap fundamental Real.measurableSpace] =ᵐ[informationLaw s t]
      (fun _ => (0 : ℝ))
  rw [condExp_zero]
  exact Filter.Eventually.of_forall (fun _ => rfl)

theorem fullSignal_fundamental_condVar
    (s t : ℝ) :
    Var[fundamental; informationLaw s t |
      MeasurableSpace.comap
        (fun pair => fullSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[
          informationLaw s t]
      fun _ => 0 := by
  unfold ProbabilityTheory.condVar
  refine (condExp_congr_ae ?_).trans (fullSignal_hidden_sq_condExp s t)
  filter_upwards [fullSignal_fundamental_condExp s t] with pair hpair
  simp only [Pi.sub_apply, Pi.pow_apply]
  rw [hpair]
  simp [fullSignalPublic, fullSignalHidden]

theorem information_endpoints (theta : ℝ) :
    noSignalPublic theta = 0 ∧ noSignalHidden theta = theta ∧
    theta = noSignalPublic theta + noSignalHidden theta ∧
    fullSignalPublic theta = theta ∧ fullSignalHidden theta = 0 ∧
    theta = fullSignalPublic theta + fullSignalHidden theta := by
  simp [noSignalPublic, noSignalHidden, fullSignalPublic, fullSignalHidden]

end

end Olano26Transparencia
