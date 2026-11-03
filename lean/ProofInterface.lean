import Olano26Transparencia.MainTheorems
import Olano26Transparencia.PaperInterface

/-! Exact-type endpoints for the five source-facing Specs.
The independent semantic closeout is recorded by the workflow artifacts. -/
namespace Olano26Transparencia
noncomputable section

theorem informationDecomposition : informationDecompositionSpec := by
  constructor
  · intro s t hs ht
    exact ⟨information_decomposition s t,
      publicComponent_marginal s t hs ht,
      hiddenComponent_marginal s t hs ht,
      public_hidden_independent s t hs ht,
      information_component_moments s t hs ht,
      latent_condDistrib_given_publicReport s t hs ht,
      fun report => posterior_kernel_mean_variance s t report hs ht,
      report_recovered_from_publicComponent s t hs ht,
      fun theta => publicComponent_mean_given_fundamental s t theta ht.le,
      fundamental_condExp_given_publicComponent s t hs ht,
      fundamental_condVar_given_publicComponent s t hs ht⟩
  · constructor
    · exact information_endpoints
    · intro s hs
      exact ⟨noSignal_components_gaussian_independent s 0,
        fullSignal_components_gaussian_independent s 0,
        noSignal_fundamental_condExp s 0,
        noSignal_fundamental_condVar s 0 hs.le,
        fullSignal_fundamental_condExp s 0,
        fullSignal_fundamental_condVar s 0⟩

theorem optimalDemandResult : optimalDemandSpec := by
  exact expectedCARAUtility_unique_maximizer

theorem priceSensitivity : priceSensitivitySpec := by
  refine ⟨?_, FixedMarket.expectedPriceGivenFundamental_eq,
    FixedMarket.noSignalPrice_eq⟩
  · intro M mu theta kappa h0 h1 price
    exact M.marketClearing_iff_uniquePrice mu theta kappa price h1

theorem fixedSentimentMonotonicity : fixedSentimentMonotonicitySpec := by
  exact FixedMarket.fixedSentimentSensitivity

theorem endogenousSentiment : endogenousSentimentSpec := by
  refine ⟨?_, counterLogTrajectorySensitivity_eq, ?_,
    counterTrajectory_c5_exact, counterTrajectory_fullInformation⟩
  · intro M
    refine ⟨?_, M.strictMonoOn_sensitivity_of_sentiment_signs,
      M.constantInstitutionCriterion, M.fullInformationSensitivity⟩
    intro mu h0 h1
    exact M.hasDerivWithinAt_sensitivity mu ⟨h0,h1⟩
  · intro c hc
    exact counterTrajectory_deriv_zero_lt_iff c

#print axioms informationDecomposition
#print axioms optimalDemandResult
#print axioms priceSensitivity
#print axioms fixedSentimentMonotonicity
#print axioms endogenousSentiment
end
end Olano26Transparencia
