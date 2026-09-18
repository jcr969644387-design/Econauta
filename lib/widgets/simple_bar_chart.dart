import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Barra individual de un grafico simple.
class ChartEntry {
  const ChartEntry({required this.label, required this.value, this.color});

  /// Etiqueta mostrada debajo de la barra.
  final String label;

  /// Valor representado por la barra.
  final double value;

  /// Color opcional de la barra.
  final Color? color;
}

/// Grafico de barras basico construido solo con widgets de Flutter.
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.entries,
    this.height = 150,
    this.suffix = '',
    this.decimals = 1,
  });

  /// Barras a mostrar.
  final List<ChartEntry> entries;

  /// Altura total del grafico.
  final double height;

  /// Sufijo agregado al valor, por ejemplo " %".
  final String suffix;

  /// Cantidad de decimales mostrados.
  final int decimals;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    var maxValue = 0.0;
    for (final entry in entries) {
      final magnitude = entry.value.abs();
      if (magnitude > maxValue) {
        maxValue = magnitude;
      }
    }
    final safeMax = maxValue <= 0 ? 1.0 : maxValue;
    final barArea = height - 48;
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: entries.map((ChartEntry entry) {
          final ratio = entry.value.abs() / safeMax;
          final barHeight = (barArea * ratio).clamp(4.0, barArea);
          final isNegative = entry.value < 0;
          final custom = entry.color;
          var color = colors.accent;
          if (isNegative) {
            color = colors.negative;
          }
          if (custom != null) {
            color = custom;
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${entry.value.toStringAsFixed(decimals)}$suffix',
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0, end: barHeight),
                    builder: (BuildContext context, double size, Widget? _) {
                      return Container(
                        height: size,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.label,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
