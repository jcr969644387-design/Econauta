import 'package:flutter/material.dart';

import 'app_palette.dart';

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
                color: AppPalette.primary,
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
          activeColor: AppPalette.primary,
          onChanged: onChanged,
        ),
        if (helperText != null)
          Text(
            helperText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppPalette.neutral,
            ),
          ),
      ],
    );
  }
}
