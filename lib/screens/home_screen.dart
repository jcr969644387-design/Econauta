import 'package:flutter/material.dart';

import '../calculators/stability_calculator.dart';
import '../models/economy_state.dart';
import '../services/app_state.dart';
import '../services/feedback_service.dart';
import '../widgets/app_theme.dart';
import '../widgets/app_transitions.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/module_button.dart';
import '../widgets/screen_scaffold.dart';
import 'analyst_screen.dart';
import 'evaluation_screen.dart';
import 'fiscal_policy_screen.dart';
import 'gdp_screen.dart';
import 'inflation_screen.dart';
import 'labor_screen.dart';
import 'monetary_policy_screen.dart';
import 'settings_screen.dart';
import 'simulation_screen.dart';

/// Pantalla principal de Econauta.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (BuildContext context, Widget? child) {
        final theme = Theme.of(context);
        final colors = AppColors.of(context);
        final state = appState.current;
        return ScreenScaffold(
          title: 'Econauta',
          actions: <Widget>[
            IconButton(
              tooltip: 'Reiniciar economia',
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt),
            ),
            IconButton(
              tooltip: 'Configuracion',
              onPressed: () => _openSettings(context),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
          children: <Widget>[
            _Header(state: state),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Panorama del periodo ${state.period}',
              subtitle: StabilityCalculator.classify(state.stabilityIndex),
              child: _IndicatorGrid(state: state),
            ),
            const SizedBox(height: 16),
            Text(
              'Modulos educativos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.heading,
              ),
            ),
            const SizedBox(height: 12),
            const _ModuleGrid(),
            const SizedBox(height: 16),
            const EducationalNotice(),
          ],
        );
      },
    );
  }

  void _reset() {
    feedback.confirm();
    appState.reset();
  }

  void _openSettings(BuildContext context) {
    feedback.tap();
    Navigator.of(context).push(
      AppTransitions.fade<void>((BuildContext context) {
        return const SettingsScreen();
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final EconomyState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.headerSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Simulador de politica economica',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.headerText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Administra una economia ficticia, aplica politicas y observa '
            'las consecuencias de tus decisiones.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.headerText.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorGrid extends StatelessWidget {
  const _IndicatorGrid({required this.state});

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
                label: 'Crecimiento del PIB',
                value: '${growth.toStringAsFixed(2)} %',
                detail: 'PIB: ${state.gdp.toStringAsFixed(1)}',
                valueColor: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Inflacion',
                value: '${state.inflation.toStringAsFixed(2)} %',
                detail: 'Meta: ${state.inflationTarget.toStringAsFixed(1)} %',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: IndicatorCard(
                label: 'Desempleo',
                value: '${state.unemployment.toStringAsFixed(2)} %',
                detail: 'Empleo: ${state.employment.toStringAsFixed(1)} %',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndicatorCard(
                label: 'Estabilidad',
                value: state.stabilityIndex.toStringAsFixed(0),
                detail: 'Deuda: ${state.publicDebt.toStringAsFixed(1)} % PIB',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid();

  @override
  Widget build(BuildContext context) {
    final modules = <_ModuleData>[
      _ModuleData(
        title: 'Inflacion',
        description: 'Meta, brecha y variacion de precios.',
        icon: Icons.trending_up,
        builder: () => const InflationScreen(),
      ),
      _ModuleData(
        title: 'PIB y crecimiento',
        description: 'Consumo, inversion y gasto publico.',
        icon: Icons.bar_chart,
        builder: () => const GdpScreen(),
      ),
      _ModuleData(
        title: 'Mercado laboral',
        description: 'Empleo, desempleo y su variacion.',
        icon: Icons.groups,
        builder: () => const LaborScreen(),
      ),
      _ModuleData(
        title: 'Politica fiscal',
        description: 'Impuestos y gasto publico.',
        icon: Icons.account_balance,
        builder: () => const FiscalPolicyScreen(),
      ),
      _ModuleData(
        title: 'Politica monetaria',
        description: 'Tasa de interes y meta de inflacion.',
        icon: Icons.savings,
        builder: () => const MonetaryPolicyScreen(),
      ),
      _ModuleData(
        title: 'Simulacion',
        description: 'Ejecuta de 1 a 5 periodos y compara.',
        icon: Icons.play_circle_outline,
        builder: () => const SimulationScreen(),
      ),
      _ModuleData(
        title: 'Evaluacion',
        description: 'Preguntas cortas con retroalimentacion.',
        icon: Icons.quiz_outlined,
        builder: () => const EvaluationScreen(),
      ),
      _ModuleData(
        title: 'Analista economico',
        description: 'Explicaciones locales de cada resultado.',
        icon: Icons.psychology_alt_outlined,
        builder: () => const AnalystScreen(),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: modules.map((_ModuleData module) {
        return ModuleButton(
          title: module.title,
          description: module.description,
          icon: module.icon,
          onPressed: () {
            Navigator.of(context).push(
              AppTransitions.fade<void>((BuildContext context) {
                return module.builder();
              }),
            );
          },
        );
      }).toList(),
    );
  }
}

class _ModuleData {
  _ModuleData({
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget Function() builder;
}
