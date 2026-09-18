import 'policy_settings.dart';

/// Fotografia completa de la economia ficticia en un periodo determinado.
class EconomyState {
  const EconomyState({
    required this.period,
    required this.gdp,
    required this.gdpGrowth,
    required this.consumption,
    required this.investment,
    required this.publicSpending,
    required this.inflation,
    required this.unemployment,
    required this.fiscalDeficit,
    required this.publicDebt,
    required this.stabilityIndex,
    required this.policy,
  });

  /// Estado inicial equilibrado del pais ficticio.
  ///
  /// Los valores corresponden a los supuestos documentados en `docs/README.md`:
  /// PIB base de 100 unidades, inflacion de 4 %, desempleo de 7 % y deuda
  /// publica de 45 % del PIB.
  static const EconomyState initial = EconomyState(
    period: 0,
    gdp: 100.0,
    gdpGrowth: 2.5,
    consumption: 60.0,
    investment: 20.0,
    publicSpending: 20.0,
    inflation: 4.0,
    unemployment: 7.0,
    fiscalDeficit: 2.56,
    publicDebt: 45.0,
    stabilityIndex: 89.0,
    policy: PolicySettings.initial,
  );

  /// Numero de periodo simulado (0 corresponde al punto de partida).
  final int period;

  /// PIB real en unidades del modelo.
  final double gdp;

  /// Crecimiento del PIB en porcentaje.
  final double gdpGrowth;

  /// Consumo privado en unidades del modelo.
  final double consumption;

  /// Inversion privada en unidades del modelo.
  final double investment;

  /// Gasto publico en unidades del modelo.
  final double publicSpending;

  /// Inflacion anual en porcentaje.
  final double inflation;

  /// Tasa de desempleo en porcentaje.
  final double unemployment;

  /// Deficit fiscal como porcentaje del PIB (negativo indica superavit).
  final double fiscalDeficit;

  /// Deuda publica como porcentaje del PIB.
  final double publicDebt;

  /// Indice educativo de estabilidad entre 0 y 100.
  final double stabilityIndex;

  /// Politica economica aplicada durante el periodo.
  final PolicySettings policy;

  /// Tasa de empleo en porcentaje.
  double get employment => 100.0 - unemployment;

  /// Meta de inflacion vigente.
  double get inflationTarget => policy.inflationTarget;

  /// Diferencia entre la inflacion observada y la meta.
  double get inflationGap => inflation - policy.inflationTarget;

  /// Indica si el resultado fiscal fue superavitario.
  bool get hasSurplus => fiscalDeficit < 0;

  EconomyState copyWith({
    int? period,
    double? gdp,
    double? gdpGrowth,
    double? consumption,
    double? investment,
    double? publicSpending,
    double? inflation,
    double? unemployment,
    double? fiscalDeficit,
    double? publicDebt,
    double? stabilityIndex,
    PolicySettings? policy,
  }) {
    return EconomyState(
      period: period ?? this.period,
      gdp: gdp ?? this.gdp,
      gdpGrowth: gdpGrowth ?? this.gdpGrowth,
      consumption: consumption ?? this.consumption,
      investment: investment ?? this.investment,
      publicSpending: publicSpending ?? this.publicSpending,
      inflation: inflation ?? this.inflation,
      unemployment: unemployment ?? this.unemployment,
      fiscalDeficit: fiscalDeficit ?? this.fiscalDeficit,
      publicDebt: publicDebt ?? this.publicDebt,
      stabilityIndex: stabilityIndex ?? this.stabilityIndex,
      policy: policy ?? this.policy,
    );
  }

  @override
  String toString() {
    return 'EconomyState(periodo: $period, pib: $gdp, crecimiento: $gdpGrowth, '
        'inflacion: $inflation, desempleo: $unemployment)';
  }
}
