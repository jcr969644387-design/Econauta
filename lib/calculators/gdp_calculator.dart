import '../models/economic_constants.dart';
import '../models/policy_settings.dart';

/// Reglas educativas para el calculo del PIB y su crecimiento.
///
/// Regla aplicada:
/// `crecimiento = crecimiento_base + impulso_demanda - costo_deuda
/// - costo_inflacion`
class GdpCalculator {
  const GdpCalculator._();

  /// Costo de crecimiento por cada punto de deuda sobre el nivel de alerta.
  static const double debtDragFactor = 0.02;

  /// Inflacion a partir de la cual aparece un costo sobre el crecimiento.
  static const double inflationDragThreshold = 10.0;

  /// Costo de crecimiento por cada punto de inflacion excesiva.
  static const double inflationDragFactor = 0.10;

  static const double minGrowth = -8.0;
  static const double maxGrowth = 10.0;

  /// Participacion base del consumo en el PIB.
  static const double baseConsumptionShare = 0.60;

  /// Participacion base de la inversion en el PIB.
  static const double baseInvestmentShare = 0.20;

  /// Calcula el crecimiento del PIB del periodo.
  static double growth({
    required double demandImpulse,
    required double publicDebt,
    required double inflation,
  }) {
    final debtExcess = _excess(publicDebt, EconomicConstants.debtAlertLevel);
    final debtDrag = debtExcess * debtDragFactor;
    final inflationExcess = _excess(inflation, inflationDragThreshold);
    final inflationDrag = inflationExcess * inflationDragFactor;
    final gross = EconomicConstants.baseGrowth + demandImpulse;
    final value = gross - debtDrag - inflationDrag;
    return value.clamp(minGrowth, maxGrowth).toDouble();
  }

  /// Calcula el PIB del periodo siguiente a partir del crecimiento.
  static double nextGdp({required double gdp, required double growth}) {
    return gdp * (1.0 + growth / 100.0);
  }

  /// Consumo privado estimado del periodo.
  static double consumption({
    required double gdp,
    required PolicySettings policy,
  }) {
    final taxGap = policy.taxRate - PolicySettings.neutralTaxRate;
    final rateGap = policy.interestRate - PolicySettings.neutralInterestRate;
    final share = baseConsumptionShare - 0.005 * taxGap - 0.004 * rateGap;
    return gdp * share.clamp(0.20, 0.90);
  }

  /// Inversion privada estimada del periodo.
  static double investment({
    required double gdp,
    required PolicySettings policy,
  }) {
    final rateGap = policy.interestRate - PolicySettings.neutralInterestRate;
    final share = baseInvestmentShare - 0.010 * rateGap;
    return gdp * share.clamp(0.05, 0.40);
  }

  /// Gasto publico expresado en unidades del PIB.
  static double publicSpending({
    required double gdp,
    required PolicySettings policy,
  }) {
    return gdp * policy.publicSpendingRate / 100.0;
  }

  /// Clasificacion educativa del ritmo de crecimiento.
  static String classify(double growth) {
    if (growth >= 4.0) {
      return 'Expansion acelerada';
    }
    if (growth >= 2.0) {
      return 'Crecimiento sostenido';
    }
    if (growth >= 0.0) {
      return 'Crecimiento debil';
    }
    return 'Contraccion economica';
  }

  static double _excess(double value, double threshold) {
    final difference = value - threshold;
    return difference > 0 ? difference : 0.0;
  }
}
