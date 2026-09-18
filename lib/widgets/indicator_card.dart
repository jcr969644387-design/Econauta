import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Tarjeta compacta que muestra un indicador economico.
class IndicatorCard extends StatelessWidget {
  const IndicatorCard({
    super.key,
    required this.label,
    required this.value,
    this.detail,
    this.valueColor,
  });

  /// Nombre del indicador.
  final String label;

  /// Valor formateado del indicador.
  final String value;

  /// Texto secundario opcional.
  final String? detail;

  /// Color del valor principal.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailText = detail;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.surfaceSoft,
        border: Border.all(color: AppPalette.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppPalette.neutral,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: valueColor ?? AppPalette.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (detailText != null) const SizedBox(height: 2),
          if (detailText != null)
            Text(
              detailText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppPalette.neutral,
              ),
            ),
        ],
      ),
    );
  }
}
