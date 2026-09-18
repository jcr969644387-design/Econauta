import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Aviso permanente sobre el caracter educativo de la simulacion.
class EducationalNotice extends StatelessWidget {
  const EducationalNotice({super.key, this.message});

  /// Texto alternativo del aviso.
  final String? message;

  /// Texto por defecto mostrado en la aplicacion.
  static const String defaultMessage =
      'Simulacion educativa con reglas simplificadas. No es una prediccion '
      'economica ni reemplaza modelos econometricos o analisis profesional.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.noticeSurface,
        border: Border.all(color: colors.noticeBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline, size: 18, color: colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? defaultMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta simple con titulo y contenido, usada en todas las pantallas.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  /// Titulo de la seccion.
  final String title;

  /// Subtitulo opcional.
  final String? subtitle;

  /// Contenido de la seccion.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtitleText = subtitle;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.heading,
            ),
          ),
          if (subtitleText != null) const SizedBox(height: 4),
          if (subtitleText != null)
            Text(
              subtitleText,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.muted),
            ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
