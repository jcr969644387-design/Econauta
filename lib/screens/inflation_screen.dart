import 'package:flutter/material.dart';

import '../calculators/inflation_calculator.dart';
import '../models/economy_state.dart';
import '../services/app_state.dart';
import '../services/history_utils.dart';
import '../widgets/app_palette.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/simple_bar_chart.dart';

/// Modulo 1: inflacion actual, meta, variacion y explicacion sencilla.
class InflationScreen extends StatelessWidget {
  const InflationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final state = appState.current;
        final previous = appState.previous;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Inflacion'),
            backgroundColor: AppPalette.primary,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              SectionCard(
                title: 'Situacion actual',
                subtitle: InflationCalculator.classify(
                  inflation: state.inflation,
                  target: state.inflationTarget,
                ),
                child: _InflationIndicators(
                  state: state,
                  previous: previous,
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Evolucion de la inflacion',
                subtitle: 'Ultimos periodos simulados',
                child: SimpleBarChart(
                  entries: _entries(appState.history),
                  suffix: ' %',
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Explicacion educativa',
                child: Text(_explanation(state)),
              ),
              const SizedBox(height: 16),
              const EducationalNotice(),
            ],
          ),
        );
      },
    );
  }

  static List<ChartEntry> _entries(List<EconomyState> history) {
    final visible = HistoryUtils.last(history, 6);
    return visible.map((EconomyState item) {
      return ChartEntry(
        label: 'P${item.period}',
        value: item.inflation,
      );
    }).toList();
  }

  static String _explanation(EconomyState state) {
    final gap = state.inflationGap;
    if (gap > 1.0) {
      return 'La inflacion supera la meta en ${gap.toStringAsFixed(2)} '
          'puntos. En el modelo, el exceso de demanda y un mercado laboral '
          'ajustado presionan los precios. Para corregirlo puedes subir la '
          'tasa de interes o reducir el impulso fiscal.';
    }
    if (gap < -1.0) {
      final distance = gap.abs().toStringAsFixed(2);
      return 'La inflacion esta $distance puntos por debajo de la meta. Una '
          'inflacion demasiado baja suele acompanar a una demanda debil. '
          'Puedes bajar la tasa de interes o aumentar el gasto publico.';
    }
    return 'La inflacion se encuentra cerca de la meta. Cuando esto ocurre, '
        'las expectativas quedan ancladas y las familias y empresas pueden '
        'planificar con mayor certeza.';
  }
}

class _InflationIndicators extends StatelessWidget {
  const _InflationIndicators({
    required this.state,
    required this.previous,
  });

  final EconomyState state;
  final EconomyState? previous;

  @override
  Widget build(BuildContext context) {
    final before = previous;
    var variation = 'Sin periodos previos';
    if (before != null) {
      final change = state.inflation - before.inflation;
      variation = 'Variacion: ${change.toStringAsFixed(2)} puntos';
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: IndicatorCard(
                label: 'Inflacion actual',
                value: '${state.inflation.toStringAsFixed(2)} %',
                detail: variation,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Meta de inflacion',
                value: '${state.inflationTarget.toStringAsFixed(1)} %',
                detail: 'Definida en politica monetaria',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IndicatorCard(
          label: 'Brecha respecto a la meta',
          value: '${state.inflationGap.toStringAsFixed(2)} puntos',
          detail: 'Diferencia entre inflacion observada y meta',
        ),
      ],
    );
  }
}
