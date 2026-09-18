import 'package:flutter/material.dart';

import '../calculators/monetary_policy_calculator.dart';
import '../models/policy_settings.dart';
import '../services/app_state.dart';
import '../widgets/app_palette.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/policy_slider.dart';

/// Modulo 5: politica monetaria con tasa de interes y meta de inflacion.
class MonetaryPolicyScreen extends StatefulWidget {
  const MonetaryPolicyScreen({super.key});

  @override
  State<MonetaryPolicyScreen> createState() => _MonetaryPolicyScreenState();
}

class _MonetaryPolicyScreenState extends State<MonetaryPolicyScreen> {
  late double _interestRate;
  late double _inflationTarget;

  @override
  void initState() {
    super.initState();
    _interestRate = appState.policy.interestRate;
    _inflationTarget = appState.policy.inflationTarget;
  }

  PolicySettings get _draft {
    return appState.policy.copyWith(
      interestRate: _interestRate,
      inflationTarget: _inflationTarget,
    );
  }

  void _apply() {
    final applied = appState.updatePolicy(_draft);
    final message = applied
        ? 'Politica monetaria aplicada. Simula para ver los efectos.'
        : 'Valores fuera de rango. Revisa los controles.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    final impulse = MonetaryPolicyCalculator.monetaryImpulse(draft);
    final state = appState.current;
    final realRate = MonetaryPolicyCalculator.realInterestRate(
      interestRate: _interestRate,
      inflation: state.inflation,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politica monetaria'),
        backgroundColor: AppPalette.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          SectionCard(
            title: 'Instrumentos monetarios',
            subtitle: MonetaryPolicyCalculator.stance(draft),
            child: Column(
              children: <Widget>[
                PolicySlider(
                  label: 'Tasa de interes',
                  value: _interestRate,
                  min: PolicySettings.minInterestRate,
                  max: PolicySettings.maxInterestRate,
                  helper: 'Nivel neutral de referencia: 5.0 %',
                  onChanged: (double value) {
                    setState(() {
                      _interestRate = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                PolicySlider(
                  label: 'Meta de inflacion',
                  value: _inflationTarget,
                  min: PolicySettings.minInflationTarget,
                  max: PolicySettings.maxInflationTarget,
                  helper: 'Ancla las expectativas del modelo',
                  onChanged: (double value) {
                    setState(() {
                      _inflationTarget = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Efecto conceptual',
            subtitle: 'Antes de ejecutar la simulacion',
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: IndicatorCard(
                        label: 'Impulso monetario',
                        value: impulse.toStringAsFixed(2),
                        detail: 'Puntos de demanda agregada',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IndicatorCard(
                        label: 'Tasa real',
                        value: '${realRate.toStringAsFixed(2)} %',
                        detail: 'Tasa nominal menos inflacion',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(MonetaryPolicyCalculator.effectDescription(draft)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _apply,
            icon: const Icon(Icons.check),
            label: const Text('Aplicar politica monetaria'),
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.primary,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: 16),
          const EducationalNotice(),
        ],
      ),
    );
  }
}
