import 'package:flutter/material.dart';

import '../calculators/gdp_calculator.dart';
import '../models/economy_state.dart';
import '../services/app_state.dart';
import '../services/history_utils.dart';
import '../widgets/app_palette.dart';
import '../widgets/app_theme.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/simple_bar_chart.dart';

/// Modulo 2: PIB, crecimiento y componentes del gasto.
class GdpScreen extends StatelessWidget {
  const GdpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final state = appState.current;
        return ScreenScaffold(
          title: 'PIB y crecimiento',
          children: <Widget>[
            SectionCard(
              title: 'Produccion del periodo ${state.period}',
              subtitle: GdpCalculator.classify(state.gdpGrowth),
              child: _GdpIndicators(state: state),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Componentes del gasto',
              subtitle: 'Consumo, inversion y gasto publico',
              child: SimpleBarChart(
                entries: _componentEntries(state),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Evolucion del crecimiento',
              subtitle: 'Ultimos periodos simulados',
              child: SimpleBarChart(
                entries: _growthEntries(appState.history),
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
        );
      },
    );
  }

  static List<ChartEntry> _componentEntries(EconomyState state) {
    return <ChartEntry>[
      ChartEntry(label: 'Consumo', value: state.consumption),
      ChartEntry(
        label: 'Inversion',
        value: state.investment,
        color: AppPalette.chartBarAlt,
      ),
      ChartEntry(label: 'Gasto', value: state.publicSpending),
    ];
  }

  static List<ChartEntry> _growthEntries(List<EconomyState> history) {
    final visible = HistoryUtils.last(history, 6);
    return visible.map((EconomyState item) {
      return ChartEntry(label: 'P${item.period}', value: item.gdpGrowth);
    }).toList();
  }

  static String _explanation(EconomyState state) {
    if (state.gdpGrowth < 0) {
      return 'La economia se contrajo. Cuando los impuestos son altos o el '
          'credito es caro, el consumo y la inversion caen y arrastran al '
          'PIB hacia abajo.';
    }
    if (state.gdpGrowth > 4.0) {
      return 'La economia crece con fuerza. Un impulso tan alto suele venir '
          'acompanado de mayor inflacion, porque la demanda supera a la '
          'capacidad de produccion.';
    }
    return 'El PIB crece a un ritmo cercano a su nivel potencial de '
        '2.5 %. Este es el escenario mas sostenible del modelo: crecimiento '
        'con presiones de precios moderadas.';
  }
}

class _GdpIndicators extends StatelessWidget {
  const _GdpIndicators({required this.state});

  final EconomyState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final growth = state.gdpGrowth;
    final color = growth >= 0 ? colors.positive : colors.negative;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: IndicatorCard(
                label: 'PIB',
                value: state.gdp.toStringAsFixed(1),
                detail: 'Unidades del modelo',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Crecimiento',
                value: '${growth.toStringAsFixed(2)} %',
                detail: 'Potencial: 2.5 %',
                valueColor: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: IndicatorCard(
                label: 'Consumo',
                value: state.consumption.toStringAsFixed(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Inversion',
                value: state.investment.toStringAsFixed(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Gasto publico',
                value: state.publicSpending.toStringAsFixed(1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
