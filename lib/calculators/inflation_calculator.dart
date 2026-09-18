import '../models/economic_constants.dart';

/// Reglas educativas para el calculo de la inflacion.
///
/// Regla aplicada:
/// `inflacion_siguiente = inflacion + demanda * 0.45 - brecha_laboral * 0.10
/// + (meta - inflacion) * 0.15`
class InflationCalculator {
  const InflationCalculator._();

  /// Sensibilidad de la inflacion al impulso de demanda.
  static const double demandSensitivity = 0.45;

  /// Sensibilidad de la inflacion a la holgura del mercado laboral.
  static const double laborSensitivity = 0.10;

  /// Velocidad con la que las expectativas se acercan a la meta.
  static const double anchoringSpeed = 0.15;

  static const double minInflation = -5.0;
  static const double maxInflation = 60.0;

  /// Calcula la inflacion del periodo siguiente.
  static double nextInflation({
    required double currentInflation,
    required double inflationTarget,
    required double demandImpulse,
    required double unemployment,
  }) {
    final demand = demandImpulse * demandSensitivity;
    final slack = unemployment - EconomicConstants.naturalUnemployment;
    final labor = -slack * laborSensitivity;
    final anchor = (inflationTarget - currentInflation) * anchoringSpeed;
    final value = currentInflation + demand + labor + anchor;
    return value.clamp(minInflation, maxInflation).toDouble();
  }

  /// Brecha entre la inflacion observada y la meta.
  static double gap({required double inflation, required double target}) {
    return inflation - target;
  }

  /// Clasificacion educativa de la inflacion respecto a la meta.
  static String classify({
    required double inflation,
    required double target,
  }) {
    final difference = inflation - target;
    if (difference > 2.0) {
      return 'Inflacion por encima de la meta';
    }
    if (difference < -2.0) {
      return 'Inflacion por debajo de la meta';
    }
    return 'Inflacion cercana a la meta';
  }
}
