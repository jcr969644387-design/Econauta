import 'package:flutter/material.dart';

import 'app_theme.dart';

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
    final colors = AppColors.of(context);
    final detailText = detail;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.softSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 4),
          // El valor se desvanece al cambiar para que se note la simulacion.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: Text(
              value,
              key: ValueKey<String>(value),
              style: theme.textTheme.titleLarge?.copyWith(
                color: valueColor ?? colors.heading,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (detailText != null) const SizedBox(height: 2),
          if (detailText != null)
            Text(
              detailText,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }
}
