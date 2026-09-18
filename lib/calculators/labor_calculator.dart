import '../models/economic_constants.dart';

/// Reglas educativas del mercado laboral, inspiradas en la ley de Okun.
///
/// Regla aplicada:
/// `desempleo_siguiente = desempleo - 0.5 * (crecimiento - crecimiento_base)`
class LaborCalculator {
  const LaborCalculator._();

  /// Factor de Okun simplificado.
  static const double okunFactor = 0.5;

  static const double minUnemployment = 1.0;
  static const double maxUnemployment = 30.0;

  /// Calcula la tasa de desempleo del periodo siguiente.
  static double nextUnemployment({
    required double unemployment,
    required double gdpGrowth,
  }) {
    final gap = gdpGrowth - EconomicConstants.baseGrowth;
    final value = unemployment - okunFactor * gap;
    return value.clamp(minUnemployment, maxUnemployment).toDouble();
  }

  /// Tasa de empleo asociada a una tasa de desempleo.
  static double employmentRate(double unemployment) {
    return 100.0 - unemployment;
  }

  /// Holgura del mercado laboral respecto al desempleo natural.
  static double slack(double unemployment) {
    return unemployment - EconomicConstants.naturalUnemployment;
  }

  /// Clasificacion educativa del mercado laboral.
  static String classify(double unemployment) {
    final difference = slack(unemployment);
    if (difference > 2.0) {
      return 'Mercado laboral con alta holgura';
    }
    if (difference < -1.0) {
      return 'Mercado laboral recalentado';
    }
    return 'Mercado laboral cercano a su nivel natural';
  }
}
