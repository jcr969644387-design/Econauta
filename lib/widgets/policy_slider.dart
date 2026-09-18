import 'package:flutter/material.dart';

import '../services/feedback_service.dart';
import 'app_theme.dart';

/// Control deslizante usado para modificar un parametro de politica.
class PolicySlider extends StatelessWidget {
  const PolicySlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.suffix = ' %',
    this.helper,
  });

  /// Nombre del parametro.
  final String label;

  /// Valor actual.
  final double value;

  /// Valor minimo permitido.
  final double min;

  /// Valor maximo permitido.
  final double max;

  /// Callback ejecutado al mover el control.
  final ValueChanged<double> onChanged;

  /// Sufijo mostrado junto al valor.
  final String suffix;

  /// Texto educativo opcional.
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final helperText = helper;
    final divisions = ((max - min) * 2).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: theme.textTheme.titleSmall),
            Text(
              '${value.toStringAsFixed(1)}$suffix',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions > 0 ? divisions : null,
          label: value.toStringAsFixed(1),
          activeColor: colors.accent,
          onChanged: _handleChanged,
        ),
        if (helperText != null)
          Text(
            helperText,
            style: theme.textTheme.bodySmall?.copyWith(color: colors.muted),
          ),
      ],
    );
  }

  void _handleChanged(double next) {
    // Vibracion muy corta en cada paso, como en los controles del sistema.
    feedback.vibrate(AppHaptic.light);
    onChanged(next);
  }
}
