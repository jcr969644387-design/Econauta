/// Constantes de referencia del modelo educativo de Econauta.
///
/// Todos los valores son supuestos didacticos, no estimaciones reales de
/// ninguna economia en particular.
class EconomicConstants {
  const EconomicConstants._();

  /// Crecimiento potencial del PIB (porcentaje anual) usado como referencia.
  static const double baseGrowth = 2.5;

  /// Tasa de desempleo considerada "natural" en el modelo.
  static const double naturalUnemployment = 5.0;

  /// Deficit fiscal considerado prudente (porcentaje del PIB).
  static const double prudentDeficit = 3.0;

  /// Nivel de deuda publica a partir del cual aparece un costo educativo.
  static const double debtAlertLevel = 60.0;
}
