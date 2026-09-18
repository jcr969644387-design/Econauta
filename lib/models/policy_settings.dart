/// Parametros de politica economica que el estudiante puede modificar.
///
/// Todos los valores se expresan en porcentaje. Los impuestos y el gasto
/// publico se expresan como porcentaje del PIB.
class PolicySettings {
  const PolicySettings({
    required this.taxRate,
    required this.publicSpendingRate,
    required this.interestRate,
    required this.inflationTarget,
  });

  /// Configuracion inicial equilibrada con la que comienza la simulacion.
  static const PolicySettings initial = PolicySettings(
    taxRate: neutralTaxRate,
    publicSpendingRate: neutralSpendingRate,
    interestRate: neutralInterestRate,
    inflationTarget: 2.0,
  );

  /// Presion tributaria neutral de referencia (porcentaje del PIB).
  static const double neutralTaxRate = 18.0;

  /// Gasto publico neutral de referencia (porcentaje del PIB).
  static const double neutralSpendingRate = 20.0;

  /// Tasa de interes neutral de referencia (porcentaje).
  static const double neutralInterestRate = 5.0;

  static const double minTaxRate = 5.0;
  static const double maxTaxRate = 45.0;
  static const double minSpendingRate = 5.0;
  static const double maxSpendingRate = 45.0;
  static const double minInterestRate = 0.0;
  static const double maxInterestRate = 25.0;
  static const double minInflationTarget = 0.0;
  static const double maxInflationTarget = 10.0;

  /// Impuestos como porcentaje del PIB.
  final double taxRate;

  /// Gasto publico como porcentaje del PIB.
  final double publicSpendingRate;

  /// Tasa de interes de referencia del banco central.
  final double interestRate;

  /// Meta de inflacion anual.
  final double inflationTarget;

  PolicySettings copyWith({
    double? taxRate,
    double? publicSpendingRate,
    double? interestRate,
    double? inflationTarget,
  }) {
    return PolicySettings(
      taxRate: taxRate ?? this.taxRate,
      publicSpendingRate: publicSpendingRate ?? this.publicSpendingRate,
      interestRate: interestRate ?? this.interestRate,
      inflationTarget: inflationTarget ?? this.inflationTarget,
    );
  }

  /// Indica si todos los parametros estan dentro de los rangos permitidos.
  bool get isValid {
    try {
      validate();
      return true;
    } on ArgumentError {
      return false;
    }
  }

  /// Lanza [ArgumentError] cuando algun parametro esta fuera de rango.
  void validate() {
    _check('taxRate', taxRate, minTaxRate, maxTaxRate);
    _check(
      'publicSpendingRate',
      publicSpendingRate,
      minSpendingRate,
      maxSpendingRate,
    );
    _check('interestRate', interestRate, minInterestRate, maxInterestRate);
    _check(
      'inflationTarget',
      inflationTarget,
      minInflationTarget,
      maxInflationTarget,
    );
  }

  static void _check(String name, double value, double min, double max) {
    final invalid = value.isNaN || value.isInfinite;
    if (invalid || value < min || value > max) {
      throw ArgumentError.value(value, name, 'Valor fuera del rango permitido');
    }
  }

  @override
  String toString() {
    return 'PolicySettings(impuestos: $taxRate, gasto: $publicSpendingRate, '
        'tasa: $interestRate, meta: $inflationTarget)';
  }
}
