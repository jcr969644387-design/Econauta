import '../calculators/fiscal_policy_calculator.dart';
import '../calculators/gdp_calculator.dart';
import '../calculators/monetary_policy_calculator.dart';
import '../calculators/stability_calculator.dart';
import '../models/analyst_insight.dart';
import '../models/economic_constants.dart';
import '../models/economy_state.dart';

/// Analista economico local basado en reglas.
///
/// Funciona completamente sin conexion a Internet, sin API externa y sin
/// claves secretas. Compara dos estados de la economia y explica en lenguaje
/// sencillo por que cambiaron los indicadores.
class EconomicAnalyst {
  const EconomicAnalyst._();

  /// Genera los comentarios educativos entre dos periodos.
  static List<AnalystInsight> analyze({
    required EconomyState previous,
    required EconomyState current,
  }) {
    return <AnalystInsight>[
      _policyInsight(current),
      _growthInsight(previous, current),
      _inflationInsight(previous, current),
      _laborInsight(previous, current),
      _fiscalInsight(previous, current),
      _debtInsight(previous, current),
      _stabilityInsight(previous, current),
    ];
  }

  /// Resumen corto del estado actual de la economia.
  static String summary(EconomyState state) {
    final classification = StabilityCalculator.classify(state.stabilityIndex);
    final growth = GdpCalculator.classify(state.gdpGrowth);
    return '$classification. $growth con inflacion de '
        '${state.inflation.toStringAsFixed(1)} % y desempleo de '
        '${state.unemployment.toStringAsFixed(1)} %.';
  }

  static AnalystInsight _policyInsight(EconomyState current) {
    final fiscal = FiscalPolicyCalculator.stance(current.policy);
    final monetary = MonetaryPolicyCalculator.stance(current.policy);
    return AnalystInsight(
      title: 'Politica aplicada',
      message: '$fiscal combinada con $monetary. Los impuestos estan en '
          '${current.policy.taxRate.toStringAsFixed(1)} % del PIB, el gasto '
          'publico en ${current.policy.publicSpendingRate.toStringAsFixed(1)} '
          '% del PIB y la tasa de interes en '
          '${current.policy.interestRate.toStringAsFixed(1)} %.',
      tone: InsightTone.neutral,
    );
  }

