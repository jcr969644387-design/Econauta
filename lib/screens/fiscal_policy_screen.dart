import 'package:flutter/material.dart';

import '../calculators/fiscal_policy_calculator.dart';
import '../models/policy_settings.dart';
import '../services/app_state.dart';
import '../services/feedback_service.dart';
import '../widgets/educational_notice.dart';
import '../widgets/indicator_card.dart';
import '../widgets/policy_slider.dart';
import '../widgets/screen_scaffold.dart';

/// Modulo 4: politica fiscal con impuestos y gasto publico.
class FiscalPolicyScreen extends StatefulWidget {
  const FiscalPolicyScreen({super.key});

  @override
  State<FiscalPolicyScreen> createState() => _FiscalPolicyScreenState();
}

class _FiscalPolicyScreenState extends State<FiscalPolicyScreen> {
  late double _taxRate;
  late double _spendingRate;

  @override
  void initState() {
    super.initState();
    _taxRate = appState.policy.taxRate;
    _spendingRate = appState.policy.publicSpendingRate;
  }

  PolicySettings get _draft {
    return appState.policy.copyWith(
      taxRate: _taxRate,
      publicSpendingRate: _spendingRate,
    );
  }

  void _apply() {
    final applied = appState.updatePolicy(_draft);
    if (applied) {
      feedback.confirm();
    } else {
      feedback.warning();
    }
    final message = applied
        ? 'Politica fiscal aplicada. Simula para ver los efectos.'
        : 'Valores fuera de rango. Revisa los controles.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    final impulse = FiscalPolicyCalculator.fiscalImpulse(draft);
    final state = appState.current;
    final deficit = FiscalPolicyCalculator.fiscalDeficit(
      policy: draft,
      gdpGrowth: state.gdpGrowth,
      publicDebt: state.publicDebt,
    );
    return ScreenScaffold(
      title: 'Politica fiscal',
      children: <Widget>[
        SectionCard(
          title: 'Instrumentos fiscales',
          subtitle: FiscalPolicyCalculator.stance(draft),
          child: Column(
            children: <Widget>[
              PolicySlider(
                label: 'Impuestos (% del PIB)',
                value: _taxRate,
                min: PolicySettings.minTaxRate,
                max: PolicySettings.maxTaxRate,
                helper: 'Nivel neutral de referencia: 18.0 %',
                onChanged: (double value) {
                  setState(() {
                    _taxRate = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              PolicySlider(
                label: 'Gasto publico (% del PIB)',
                value: _spendingRate,
                min: PolicySettings.minSpendingRate,
                max: PolicySettings.maxSpendingRate,
                helper: 'Nivel neutral de referencia: 20.0 %',
                onChanged: (double value) {
                  setState(() {
                    _spendingRate = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Efecto estimado',
          subtitle: 'Calculo educativo antes de simular',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: IndicatorCard(
                      label: 'Impulso fiscal',
                      value: impulse.toStringAsFixed(2),
                      detail: 'Puntos de demanda agregada',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IndicatorCard(
                      label: 'Deficit proyectado',
                      value: '${deficit.toStringAsFixed(2)} %',
                      detail: 'Porcentaje del PIB',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(_explanation(impulse)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _apply,
          icon: const Icon(Icons.check),
          label: const Text('Aplicar politica fiscal'),
        ),
        const SizedBox(height: 16),
        const EducationalNotice(),
      ],
    );
  }

  static String _explanation(double impulse) {
    if (impulse > 0.5) {
      return 'Politica expansiva: mas gasto publico o menos impuestos '
          'aumentan la demanda agregada. Esperas mas crecimiento y mas '
          'empleo, con el riesgo de mayor inflacion y mayor deficit.';
    }
    if (impulse < -0.5) {
      return 'Politica contractiva: menos gasto publico o mas impuestos '
          'reducen la demanda agregada. Esperas menos inflacion y mejor '
          'resultado fiscal, con el costo de menor crecimiento y empleo.';
    }
    return 'Politica cercana a la posicion neutral: el presupuesto publico '
        'no agrega ni retira impulso significativo a la demanda agregada.';
  }
}
