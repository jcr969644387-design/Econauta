import '../models/economic_constants.dart';

/// Indice educativo de estabilidad economica (0 a 100).
///
/// El indice parte de 100 y descuenta penalidades por desviaciones de
/// inflacion, empleo, deuda, deficit y crecimiento. Es un indicador
/// didactico creado para esta aplicacion, no un indicador oficial.
class StabilityCalculator {
  const StabilityCalculator._();

  static const double inflationPenaltyFactor = 3.0;
  static const double laborPenaltyFactor = 2.5;
  static const double debtPenaltyFactor = 0.5;
  static const double deficitPenaltyFactor = 3.0;
  static const double growthPenaltyFactor = 2.0;

  /// Crecimiento minimo esperado antes de aplicar penalidad.
  static const double minExpectedGrowth = 2.0;

  /// Calcula el indice de estabilidad del periodo.
  static double index({
    required double inflation,
    required double inflationTarget,
    required double unemployment,
    required double publicDebt,
    required double fiscalDeficit,
    required double gdpGrowth,
  }) {
    final inflationGap = (inflation - inflationTarget).abs();
    final inflationPenalty = inflationGap * inflationPenaltyFactor;
    final slack = unemployment - EconomicConstants.naturalUnemployment;
    final laborPenalty = slack.abs() * laborPenaltyFactor;
    final debtExcess = _excess(publicDebt, EconomicConstants.debtAlertLevel);
    final debtPenalty = debtExcess * debtPenaltyFactor;
    final deficitExcess = _excess(
      fiscalDeficit,
      EconomicConstants.prudentDeficit,
    );
    final deficitPenalty = deficitExcess * deficitPenaltyFactor;
    final growthGap = _excess(minExpectedGrowth - gdpGrowth, 0.0);
    final growthPenalty = growthGap * growthPenaltyFactor;
    final macroPenalty = inflationPenalty + laborPenalty;
    final fiscalPenalty = debtPenalty + deficitPenalty + growthPenalty;
    final value = 100.0 - macroPenalty - fiscalPenalty;
    return value.clamp(0.0, 100.0).toDouble();
  }

  /// Clasificacion educativa del indice de estabilidad.
  static String classify(double index) {
    if (index >= 80.0) {
      return 'Economia estable';
    }
    if (index >= 60.0) {
      return 'Estabilidad moderada';
    }
    if (index >= 40.0) {
      return 'Estabilidad debil';
    }
    return 'Economia inestable';
  }

  static double _excess(double value, double threshold) {
    final difference = value - threshold;
    return difference > 0 ? difference : 0.0;
  }
}
