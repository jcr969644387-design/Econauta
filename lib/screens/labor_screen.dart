import 'package:flutter/material.dart';

import '../calculators/labor_calculator.dart';
import '../models/economy_state.dart';
import '../services/app_state.dart';
import '../services/history_utils.dart';
import '../widgets/app_theme.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/simple_bar_chart.dart';

/// Modulo 3: empleo, desempleo y variacion del mercado laboral.
class LaborScreen extends StatelessWidget {
  const LaborScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final state = appState.current;
        final previous = appState.previous;
        return ScreenScaffold(
          title: 'Mercado laboral',
          children: <Widget>[
            SectionCard(
              title: 'Situacion del empleo',
              subtitle: LaborCalculator.classify(state.unemployment),
              child: _LaborIndicators(state: state, previous: previous),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Evolucion del desempleo',
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
        );
      },
    );
  }

  static List<ChartEntry> _entries(List<EconomyState> history) {
    final visible = HistoryUtils.last(history, 6);
    return visible.map((EconomyState item) {
      return ChartEntry(label: 'P${item.period}', value: item.unemployment);
    }).toList();
  }

  static String _explanation(EconomyState state) {
    final slack = LaborCalculator.slack(state.unemployment);
    if (slack > 2.0) {
      return 'Existe mucha capacidad ociosa en el mercado laboral. Segun la '
          'ley de Okun, para reducir el desempleo la economia necesita '
          'crecer por encima de su nivel potencial durante varios periodos.';
    }
    if (slack < -1.0) {
      return 'El mercado laboral esta muy ajustado. Con pocas personas '
          'disponibles, los salarios y los precios tienden a subir, lo que '
          'presiona la inflacion hacia arriba.';
    }
    return 'El desempleo se ubica cerca de su nivel natural de 5 %. En ese '
        'punto la economia usa sus recursos sin generar presiones de precios '
        'importantes.';
  }
}

class _LaborIndicators extends StatelessWidget {
  const _LaborIndicators({
    required this.state,
    required this.previous,
  });

  final EconomyState state;
  final EconomyState? previous;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final before = previous;
    final slack = LaborCalculator.slack(state.unemployment);
    final slackText = '${slack.toStringAsFixed(2)} pts';
    var variation = 'Sin periodos previos';
    var color = colors.heading;
    if (before != null) {
      final change = state.unemployment - before.unemployment;
      variation = 'Variacion: ${change.toStringAsFixed(2)} puntos';
      color = change <= 0 ? colors.positive : colors.negative;
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: IndicatorCard(
                label: 'Desempleo',
                value: '${state.unemployment.toStringAsFixed(2)} %',
                detail: variation,
                valueColor: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Empleo',
                value: '${state.employment.toStringAsFixed(2)} %',
                detail: 'Poblacion ocupada del modelo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IndicatorCard(
          label: 'Holgura laboral',
          value: slackText,
          detail: 'Diferencia con el desempleo natural de 5 %',
        ),
      ],
    );
  }
}
