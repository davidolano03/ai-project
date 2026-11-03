import Olano26Transparencia.Model
import Olano26Transparencia.Assumptions
import Mathlib.Probability.CondVar

/-!
# Human-Facing Paper Interface: Transparencia, sentimiento y fundamentos: Una corrección de la información parcial en Zhang y Zhang (2023)

This is the compact Lean file a human should read after formalization to check
whether the paper's definitions and named theorem statements were represented
correctly. Keep the row-level dashboard and LLM audit statements in this file
for every paper. Move implementation details, proof aliases, and bulky helper
lemmas behind imported modules such as `AuditInterface.lean`, but expose the
audited paper-facing statements directly here; do not use
`paper_interface.audit_surface_path`.

Rules for completing this file:

- Keep the paper's definitions/formatted objects first, in source order.
- Expose the actual paper formulas here; do not only point to generic library
  definitions or implementation witnesses.
- A material reusable `AppliedModelingLib` primitive may remain a reference here only
  after `audit/library_semantic_review.json` records its exact bounded library
  declaration and an explicit byte-pinned paper-source connection. The
  dashboard and human-review packet show and source-check that declaration
  before the dependent Spec; a library name, docstring, or glossary is not a
  semantic bridge. Do not add a duplicate paper claim merely to restate it.
- If a named theorem needs a hypothesis that is not derived from earlier Lean
  declarations, declare that hypothesis in `Assumptions.lean` and list it in
  `status.json` `review_surface.assumption_names`.
- Then state the named results directly, with assumptions visible in each
  theorem signature by referencing named paper assumptions imported from
  `Assumptions.lean`.
- In the statement-first phase, write every complete source-facing statement as
  a transparent `<name>Spec : Prop` here, exactly once. Put the paired
  theorem/lemma of that exact type in `ProofInterface.lean`; its temporary
  proof body may be `by sorry` only in a private draft. This separation keeps
  the human semantic surface free of thin wrapper declarations.
- Before drafting that Lean surface, independently inventory every material
  source atom from exact pinned source quote bytes. Do not infer source atoms
  from declaration, binder, field, function, or source-map names.
- Run raw-source-to-expanded-Spec statement matching plus Lean-emitted
  premise/conclusion claim-atom review on the skeleton. The semantic comparison uses
  only byte-pinned source quotes (and separately pinned source context) against
  the expanded transparent Spec; map summaries and proof wrappers are not
  semantic inputs. Then freeze each canonical Lean declaration-manifest digest.
- In the proof phase, replace the `ProofInterface.lean` `sorry` with a short
  proof that calls into `MainTheorems.lean` or lower proof files without
  changing the specification or theorem type. Any specification/type change
  invalidates the freeze and requires a fresh statement audit.
- At formalized closeout, complete the v11 realization receipt: Lean Meta checks
  the theorem has exactly the transparent Spec type; each source atom is bound
  to the elaborated Spec surface; closure traversal includes proof and instance
  arguments; and every material terminal has a source, approved correction or
  additional assumption, checked derivation, or version-pinned foundation
  disposition. No data, container, or identifier-based exemption is allowed.
- The transparent `...Spec` is the sole semantic-review target for its source
  claim. The paired theorem/lemma is a proof endpoint whose exact Spec type is
  verified by Lean Meta, not a duplicate source-to-Lean comparison row.
- Keep proof endpoints, exhaustive endpoint aliases, and proof-seam checks in
  `ProofInterface.lean`, implementation modules, or `ProofLedger.lean`, not
  here. Do not create new `PostPaperAudit.lean` or `AuditLedger.lean` files;
  those names are legacy.

## Named Results

Each entry has one semantic-review target (`Spec`) and one proof endpoint (the
paired theorem/lemma). The human dashboard and review packet present that pair
once rather than treating the two declarations as duplicate paper claims.

- None yet. This interface is intentionally empty because no source-pinned statement spec was supplied.
-/

namespace Olano26Transparencia

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory

noncomputable section