  static AnalystInsight _growthInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final change = current.gdpGrowth - previous.gdpGrowth;
    final value = current.gdpGrowth.toStringAsFixed(2);
    if (current.gdpGrowth < 0) {
      return AnalystInsight(
        title: 'Crecimiento',
        message: 'El PIB se contrajo $value %. La demanda agregada no alcanza '
            'para sostener la produccion: revise si los impuestos altos o la '
            'tasa de interes elevada estan frenando consumo e inversion.',
        tone: InsightTone.negative,
      );
    }
    if (change > 0.1) {
      return AnalystInsight(
        title: 'Crecimiento',
        message: 'El PIB crecio $value %, por encima del periodo anterior. El '
            'mayor gasto publico o el credito mas barato impulsaron la '
            'demanda agregada.',
        tone: InsightTone.positive,
      );
    }
    if (change < -0.1) {
      return AnalystInsight(
        title: 'Crecimiento',
        message: 'El PIB crecio $value %, menos que en el periodo anterior. '
            'El costo de la deuda o la inflacion alta estan restando impulso.',
        tone: InsightTone.negative,
      );
    }
    return AnalystInsight(
      title: 'Crecimiento',
      message: 'El PIB crecio $value %, en linea con el periodo anterior. La '
          'politica economica se mantuvo cerca de su posicion neutral.',
      tone: InsightTone.neutral,
    );
  }

  static AnalystInsight _inflationInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final change = current.inflation - previous.inflation;
    final value = current.inflation.toStringAsFixed(2);
    final target = current.inflationTarget.toStringAsFixed(1);
    if (current.inflationGap.abs() <= 1.0) {
      return AnalystInsight(
        title: 'Inflacion',
        message: 'La inflacion es $value % y se ubica cerca de la meta de '
            '$target %. Las expectativas estan ancladas.',
        tone: InsightTone.positive,
      );
    }
    if (change > 0.1) {
      return AnalystInsight(
        title: 'Inflacion',
        message: 'La inflacion subio a $value %, alejandose de la meta de '
            '$target %. El exceso de demanda y el mercado laboral ajustado '
            'presionan los precios.',
        tone: InsightTone.negative,
      );
    }
    if (change < -0.1) {
      return AnalystInsight(
        title: 'Inflacion',
        message: 'La inflacion bajo a $value % frente a una meta de $target '
            '%. El enfriamiento de la demanda ayudo a moderar los precios.',
        tone: InsightTone.positive,
      );
    }
    return AnalystInsight(
      title: 'Inflacion',
      message: 'La inflacion se mantuvo en $value % frente a una meta de '
          '$target %. Todavia existe una brecha que corregir.',
      tone: InsightTone.neutral,
    );
  }

  static AnalystInsight _laborInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final change = current.unemployment - previous.unemployment;
    final value = current.unemployment.toStringAsFixed(2);
    if (change < -0.05) {
      return AnalystInsight(
        title: 'Empleo',
        message: 'El desempleo bajo a $value %. Cuando la economia crece por '
            'encima de su ritmo potencial, las empresas contratan mas '
            'trabajadores (ley de Okun).',
        tone: InsightTone.positive,
      );
    }
    if (change > 0.05) {
      return AnalystInsight(
        title: 'Empleo',
        message: 'El desempleo subio a $value %. Un crecimiento por debajo '
            'del potencial reduce la creacion de puestos de trabajo.',
        tone: InsightTone.negative,
      );
    }
    return AnalystInsight(
      title: 'Empleo',
      message: 'El desempleo se mantuvo en $value %, cerca de su nivel '
          'natural de ${EconomicConstants.naturalUnemployment} %.',
      tone: InsightTone.neutral,
    );
  }

  static AnalystInsight _fiscalInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final value = current.fiscalDeficit.abs().toStringAsFixed(2);
    if (current.hasSurplus) {
      return AnalystInsight(
        title: 'Resultado fiscal',
        message: 'El sector publico logro un superavit de $value % del PIB. '
            'Los ingresos por impuestos superaron al gasto mas los intereses.',
        tone: InsightTone.positive,
      );
    }
    final excessive = current.fiscalDeficit > EconomicConstants.prudentDeficit;
    if (excessive) {
      return AnalystInsight(
        title: 'Resultado fiscal',
        message: 'El deficit llego a $value % del PIB, por encima del limite '
            'prudente de ${EconomicConstants.prudentDeficit} %. Sostenerlo '
            'obliga a endeudarse mas cada periodo.',
        tone: InsightTone.negative,
      );
    }
    return AnalystInsight(
      title: 'Resultado fiscal',
      message: 'El deficit fue de $value % del PIB, dentro de un rango '
          'manejable para la economia simulada.',
      tone: InsightTone.neutral,
    );
  }

  static AnalystInsight _debtInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final change = current.publicDebt - previous.publicDebt;
    final value = current.publicDebt.toStringAsFixed(1);
    if (current.publicDebt > EconomicConstants.debtAlertLevel) {
      return AnalystInsight(
        title: 'Deuda publica',
        message: 'La deuda alcanzo $value % del PIB y supera el nivel de '
            'alerta de ${EconomicConstants.debtAlertLevel} %. En el modelo, '
            'cada punto adicional resta crecimiento futuro.',
        tone: InsightTone.negative,
      );
    }
    if (change > 0.2) {
      return AnalystInsight(
        title: 'Deuda publica',
        message: 'La deuda subio a $value % del PIB por el deficit acumulado, '
            'aunque todavia se mantiene en un rango controlado.',
        tone: InsightTone.neutral,
      );
    }
    return AnalystInsight(
      title: 'Deuda publica',
      message: 'La deuda se ubica en $value % del PIB. El crecimiento nominal '
          'ayuda a diluir el peso de la deuda existente.',
      tone: InsightTone.positive,
    );
  }

  static AnalystInsight _stabilityInsight(
    EconomyState previous,
    EconomyState current,
  ) {
    final change = current.stabilityIndex - previous.stabilityIndex;
    final value = current.stabilityIndex.toStringAsFixed(0);
    final label = StabilityCalculator.classify(current.stabilityIndex);
    if (change > 1.0) {
      return AnalystInsight(
        title: 'Estabilidad',
        message: 'El indice educativo de estabilidad subio a $value puntos '
            '($label). Las decisiones acercaron la economia a sus objetivos.',
        tone: InsightTone.positive,
      );
    }
    if (change < -1.0) {
      return AnalystInsight(
        title: 'Estabilidad',
        message: 'El indice educativo de estabilidad bajo a $value puntos '
            '($label). Existe un costo por desviarse de las metas de '
            'inflacion, empleo o disciplina fiscal.',
        tone: InsightTone.negative,
      );
    }
    return AnalystInsight(
      title: 'Estabilidad',
      message: 'El indice educativo de estabilidad se mantuvo en $value '
          'puntos ($label).',
      tone: InsightTone.neutral,
    );
  }
}
