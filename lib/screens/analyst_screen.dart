import 'package:flutter/material.dart';

import '../models/analyst_insight.dart';
import '../services/app_state.dart';
import '../services/economic_analyst.dart';
import '../widgets/app_theme.dart';
import '../widgets/educational_notice.dart';
import '../widgets/screen_scaffold.dart';

/// Modulo 8: analista economico local basado en reglas.
class AnalystScreen extends StatelessWidget {
  const AnalystScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final insights = appState.insights;
        final state = appState.current;
        return ScreenScaffold(
          title: 'Analista economico',
          children: <Widget>[
            SectionCard(
              title: 'Lectura general',
              subtitle: 'Periodo ${state.period}',
              child: Text(EconomicAnalyst.summary(state)),
            ),
            const SizedBox(height: 16),
            if (insights.isEmpty)
              SectionCard(
                title: 'Sin analisis disponible',
                child: const Text(
                  'Ejecuta una simulacion en el modulo Simulacion para que '
                  'el analista explique por que cambiaron los indicadores.',
                ),
              ),
            ...insights.map((AnalystInsight insight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InsightCard(insight: insight),
              );
            }),
            const SizedBox(height: 4),
            const EducationalNotice(
              message: 'El analista funciona sin Internet y sin servicios '
                  'externos: aplica reglas educativas transparentes sobre '
                  'los resultados de la simulacion.',
            ),
          ],
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final AnalystInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    var color = colors.muted;
    var icon = Icons.info_outline;
    if (insight.tone == InsightTone.positive) {
      color = colors.positive;
      icon = Icons.trending_up;
    } else if (insight.tone == InsightTone.negative) {
      color = colors.negative;
      icon = Icons.trending_down;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  insight.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(insight.message, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
