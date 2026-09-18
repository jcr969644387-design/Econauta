import '../models/policy_settings.dart';

/// Reglas educativas de politica monetaria.
///
/// Regla aplicada:
/// `impulso_monetario = (tasa_neutral - tasa) * 0.25`
class MonetaryPolicyCalculator {
  const MonetaryPolicyCalculator._();

  /// Sensibilidad de la demanda a la tasa de interes.
  static const double rateSensitivity = 0.25;

  /// Impulso de demanda generado por la politica monetaria.
  static double monetaryImpulse(PolicySettings policy) {
    final gap = PolicySettings.neutralInterestRate - policy.interestRate;
    return gap * rateSensitivity;
  }

  /// Tasa de interes real aproximada.
  static double realInterestRate({
    required double interestRate,
    required double inflation,
  }) {
    return interestRate - inflation;
  }

  /// Clasificacion educativa de la orientacion monetaria.
  static String stance(PolicySettings policy) {
    final gap = policy.interestRate - PolicySettings.neutralInterestRate;
    if (gap > 1.0) {
      return 'Politica monetaria restrictiva';
    }
    if (gap < -1.0) {
      return 'Politica monetaria expansiva';
    }
    return 'Politica monetaria neutral';
  }

  /// Explicacion conceptual del efecto de la tasa sobre la economia.
  static String effectDescription(PolicySettings policy) {
    final gap = policy.interestRate - PolicySettings.neutralInterestRate;
    if (gap > 1.0) {
      return 'Una tasa mas alta encarece el credito, reduce la inversion y '
          'el consumo, y tiende a bajar la inflacion con menor crecimiento.';
    }
    if (gap < -1.0) {
      return 'Una tasa mas baja abarata el credito, estimula la inversion y '
          'el consumo, y tiende a subir la inflacion con mayor crecimiento.';
    }
    return 'Una tasa cercana al nivel neutral no estimula ni frena la '
        'economia de forma significativa.';
  }
}
