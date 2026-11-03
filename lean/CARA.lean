import Olano26Transparencia.Model

/-!
# Gaussian CARA choice

This file closes the probabilistic gap explicitly identified in the source
appendix: expected utility is evaluated as an integral against `gaussianReal`.
The final completing-the-square argument is adapted from the author's supplied
read-only `BaselineAudit.lean`; unlike that preliminary file, the theorem here
also proves the Gaussian integral and uniqueness for expected utility itself.
-/

namespace Olano26Transparencia

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal ProbabilityTheory

noncomputable section

theorem expectedCARAUtility_eq_certaintyEquivalent
    (mean variance c R price riskAversion position : ℝ)
    (hvariance : 0 ≤ variance) :
    expectedCARAUtility mean variance c R price riskAversion position =
      -Real.exp (-riskAversion *
        certaintyEquivalent mean variance c R price riskAversion position) := by
  let q : ℝ := -riskAversion * position
  let A : ℝ := -riskAversion * c +
    riskAversion * position * R * price
  have hintegrand :
      (fun payoff : ℝ =>
        -Real.exp (-riskAversion *
          terminalWealth c R price position payoff)) =
      (fun payoff : ℝ => -Real.exp A * Real.exp (q * payoff)) := by
    funext payoff
    have hexponent :
        -riskAversion * terminalWealth c R price position payoff =
          A + q * payoff := by
      dsimp [A, q, terminalWealth]
      ring
    rw [hexponent, Real.exp_add]
    ring
  unfold expectedCARAUtility
  rw [hintegrand, integral_const_mul]
  change -Real.exp A * mgf id (gaussianReal mean variance.toNNReal) q = _
  rw [mgf_id_gaussianReal]
  change -Real.exp A *
      Real.exp (mean * q + (↑variance.toNNReal : ℝ) * q ^ 2 / 2) = _
  calc
    -Real.exp A *
        Real.exp (mean * q + (↑variance.toNNReal : ℝ) * q ^ 2 / 2) =
        -Real.exp (A +
          (mean * q + (↑variance.toNNReal : ℝ) * q ^ 2 / 2)) := by
          have hexp := Real.exp_add A
            (mean * q + (↑variance.toNNReal : ℝ) * q ^ 2 / 2)
          rw [hexp]
          ring
    _ = -Real.exp (-riskAversion *
        certaintyEquivalent mean variance c R price riskAversion position) := by
      congr 2
      rw [Real.coe_toNNReal _ hvariance]
      dsimp [A, q, certaintyEquivalent]
      ring

theorem certaintyEquivalent_completion
    (mean variance c R price riskAversion position : ℝ)
    (hprod : riskAversion * variance ≠ 0) :
    certaintyEquivalent mean variance c R price riskAversion position =
      certaintyEquivalent mean variance c R price riskAversion
        (optimalDemand mean variance R price riskAversion) -
      (riskAversion * variance) / 2 *
        (position - optimalDemand mean variance R price riskAversion) ^ 2 := by
  rcases mul_ne_zero_iff.mp hprod with ⟨hrisk, hvariance⟩
  unfold certaintyEquivalent optimalDemand
  field_simp [hrisk, hvariance, hprod]
  ring

/-- Proposition 2: the literal Gaussian expected-CARA objective has the stated
unique global maximizer. -/
theorem expectedCARAUtility_unique_maximizer
    (mean variance c R price riskAversion : ℝ)
    (hvariance : 0 < variance) (hrisk : 0 < riskAversion) :
    (∀ position : ℝ,
      expectedCARAUtility mean variance c R price riskAversion position ≤
        expectedCARAUtility mean variance c R price riskAversion
          (optimalDemand mean variance R price riskAversion)) ∧
    (∀ position : ℝ,
      expectedCARAUtility mean variance c R price riskAversion position =
        expectedCARAUtility mean variance c R price riskAversion
          (optimalDemand mean variance R price riskAversion) ↔
      position = optimalDemand mean variance R price riskAversion) := by
  let optimum := optimalDemand mean variance R price riskAversion
  have hprod : 0 < riskAversion * variance := mul_pos hrisk hvariance
  have hformula (position : ℝ) :
      expectedCARAUtility mean variance c R price riskAversion position =
        -Real.exp (-riskAversion *
          certaintyEquivalent mean variance c R price riskAversion position) :=
    expectedCARAUtility_eq_certaintyEquivalent
      mean variance c R price riskAversion position hvariance.le
  have hCE (position : ℝ) :
      certaintyEquivalent mean variance c R price riskAversion position =
        certaintyEquivalent mean variance c R price riskAversion optimum -
          (riskAversion * variance) / 2 * (position - optimum) ^ 2 := by
    simpa [optimum] using certaintyEquivalent_completion
      mean variance c R price riskAversion position (ne_of_gt hprod)
  constructor
  · intro position
    rw [hformula position, hformula optimum]
    have hsquare : 0 ≤ (position - optimum) ^ 2 := sq_nonneg _
    have hce :
        certaintyEquivalent mean variance c R price riskAversion position ≤
          certaintyEquivalent mean variance c R price riskAversion optimum := by
      rw [hCE position]
      nlinarith
    have hexp :
        Real.exp (-riskAversion *
            certaintyEquivalent mean variance c R price riskAversion optimum) ≤
          Real.exp (-riskAversion *
            certaintyEquivalent mean variance c R price riskAversion position) := by
      exact Real.exp_le_exp.mpr (by nlinarith)
    linarith
  · intro position
    constructor
    · intro heq
      rw [hformula position, hformula optimum] at heq
      have hexp :
          -riskAversion *
              certaintyEquivalent mean variance c R price riskAversion position =
            -riskAversion *
              certaintyEquivalent mean variance c R price riskAversion optimum := by
        apply Real.exp_injective
        linarith
      have hce :
          certaintyEquivalent mean variance c R price riskAversion position =
            certaintyEquivalent mean variance c R price riskAversion optimum := by
        nlinarith
      rw [hCE position] at hce
      have hsquare : (position - optimum) ^ 2 = 0 := by
        nlinarith
      nlinarith [sq_nonneg (position - optimum)]
    · intro hposition
      simpa [hposition]

end

end Olano26Transparencia
