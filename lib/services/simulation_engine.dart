import '../calculators/fiscal_policy_calculator.dart';
import '../calculators/gdp_calculator.dart';
import '../calculators/inflation_calculator.dart';
import '../calculators/labor_calculator.dart';
import '../calculators/monetary_policy_calculator.dart';
import '../calculators/stability_calculator.dart';
import '../models/economy_state.dart';
import '../models/policy_settings.dart';

/// Motor que combina las calculadoras para simular periodos economicos.
///
/// El modelo es determinista: con la misma politica y el mismo estado inicial
/// siempre entrega el mismo resultado.
class SimulationEngine {
  const SimulationEngine._();

  /// Numero minimo de periodos que se pueden simular.
  static const int minPeriods = 1;

  /// Numero maximo de periodos que se pueden simular.
  static const int maxPeriods = 5;

  /// Impulso total de demanda generado por la politica economica.
  static double demandImpulse(PolicySettings policy) {
    final fiscal = FiscalPolicyCalculator.fiscalImpulse(policy);
    final monetary = MonetaryPolicyCalculator.monetaryImpulse(policy);
    return fiscal + monetary;
  }

  /// Ejecuta un periodo y devuelve el nuevo estado de la economia.
  static EconomyState runPeriod({
    required EconomyState state,
    required PolicySettings policy,
  }) {
    policy.validate();
    final impulse = demandImpulse(policy);
    final growth = GdpCalculator.growth(
      demandImpulse: impulse,
      publicDebt: state.publicDebt,
      inflation: state.inflation,
    );
    final inflation = InflationCalculator.nextInflation(
      currentInflation: state.inflation,
      inflationTarget: policy.inflationTarget,
      demandImpulse: impulse,
      unemployment: state.unemployment,
    );
    final unemployment = LaborCalculator.nextUnemployment(
      unemployment: state.unemployment,
      gdpGrowth: growth,
    );
    final gdp = GdpCalculator.nextGdp(gdp: state.gdp, growth: growth);
    final deficit = FiscalPolicyCalculator.fiscalDeficit(
      policy: policy,
      gdpGrowth: growth,
      publicDebt: state.publicDebt,
    );
    final debt = FiscalPolicyCalculator.nextPublicDebt(
      publicDebt: state.publicDebt,
      fiscalDeficit: deficit,
      gdpGrowth: growth,
      inflation: inflation,
    );
    final stability = StabilityCalculator.index(
      inflation: inflation,
      inflationTarget: policy.inflationTarget,
      unemployment: unemployment,
      publicDebt: debt,
      fiscalDeficit: deficit,
      gdpGrowth: growth,
    );
    return EconomyState(
      period: state.period + 1,
      gdp: gdp,
      gdpGrowth: growth,
      consumption: GdpCalculator.consumption(gdp: gdp, policy: policy),
      investment: GdpCalculator.investment(gdp: gdp, policy: policy),
      publicSpending: GdpCalculator.publicSpending(gdp: gdp, policy: policy),
      inflation: inflation,
      unemployment: unemployment,
      fiscalDeficit: deficit,
      publicDebt: debt,
      stabilityIndex: stability,
      policy: policy,
    );
  }

  /// Ejecuta entre [minPeriods] y [maxPeriods] periodos consecutivos.
  static List<EconomyState> runPeriods({
    required EconomyState initialState,
    required PolicySettings policy,
    required int periods,
  }) {
    if (periods < minPeriods || periods > maxPeriods) {
      throw ArgumentError.value(
        periods,
        'periods',
        'Debe simular entre $minPeriods y $maxPeriods periodos',
      );
    }
    policy.validate();
    final results = <EconomyState>[];
    var current = initialState;
    for (var i = 0; i < periods; i++) {
      current = runPeriod(state: current, policy: policy);
      results.add(current);
    }
    return results;
  }
}
