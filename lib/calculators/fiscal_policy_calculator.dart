import '../models/economic_constants.dart';
import '../models/policy_settings.dart';

/// Reglas educativas de politica fiscal.
///
/// Reglas aplicadas:
/// `impulso_fiscal = (gasto - gasto_neutral) * 0.30
/// + (impuestos_neutrales - impuestos) * 0.20`
/// `deficit = gasto + intereses - ingresos`
class FiscalPolicyCalculator {
  const FiscalPolicyCalculator._();

  /// Sensibilidad de la demanda al gasto publico.
  static const double spendingSensitivity = 0.30;

  /// Sensibilidad de la demanda a los impuestos.
  static const double taxSensitivity = 0.20;

  /// Elasticidad de la recaudacion al ciclo economico.
  static const double revenueElasticity = 0.10;

  /// Proporcion de la deuda que genera intereses en cada periodo.
  static const double debtInterestShare = 0.25;

  static const double maxDebt = 200.0;

  /// Impulso de demanda generado por la politica fiscal.
  static double fiscalImpulse(PolicySettings policy) {
    final neutral = PolicySettings.neutralSpendingRate;
    final spendingGap = policy.publicSpendingRate - neutral;
    final taxGap = PolicySettings.neutralTaxRate - policy.taxRate;
    return spendingGap * spendingSensitivity + taxGap * taxSensitivity;
  }

  /// Ingresos publicos como porcentaje del PIB.
  static double publicRevenue({
    required PolicySettings policy,
    required double gdpGrowth,
  }) {
    final cycle = gdpGrowth - EconomicConstants.baseGrowth;
    return policy.taxRate + cycle * revenueElasticity;
  }

  /// Costo de intereses de la deuda como porcentaje del PIB.
  static double interestBurden({
    required double publicDebt,
    required double interestRate,
  }) {
    return publicDebt * (interestRate / 100.0) * debtInterestShare;
  }

  /// Deficit fiscal como porcentaje del PIB (negativo indica superavit).
  static double fiscalDeficit({
    required PolicySettings policy,
    required double gdpGrowth,
    required double publicDebt,
  }) {
    final revenue = publicRevenue(policy: policy, gdpGrowth: gdpGrowth);
    final interest = interestBurden(
      publicDebt: publicDebt,
      interestRate: policy.interestRate,
    );
    return policy.publicSpendingRate + interest - revenue;
  }

  /// Deuda publica del periodo siguiente como porcentaje del PIB.
  static double nextPublicDebt({
    required double publicDebt,
    required double fiscalDeficit,
    required double gdpGrowth,
    required double inflation,
  }) {
    final nominalGrowth = (gdpGrowth + inflation) / 100.0;
    final denominator = 1.0 + nominalGrowth;
    if (denominator <= 0.1) {
      return maxDebt;
    }
    final value = (publicDebt + fiscalDeficit) / denominator;
    return value.clamp(0.0, maxDebt).toDouble();
  }

  /// Clasificacion educativa de la orientacion fiscal.
  static String stance(PolicySettings policy) {
    final impulse = fiscalImpulse(policy);
    if (impulse > 0.5) {
      return 'Politica fiscal expansiva';
    }
    if (impulse < -0.5) {
      return 'Politica fiscal contractiva';
    }
    return 'Politica fiscal neutral';
  }
}