/-- Proposition 1: Gaussian information decomposition, conditional moments,
and the explicitly defined no-signal/full-signal endpoint models. -/
def informationDecompositionSpec : Prop :=
  (∀ s t : ℝ, 0 < s → 0 < t →
    (∀ pair : ℝ × ℝ,
      fundamental pair = publicComponent s t pair + hiddenComponent s t pair) ∧
    (informationLaw s t).map (publicComponent s t) =
      gaussianReal 0 (transparencyWeight s t * s).toNNReal ∧
    (informationLaw s t).map (hiddenComponent s t) =
      gaussianReal 0 ((1 - transparencyWeight s t) * s).toNNReal ∧
    publicComponent s t ⟂ᵢ[informationLaw s t] hiddenComponent s t ∧
    ((∫ x, x ∂((informationLaw s t).map (publicComponent s t))) = 0 ∧
      Var[id; (informationLaw s t).map (publicComponent s t)] =
        transparencyWeight s t * s ∧
      (∫ x, x ∂((informationLaw s t).map (hiddenComponent s t))) = 0 ∧
      Var[id; (informationLaw s t).map (hiddenComponent s t)] =
        (1 - transparencyWeight s t) * s) ∧
    (⇑(condDistrib fundamental publicReport (informationLaw s t)) =ᶠ[
      ae ((informationLaw s t).map publicReport)]
      (fun report : ℝ =>
        gaussianReal (posteriorMean s t report) (residualVariance s t).toNNReal)) ∧
    (∀ report : ℝ,
      (∫ theta, theta ∂gaussianReal (posteriorMean s t report)
        (residualVariance s t).toNNReal) = posteriorMean s t report ∧
      Var[id; gaussianReal (posteriorMean s t report)
        (residualVariance s t).toNNReal] = residualVariance s t) ∧
    (∀ pair : ℝ × ℝ,
      publicComponent s t pair / transparencyWeight s t = publicReport pair) ∧
    (∀ theta : ℝ,
      (∫ eta, transparencyWeight s t * (theta + eta)
        ∂gaussianReal 0 t.toNNReal) = transparencyWeight s t * theta) ∧
    ((informationLaw s t)[fundamental |
      MeasurableSpace.comap (publicComponent s t) Real.measurableSpace] =ᵐ[informationLaw s t]
        publicComponent s t) ∧
    (Var[fundamental; informationLaw s t |
      MeasurableSpace.comap (publicComponent s t) Real.measurableSpace] =ᵐ[informationLaw s t]
        fun _ => (1 - transparencyWeight s t) * s)) ∧
  (∀ theta : ℝ,
    noSignalPublic theta = 0 ∧ noSignalHidden theta = theta ∧
    theta = noSignalPublic theta + noSignalHidden theta ∧
    fullSignalPublic theta = theta ∧ fullSignalHidden theta = 0 ∧
    theta = fullSignalPublic theta + fullSignalHidden theta) ∧
  (∀ s : ℝ, 0 < s →
    ((informationLaw s 0).map (fun pair => noSignalPublic (fundamental pair)) = gaussianReal 0 0 ∧
      (informationLaw s 0).map (fun pair => noSignalHidden (fundamental pair)) = gaussianReal 0 s.toNNReal ∧
      (fun pair => noSignalPublic (fundamental pair)) ⟂ᵢ[informationLaw s 0]
        (fun pair => noSignalHidden (fundamental pair))) ∧
    ((informationLaw s 0).map (fun pair => fullSignalPublic (fundamental pair)) = gaussianReal 0 s.toNNReal ∧
      (informationLaw s 0).map (fun pair => fullSignalHidden (fundamental pair)) = gaussianReal 0 0 ∧
      (fun pair => fullSignalPublic (fundamental pair)) ⟂ᵢ[informationLaw s 0]
        (fun pair => fullSignalHidden (fundamental pair))) ∧
    ((informationLaw s 0)[fundamental |
      MeasurableSpace.comap (fun pair => noSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[informationLaw s 0]
        fun pair => noSignalPublic (fundamental pair)) ∧
    (Var[fundamental; informationLaw s 0 |
      MeasurableSpace.comap (fun pair => noSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[informationLaw s 0]
        fun _ => s) ∧
    ((informationLaw s 0)[fundamental |
      MeasurableSpace.comap (fun pair => fullSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[informationLaw s 0]
        fun pair => fullSignalPublic (fundamental pair)) ∧
    (Var[fundamental; informationLaw s 0 |
      MeasurableSpace.comap (fun pair => fullSignalPublic (fundamental pair)) Real.measurableSpace] =ᵐ[informationLaw s 0]
        fun _ => 0))

/-- Proposition 2 (`prop:demand`): the stated demand is the unique maximizer
of literal expected CARA utility under a Gaussian belief. -/
def optimalDemandSpec : Prop :=
  ∀ mean variance c R price riskAversion : ℝ,
    0 < variance → 0 < riskAversion →
    (∀ position : ℝ,
      expectedCARAUtility mean variance c R price riskAversion position ≤
        expectedCARAUtility mean variance c R price riskAversion
          (optimalDemand mean variance R price riskAversion)) ∧
    (∀ position : ℝ,
      expectedCARAUtility mean variance c R price riskAversion position =
        expectedCARAUtility mean variance c R price riskAversion
          (optimalDemand mean variance R price riskAversion) ↔
      position = optimalDemand mean variance R price riskAversion)

/-- Proposition 3 (`prop:price`): unique unit-supply price and its Gaussian
conditional expectation `C(mu) + K(mu) theta`. -/
def priceSensitivitySpec : Prop :=
  (∀ (M : FixedMarket) (mu theta kappa : ℝ),
    0 ≤ mu → mu ≤ 1 →
    ∀ price : ℝ,
      M.aggregateDemand mu theta kappa price = 1 ↔
        price = M.equilibriumPrice mu theta kappa) ∧
  (∀ (M : FixedMarket) (t theta : ℝ), 0 ≤ t →
    M.expectedPriceGivenFundamental t theta =
      M.priceIntercept (transparencyWeight M.s t) +
        M.sensitivity (transparencyWeight M.s t) * theta) ∧
  (∀ (M : FixedMarket) (theta : ℝ),
    M.equilibriumPrice 0 theta 0 =
      M.priceIntercept 0 + M.sensitivity 0 * theta)

/-- Proposition 4 (`prop:main`), including strict finite changes, bounds, and
the full-information endpoint. -/
def fixedSentimentMonotonicitySpec : Prop :=
  ∀ M : FixedMarket,
    (∀ x y : ℝ, 0 ≤ x → x < y → y ≤ 1 →
      M.sensitivity x < M.sensitivity y) ∧
    (∀ mu : ℝ, 0 ≤ mu → mu ≤ 1 →
      0 < M.sensitivity mu ∧ M.sensitivity mu ≤ 1 / M.R) ∧
    M.sensitivity 1 = 1 / M.R

/-- Proposition 5, clauses (i)--(iv), including the logarithmic
trajectory, exact threshold, exact rational comparison, and endpoint. -/
def endogenousSentimentSpec : Prop :=
  (∀ M : EndogenousMarket,
    (∀ mu : ℝ, 0 ≤ mu → mu ≤ 1 →
      HasDerivWithinAt M.sensitivity
        (endogenousDerivativeNumerator mu (M.a mu) (M.aPrime mu)
            (M.B mu) (M.BPrime mu) /
          (M.R * (M.a mu + M.B mu) ^ 2)) (Set.Icc (0 : ℝ) 1) mu) ∧
    ((∀ mu ∈ Set.Icc (0 : ℝ) 1, 0 ≤ derivWithin M.rho1 (Set.Icc (0 : ℝ) 1) mu) →
      (∀ mu ∈ Set.Icc (0 : ℝ) 1, derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu ≤ 0) →
      StrictMonoOn M.sensitivity (Set.Icc (0 : ℝ) 1)) ∧
    (∀ mu constant : ℝ, 0 ≤ mu → mu ≤ 1 →
      Set.EqOn M.rho1 (fun _ => constant) (Set.Icc (0 : ℝ) 1) →
      (0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu ↔ 0 < endogenousRetailBracket M mu) ∧
      ((1 - mu) * M.b * derivWithin M.rho2 (Set.Icc (0 : ℝ) 1) mu ≤ M.e4 / M.d4 mu →
        0 < derivWithin M.sensitivity (Set.Icc (0 : ℝ) 1) mu)) ∧
    M.sensitivity 1 = 1 / M.R) ∧
  (∀ b c mu : ℝ, 0 < b → -1 < c → 0 ≤ mu → mu ≤ 1 →
    counterLogTrajectorySensitivity b c mu = counterTrajectorySensitivity c mu) ∧
  (∀ c : ℝ, -1 < c →
    (deriv (counterTrajectorySensitivity c) 0 < 0 ↔ c > 101 / 36)) ∧
  (counterTrajectorySensitivity 5 (1 / 10) = 1768 / 2803 ∧
    counterTrajectorySensitivity 5 (1 / 10) < 9 / 14) ∧
  (∀ c : ℝ, -1 < c → counterTrajectorySensitivity c 1 = 1)

end

end Olano26Transparencia
